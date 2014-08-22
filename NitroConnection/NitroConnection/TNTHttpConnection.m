 //
//  TNTHttpConnection.m
//  NitroConnection
//
//  Created by Daniel L. Alves on 31/03/11.
//  Copyright 2011 Daniel L. Alves. All rights reserved.
//

#import "TNTHttpConnection.h"

// NitroConnection
#import "NSDictionary+QueryString.h"
#import "TNTHttpStatusCodes.h"

// Pods
#import <NitroMisc/NTRLogging.h>

#pragma mark - Defines

#if DEBUG
	#define DEFAULT_CONNECTION_TIMEOUT_INTERVAL_SECS 30
#else
	#define DEFAULT_CONNECTION_TIMEOUT_INTERVAL_SECS 3
#endif

#define K_BYTE 1024

#pragma mark - Constants

NSString * const TNTHttpConnectionErrorDomain = @"TNTHttpConnectionErrorDomain";

const NSInteger TNTHttpConnectionErrorCodeHttpError = 1;

NSString * const TNTHttpConnectionErrorUserInfoResponseKey = @"TNTHttpConnectionErrorUserInfoResponseKey";
NSString * const TNTHttpConnectionErrorUserInfoDataKey = @"TNTHttpConnectionErrorUserInfoDataKey";

#pragma mark - Statics

static NSTimeInterval TNTHttpConnectionDefaultTimeoutInterval;
static NSURLRequestCachePolicy TNTHttpConnectionDefaultCachePolicy;

static NSMutableDictionary *managedConnections;
static NSLock *managedConnectionsLock;

#pragma mark - Helper Types

typedef void( ^TNTHttpConnectionNotificationBlock )( TNTHttpConnection *httpConnection );

@class TNTHttpConnection;

@interface TNTNSURLConnectionProxy : NSObject< NSURLConnectionDataDelegate >

@property( nonatomic, readwrite, weak )id< NSURLConnectionDataDelegate > target;

@end

@implementation TNTNSURLConnectionProxy

#pragma mark - NSURLConnectionDelegate

-( void )connectionDidFinishLoading:( NSURLConnection * )urlConnection
{
    if( !_target )
        return;
    
    @synchronized( _target )
    {
        // We do not use respondsToSelector: since we know TNTHttpConnection does repond
        [_target connectionDidFinishLoading: urlConnection];
    }
}

-( void )connection:( NSURLConnection * )connection didReceiveData:( NSData * )data
{
    if( !_target )
        return;
    
    @synchronized( _target )
    {
        // We do not use respondsToSelector: since we know TNTHttpConnection does repond
        [_target connection: connection didReceiveData: data];
    }
}

-( void )connection:( NSURLConnection * )connection didReceiveResponse:( NSHTTPURLResponse * )response
{
    if( !_target )
        return;
    
    @synchronized( _target )
    {
        // We do not use respondsToSelector: since we know TNTHttpConnection does repond
        [_target connection: connection didReceiveResponse: response];
    }
}

-( void )connection:( NSURLConnection * )connection didFailWithError:( NSError * )error
{
    if( !_target )
        return;
    
    @synchronized( _target )
    {
        // We do not use respondsToSelector: since we know TNTHttpConnection does repond
        [_target connection: connection didFailWithError: error];
    }
}

@end

#pragma mark - Class Extension

@interface TNTHttpConnection()< NSURLConnectionDataDelegate >
{
    BOOL managedConnection;
    NSOperationQueue *notificationQueue;
    TNTNSURLConnectionProxy *urlConnectionProxy;
    
    NSURLConnection *connection;
    NSMutableData *responseDataBuffer;
    
    NSOperationQueue *callerQueue;
}
@property( nonatomic, readwrite, assign )BOOL requestAlive;

@property( nonatomic, readwrite, strong )NSURLRequest *lastRequest;
@property( nonatomic, readwrite, strong )NSHTTPURLResponse *lastResponse;

