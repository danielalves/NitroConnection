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

NSString * const TNTHttpConnectionErrorUserInfoResponseKey = @"TNTHttpConnectionErrorUserInfoResponseKey";
NSString * const TNTHttpConnectionErrorUserInfoDataKey = @"TNTHttpConnectionErrorUserInfoDataKey";

const NSInteger TNTHttpConnectionErrorCodeHttpError = 1;

#pragma mark - Statics

static NSTimeInterval TNTHttpConnectionDefaultTimeoutInterval = DEFAULT_CONNECTION_TIMEOUT_INTERVAL_SECS;
static NSURLRequestCachePolicy TNTHttpConnectionDefaultCachePolicy = NSURLRequestUseProtocolCachePolicy;

#pragma mark - Class Extension

@interface TNTHttpConnection()< NSURLConnectionDelegate >
{
    NSMutableData *responseDataBuffer;
    
    NSOperationQueue *callerQueue;
    NSOperationQueue *notificationQueue;
}
@property( nonatomic, readwrite, assign )BOOL requestAlive;
@property( nonatomic, readwrite, strong )NSURLConnection *connection;

@property( nonatomic, readwrite, strong )NSURLRequest *lastRequest;
@property( nonatomic, readwrite, strong )NSHTTPURLResponse *lastResponse;

@property( nonatomic, readwrite, copy )TNTHttpConnectionDidStartBlock didStartBlock;
@property( nonatomic, readwrite, copy )TNTHttpConnectionSuccessBlock successBlock;
@property( nonatomic, readwrite, copy )TNTHttpConnectionErrorBlock errorBlock;

@end

#pragma mark - Implementation

@implementation TNTHttpConnection

#pragma mark - Ctor & Dtor

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
    // also no need for KVO here, that's why we are not using setters here.
	_delegate = nil;
    self.didStartBlock = nil;
    self.successBlock = nil;
    self.errorBlock = nil;
	
	[self cancel];
}

#pragma mark - Public Methods

-( void )startRequest:( NSURLRequest * )request
{
    [self startRequest: request onDidStart: nil onSuccess: nil onError: nil];
}

-( void )startRequest:( NSURLRequest * )request
           onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock
            onSuccess:( TNTHttpConnectionSuccessBlock )successBlock
              onError:( TNTHttpConnectionErrorBlock )errorBlock
{
    self.didStartBlock = didStartBlock;
    self.successBlock = successBlock;
    self.errorBlock = errorBlock;
    
    [self makeRequest: request];
}

-( void )startRequestWithMethod:( TNTHttpMethod )httpMethod
                            url:( NSString * )url
                         params:( NSDictionary * )params
                        headers:( NSDictionary * )headers
{
    [self startRequestWithMethod: httpMethod
                             url: url
                          params: params
                         headers: headers
                      onDidStart: nil
                       onSuccess: nil
                         onError: nil];
}

-( void )startRequestWithMethod:( TNTHttpMethod )httpMethod
                            url:( NSString * )url
                         params:( NSDictionary * )params
                        headers:( NSDictionary * )headers
                     onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock
                      onSuccess:( TNTHttpConnectionSuccessBlock )successBlock
                        onError:( TNTHttpConnectionErrorBlock )errorBlock
{
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
            onDidStart: didStartBlock
             onSuccess: successBlock
               onError: errorBlock];
}

-( void )retry
{
    [self makeRequest: _lastRequest];
}

-( void )cancel
{
    // NSURLConnectionDelegate callbacks are delivered on a different queue from which the user
    // starts or cancels requests. That's why we need synchronization
    @synchronized( self )
    {
        [notificationQueue cancelAllOperations];
        
        [_connection cancel];
        _connection = nil;
        
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
    }
}

#pragma mark - Internals

-( void )makeRequest:( NSURLRequest * )request
{
    // NSURLConnectionDelegate callbacks are delivered on a different queue from which the user
    // starts or cancels requests. That's why we need synchronization
    @synchronized( self )
    {
        [self cancel];
        
        if( request )
        {
            self.lastRequest = request;
            self.lastResponse = nil;

            _connection = [TNTHttpConnection createConnectionWithRequest: request delegate: self inQueue: notificationQueue];
            responseDataBuffer = [NSMutableData dataWithCapacity: K_BYTE];
            
            callerQueue = [NSOperationQueue currentQueue];
            if( !callerQueue )
                callerQueue = [NSOperationQueue mainQueue];

            // We have to call 'start' before sending the did start notification. This way, if
            // the user does something crazy as startint another connection using this same object
            // inside the notification callback, we will not get into a unexpected internal state.
            [_connection start];
            
            self.requestAlive = YES;
            [self onNotifyConnectionDidStart];
        }
    }
}

#pragma mark - NSURLConnectionDelegate

-( void )connectionDidFinishLoading:( NSURLConnection * )urlConnection
{
    // NSURLConnectionDelegate callbacks are delivered on a different queue from which the user
    // starts or cancels requests. That's why we need synchronization
    @synchronized( self )
    {
        NSError *error = nil;
        if( ![self isSuccessfulResponse: _lastResponse data: responseDataBuffer error: &error] )
        {
            // This call will clean our internal state. So there is no problem if the user
            // starts another request using this same object
            [self connection: _connection didFailWithError: error];
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
            
            [self cancel];
            
            [self onNotifyConnectionSuccessWithResponse: responseCopy data: responseDataCopy];
        }
    }
}