@property( nonatomic, readwrite, copy )TNTHttpConnectionDidStartBlock didStartBlock;
@property( nonatomic, readwrite, copy )TNTHttpConnectionSuccessBlock successBlock;
@property( nonatomic, readwrite, copy )TNTHttpConnectionErrorBlock errorBlock;

@end

#pragma mark - Implementation

@implementation TNTHttpConnection

#pragma mark - Ctor & Dtor

+( void )initialize
{
    if( self == [TNTHttpConnection class] )
    {
        TNTHttpConnectionDefaultTimeoutInterval = DEFAULT_CONNECTION_TIMEOUT_INTERVAL_SECS;
        TNTHttpConnectionDefaultCachePolicy = NSURLRequestUseProtocolCachePolicy;
        
        managedConnections = [NSMutableDictionary new];
        managedConnectionsLock = [NSLock new];
    }
}

-( instancetype )init
{
    self = [super init];
	if( self )
	{
        _cachePolicy = [TNTHttpConnection defaultCachePolicy];
        _timeoutInterval = [TNTHttpConnection defaultTimeoutInterval];
        
        notificationQueue = [NSOperationQueue new];
        notificationQueue.name = [NSString stringWithFormat: @"TNTHttpConnection_%p_ProcessingQueue", self];
        
        // Notifications will be delivered one by one
        notificationQueue.maxConcurrentOperationCount = 1;
	}
    return self;
}

-( void )dealloc
{
    // Canceling a connection may have side effects. Since we are deallocing the
    // object, there is no need to call the delegate or callback blocks. There is
    // also no need for KVO here, that's why we are not using setters.
	_delegate = nil;
    self.didStartBlock = nil;
    self.successBlock = nil;
    self.errorBlock = nil;
	
	[self cancelRequest];
}

#pragma mark - Public Methods

-( void )startRequestWithMethod:( TNTHttpMethod )httpMethod
                            url:( NSString * )url
                         params:( NSDictionary * )params
                        headers:( NSDictionary * )headers
                        managed:( BOOL )managed
{
    [self startRequestWithMethod: httpMethod
                             url: url
                          params: params
                         headers: headers
                         managed: managed
                      onDidStart: nil
                       onSuccess: nil
                         onError: nil];
}

-( void )startRequestWithMethod:( TNTHttpMethod )httpMethod
                            url:( NSString * )url
                         params:( NSDictionary * )params
                        headers:( NSDictionary * )headers
                        managed:( BOOL )managed
                     onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock
                      onSuccess:( TNTHttpConnectionSuccessBlock )successBlock
                        onError:( TNTHttpConnectionErrorBlock )errorBlock
{
    if( url.length == 0 )
        return;
    
    NSMutableURLRequest *request = nil;
    NSString *formattedParams = [params toQueryString];
    
    switch( httpMethod )
    {
        case TNTHttpMethodGet:
        case TNTHttpMethodHead:
        case TNTHttpMethodDelete:
            if( params.count > 0 )
                url = [url stringByAppendingFormat: @"?%@", formattedParams];
            
            
            request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: url]
                                              cachePolicy: _cachePolicy
                                          timeoutInterval: _timeoutInterval];
            
            break;
            
        case TNTHttpMethodPut:
        case TNTHttpMethodPost:
        case TNTHttpMethodPatch:
            request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: url]
                                              cachePolicy: _cachePolicy
                                          timeoutInterval: _timeoutInterval];
            
            if( params )
                [request setHTTPBody: [formattedParams dataUsingEncoding: NSUTF8StringEncoding]];
            
            break;
            
        default:
            NTR_LOGE( @"Unknown HTTP method" );
            return;
    }
    
    [request setHTTPMethod: [NSString stringFromHttpMethod: httpMethod]];
    
    for( NSString *headerField in [headers allKeys] )
        [request addValue: [headers valueForKey: headerField] forHTTPHeaderField: headerField];
    
    [self startRequest: request
               managed: managed
            onDidStart: didStartBlock
             onSuccess: successBlock
               onError: errorBlock];
}

-( void )startRequest:( NSURLRequest * )request managed:( BOOL )managed
{
    [self startRequest: request managed: managed onDidStart: nil onSuccess: nil onError: nil];
}

-( void )startRequest:( NSURLRequest * )request
              managed:( BOOL )managed
           onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock
            onSuccess:( TNTHttpConnectionSuccessBlock )successBlock
              onError:( TNTHttpConnectionErrorBlock )errorBlock
{
    if( !request )
        return;
    
    self.didStartBlock = didStartBlock;
    self.successBlock = successBlock;
    self.errorBlock = errorBlock;
    
    [self makeRequest: request managed: managed];
}

-( void )retryRequest
{
    [self makeRequest: _lastRequest  managed: managedConnection];
}

-( void )cancelRequest
{
    // NSURLConnectionDelegate callbacks are delivered on a different queue from which the user
    // starts or cancels requests. That's why we need synchronization.
    @synchronized( self )
    {
        [notificationQueue cancelAllOperations];

        [connection cancel];
        connection = nil;

        urlConnectionProxy.target = nil;
        urlConnectionProxy = nil;
        
        self.requestAlive = NO;
        
        // Caller queue is used to dispatch notifications. So we are only going to reset it
        // if the user starts another request
//        callerQueue = nil;
        
        // We do not reset lastResponse and responseDataBuffer here because the user
        // may want them after a request has been canceled
//        self.lastResponse = nil;
//        responseDataBuffer = nil;
        
        // We do not reset lastRequest because the user may want to retry
//        self.lastRequest = nil;
        
        if( managedConnection )
            [TNTHttpConnection stopManagingConnection: self];
    }
}

#pragma mark - Internals

-( void )makeRequest:( NSURLRequest * )request managed:( BOOL )managed
{
    // NSURLConnectionDelegate callbacks are delivered on a different queue from which the user
    // starts or cancels requests. That's why we need synchronization.
    @synchronized( self )
    {
        // Must cancel before changing _managed value. If we didn't, we could reach this scenario:
        // 1st request -> managed
        // 2nd request -> unmanaged
        // On the 2nd request we would not unregister from management.
        [self cancelRequest];
        
        managedConnection = managed;
        
        if( request )
        {
            self.lastRequest = request;
            self.lastResponse = nil;

            callerQueue = [NSOperationQueue currentQueue];
            if( !callerQueue )
                callerQueue = [NSOperationQueue mainQueue];
            
            // We use a proxy object since NSURLConnection keeps a strong reference to its delegate (see the docs). If we used self,
            // sometimes we would be kept from being deallocated, what would keep us from canceling the connection.
            // We also have to create the NSURLConnection delegate in the sama queue we create the NSURLConnection object
            urlConnectionProxy = [TNTNSURLConnectionProxy new];
            urlConnectionProxy.target = self;

            connection = [TNTHttpConnection createConnectionWithRequest: request delegate: urlConnectionProxy inQueue: notificationQueue];

            responseDataBuffer = [NSMutableData dataWithCapacity: K_BYTE];

            if( managedConnection )
                [TNTHttpConnection startManagingConnection: self];

            // We have to call 'start' before sending the did start notification. This way, if
            // the user does something crazy as startint another connection using this same object
            // inside the notification callback, we will not get into a unexpected internal state.
            [connection start];
            
            self.requestAlive = YES;
            [self onNotifyConnectionDidStart];
        }
    }
}

#pragma mark - NSURLConnectionDelegate