-( void )connection:( NSURLConnection * )connection didReceiveData:( NSData * )data
{
    // NSURLConnectionDelegate callbacks are delivered on a different queue from which the user
    // starts or cancels requests. That's why we need synchronization
    @synchronized( self )
    {
        [self onDidReceiveResponseData: data buffer: responseDataBuffer];
        
        NSString * temp = [[NSString alloc] initWithData: responseDataBuffer encoding: NSUTF8StringEncoding];
        NTR_LOGI( @"%@", temp );
    }
}

-( void )connection:( NSURLConnection * )connection didReceiveResponse:( NSHTTPURLResponse * )response
{
    // NSURLConnectionDelegate callbacks are delivered on a different queue from which the user
    // starts or cancels requests. That's why we need synchronization
    @synchronized( self )
    {
        self.lastResponse = response;
    }
}

-( void )connection:( NSURLConnection * )connection didFailWithError:( NSError * )error
{
    // NSURLConnectionDelegate callbacks are delivered on a different queue from which the user
    // starts or cancels requests. That's why we need synchronization
    @synchronized( self )
    {
        [self cancel];
        [self onNotifyConnectionError: error];
    }
}

#pragma mark - Events Notifications

-( void )onNotifyConnectionDidStart
{
    [self onNotify: ^( __weak TNTHttpConnection *weakSelf ){
        if( [weakSelf.delegate respondsToSelector: @selector( onTNTHttpConnectionDidStart: )] )
            [weakSelf.delegate onTNTHttpConnectionDidStart: weakSelf];
        
        if( weakSelf.didStartBlock )
            weakSelf.didStartBlock();
    }];
}

-( void )onNotifyConnectionSuccessWithResponse:( NSHTTPURLResponse * )response data:( NSData * )responseData
{
    [self onNotify: ^( __weak TNTHttpConnection *weakSelf ){
        if( [weakSelf.delegate respondsToSelector: @selector( onTNTHttpConnection:didReceiveResponse:withData: )] )
            [weakSelf.delegate onTNTHttpConnection: weakSelf didReceiveResponse: response withData: responseData];
        
        if( weakSelf.successBlock )
            weakSelf.successBlock( response, responseData );
    }];
}

-( void )onNotifyConnectionError:( NSError* )error
{
    [self onNotify: ^( __weak TNTHttpConnection *weakSelf ){
        if( [weakSelf.delegate respondsToSelector: @selector( onTNTHttpConnection:didFailWithError: )] )
            [weakSelf.delegate onTNTHttpConnection: weakSelf didFailWithError: error];
        
        if( weakSelf.errorBlock )
            weakSelf.errorBlock( error );
    }];
}

-( void )onNotify:( void (^)( __weak TNTHttpConnection *weakSelf ))notificationBlock
{
    NSBlockOperation *notificationOperation = [NSBlockOperation new];
    
    __weak TNTHttpConnection *weakSelf = self;
    __weak NSBlockOperation *weakNotificationOperation = notificationOperation;
    
    [notificationOperation addExecutionBlock: ^{

        NSBlockOperation *processNotificationOperation = [NSBlockOperation blockOperationWithBlock: ^{
            
            if( !weakNotificationOperation || weakNotificationOperation.isCancelled )
                return;
            
            // NSURLConnectionDelegate callbacks are delivered on a different queue from which the user
            // starts or cancels requests. That's why we need synchronization
            @synchronized( weakSelf )
            {
                if( !weakSelf )
                    return;

                notificationBlock( weakSelf );
            }
        }];
        
        // waitUntilFinished MUST BE YES: this way we guarantee only one notification of this object
        // is being processed by callerQueue at any specific time
        [callerQueue addOperations: @[ processNotificationOperation ] waitUntilFinished: YES];
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

+( NSURLConnection * )createConnectionWithRequest:( NSURLRequest * )request delegate:( id )connectionDelegate inQueue:( NSOperationQueue * )queue;
{
	NSURLConnection *temp = [[NSURLConnection alloc] initWithRequest: request delegate: connectionDelegate startImmediately: NO];
    [temp setDelegateQueue: queue];
    return temp;
}

#pragma mark - Class Methods

+( void )setDefaultCachePolicy:( NSURLRequestCachePolicy )_cachePolicy
{
    // This synchronization makes TNTHttpConnectionDefaultCachePolicy attribution thread safe
    @synchronized( self )
    {
        TNTHttpConnectionDefaultCachePolicy = _cachePolicy;
    }
}

+( NSURLRequestCachePolicy )defaultCachePolicy
{
    // Reads do not need to be synchronized: we will allow dirty reads. Afterall,
    // the user shouldn't change de default cache policy from different threads - this
    // operation is usually done in the application begginning.
//    @synchronized( self )
//    {
        return TNTHttpConnectionDefaultCachePolicy;
//    }
}

+( void )setDefaultTimeoutInterval:( NSTimeInterval )timeoutInterval
{
    // This synchronization makes TNTHttpConnectionDefaultTimeoutInterval attribution thread safe
    @synchronized( self )
    {
        TNTHttpConnectionDefaultTimeoutInterval = timeoutInterval;
    }
}

+( NSTimeInterval )defaultTimeoutInterval
{
    // Reads do not need to be synchronized: we will allow dirty reads. Afterall,
    // the user shouldn't change de default timeout from different threads - this
    // operation is usually done in the application begginning.
//    @synchronized( self )
//    {
        return TNTHttpConnectionDefaultTimeoutInterval;
//    }
}

@end















