-( void )connectionDidFinishLoading:( NSURLConnection * )urlConnection
{
    // NSURLConnectionDelegate callbacks are delivered on a different queue from which the user
    // starts or cancels requests. That's why we need synchronization.
    @synchronized( self )
    {
        NSError *error = nil;
        if( ![self isSuccessfulResponse: _lastResponse data: responseDataBuffer error: &error] )
        {
            // This call will clean our internal state. So there is no problem if the user
            // starts another request using this same object
            [self connection: connection didFailWithError: error];
        }
        else
        {
            // We have to clean our state before sending the success notification because the user
            // may start another request using this same object. That's also why we create copies
            // to send together with the notifications
            NSData* responseDataCopy = [NSData dataWithData: responseDataBuffer];
            
            // Create a strong reference to the object, so we do not get side effects if the original
            // is released elsewhere before the notification block gets executed
             NSHTTPURLResponse *responseCopy = _lastResponse;
            
            // If the current request of this connection is managed, cancelRequest will possibly release
            // the last strong reference we have to self. Thus any code after cancelRequest would have undefined
            // behavior. Having a strong reference that lives only inside this scope fixes the problem.
            TNTHttpConnection *strongSelf = self;
            
            [strongSelf cancelRequest];
            
            [strongSelf onNotifyConnectionSuccessWithResponse: responseCopy data: responseDataCopy];
        }
    }
}

-( void )connection:( NSURLConnection * )urlConnection didReceiveData:( NSData * )data
{
    // NSURLConnectionDelegate callbacks are delivered on a different queue from which the user
    // starts or cancels requests. That's why we need synchronization.
    @synchronized( self )
    {
        [self onDidReceiveResponseData: data buffer: responseDataBuffer];
    }
}

-( void )connection:( NSURLConnection * )urlConnection didReceiveResponse:( NSHTTPURLResponse * )response
{
    // NSURLConnectionDelegate callbacks are delivered on a different queue from which the user
    // starts or cancels requests. That's why we need synchronization.
    @synchronized( self )
    {
        self.lastResponse = response;
    }
}

-( void )connection:( NSURLConnection * )urlConnection didFailWithError:( NSError * )error
{
    // NSURLConnectionDelegate callbacks are delivered on a different queue from which the user
    // starts or cancels requests. That's why we need synchronization.
    @synchronized( self )
    {
        // If the current request of this connection is managed, cancelRequest will possibly release
        // the last strong reference we have to self. Thus any code after cancelRequest would have undefined
        // behavior. Having a strong reference that lives only inside this scope fixes the problem.
        TNTHttpConnection *strongSelf = self;
        
        [strongSelf cancelRequest];
        [strongSelf onNotifyConnectionError: error];
    }
}

#pragma mark - Events Notifications

-( void )onNotifyConnectionDidStart
{
    [self onNotify: ^( TNTHttpConnection *httpConnection ){
        
        if( [httpConnection.delegate respondsToSelector: @selector( onTNTHttpConnectionDidStart: )] )
            [httpConnection.delegate onTNTHttpConnectionDidStart: httpConnection];
        
        if( httpConnection.didStartBlock )
            httpConnection.didStartBlock( httpConnection );
    }];
}

-( void )onNotifyConnectionSuccessWithResponse:( NSHTTPURLResponse * )response data:( NSData * )responseData
{
    [self onNotify: ^( TNTHttpConnection *httpConnection ){
        
        if( [httpConnection.delegate respondsToSelector: @selector( onTNTHttpConnection:didReceiveResponse:withData: )] )
            [httpConnection.delegate onTNTHttpConnection: httpConnection didReceiveResponse: response withData: responseData];
        
        if( httpConnection.successBlock )
            httpConnection.successBlock( httpConnection, response, responseData );
    }];
}

-( void )onNotifyConnectionError:( NSError* )error
{
    [self onNotify: ^( TNTHttpConnection *httpConnection ){

        if( [httpConnection.delegate respondsToSelector: @selector( onTNTHttpConnection:didFailWithError: )] )
            [httpConnection.delegate onTNTHttpConnection: httpConnection didFailWithError: error];
        
        if( httpConnection.errorBlock )
            httpConnection.errorBlock( httpConnection, error );
    }];
}

-( void )onNotify:( TNTHttpConnectionNotificationBlock )notificationBlock
{
    NSBlockOperation *notificationOperation = [NSBlockOperation new];
    
    __weak TNTHttpConnection *weakSelf = self;
    __weak NSOperationQueue *weakCallerQueue = callerQueue;
    __weak NSBlockOperation *weakNotificationOperation = notificationOperation;

    [notificationOperation addExecutionBlock: ^{

        if( !weakNotificationOperation || weakNotificationOperation.isCancelled || !weakSelf )
            return;
        
        NSBlockOperation *processNotificationOperation = [NSBlockOperation blockOperationWithBlock: ^{

            if( !weakNotificationOperation || weakNotificationOperation.isCancelled || !weakSelf )
                return;

            // NSURLConnectionDelegate callbacks are delivered on a different queue from which the user
            // starts or cancels requests. That's why we need synchronization.
            @synchronized( weakSelf )
            {
                notificationBlock( weakSelf );
            }
        }];
        
        // waitUntilFinished MUST BE YES: this way we guarantee only one notification of this object
        // is being processed by callerQueue at any specific time
        [weakCallerQueue addOperations: @[ processNotificationOperation ] waitUntilFinished: YES];
    }];

    // notificationQueue is guaranteed to process only one operation per time, but callerQueue is not.
    // That is why we have notificationQueue in the first place: to be able to control how notifications
    // are delivered. Besides that, it is possible for we to have many notifications queued on notificationQueue
    // that have not been processed yet, and we need a way to cancel all of them at the same time.
    [notificationQueue addOperation: notificationOperation];
}

#pragma mark - Virtual

-( void )onDidReceiveResponseData:( NSData * )data buffer:( NSMutableData * )dataBuffer
{
	[dataBuffer appendData: data];
}

-( BOOL )isSuccessfulResponse:( NSHTTPURLResponse * )response data:( NSData * )responseData error:( out NSError ** )error
{
    if( !IS_HTTP_STATUS_SUCCESS( response.statusCode ) )
	{
		NSString *errorMsg = [NSString stringWithFormat: @"TNTHttpConnection %p failed with http status code %d", self, ( int )response.statusCode];
        
		NTR_LOGE( @"%@", errorMsg );
		
		*error = [[NSError alloc] initWithDomain: TNTHttpConnectionErrorDomain
                                            code: TNTHttpConnectionErrorCodeHttpError
                                        userInfo: @{ NSLocalizedDescriptionKey: errorMsg,
                                                     TNTHttpConnectionErrorUserInfoResponseKey: response,
                                                     TNTHttpConnectionErrorUserInfoDataKey: responseData }];
		return NO;
	}
    
	return YES;
}

#pragma mark - Helpers

+( NSURLConnection * )createConnectionWithRequest:( NSURLRequest * )request delegate:( NSObject< NSURLConnectionDelegate > * )connectionDelegate inQueue:( NSOperationQueue * )queue;
{
	NSURLConnection *temp = [[NSURLConnection alloc] initWithRequest: request delegate: connectionDelegate startImmediately: NO];
    [temp setDelegateQueue: queue];
    return temp;
}

#pragma mark - Class Methods

+( void )startManagingConnection:( TNTHttpConnection * )connection
{
    if( !connection )
        return;
    
    [managedConnectionsLock lock];

    int address = ( int )connection;
    managedConnections[@( address )] = connection;
    
    [managedConnectionsLock unlock];
}

+( void )stopManagingConnection:( TNTHttpConnection * )connection
{
    if( !connection )
        return;
    
    [managedConnectionsLock lock];

    int address = ( int )connection;
    [managedConnections removeObjectForKey: @( address )];

    [managedConnectionsLock unlock];
}

+( void )setDefaultCachePolicy:( NSURLRequestCachePolicy )_cachePolicy
{
    TNTHttpConnectionDefaultCachePolicy = _cachePolicy;
}

+( NSURLRequestCachePolicy )defaultCachePolicy
{
    return TNTHttpConnectionDefaultCachePolicy;
}

+( void )setDefaultTimeoutInterval:( NSTimeInterval )timeoutInterval
{
    TNTHttpConnectionDefaultTimeoutInterval = timeoutInterval;
}

+( NSTimeInterval )defaultTimeoutInterval
{
    return TNTHttpConnectionDefaultTimeoutInterval;
}

@end















































