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
#import "NSMutableURLRequest+Utils.h"
#import "NSOperationQueue+Utils.h"
#import "TNTHttpStatusCodes.h"

// Pods
#import <NitroKeychain/TNTKeychain.h>
#import <NitroMisc/NTRLogging.h>

#pragma mark - Defines

#if DEBUG
	#define DEFAULT_CONNECTION_TIMEOUT_INTERVAL_SECS 30
#else
	#define DEFAULT_CONNECTION_TIMEOUT_INTERVAL_SECS 3
#endif

// Just to get compilation errors and to be refactoring compliant. But this way we can't concat strings at compilation time =/
#define EVAL_AND_STRINGIFY(x) (x ? __STRING(x) : __STRING(x))

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
static NSOperationQueue *managedConnectionsSerializerQueue;

static NSMutableArray *authenticationItems;
static NSOperationQueue *authenticationItemsSerializerQueue;
static NSMutableDictionary *authenticationItemSerializerQueuesDict;

#pragma mark - Helper Types

#pragma mark - TNTConnectionAndError Interface

@interface TNTConnectionAndError : NSObject

@property( nonatomic, readwrite, weak )TNTHttpConnection* connection;
@property( nonatomic, readwrite, strong )NSError* error;

+( instancetype )connection:( TNTHttpConnection * )connection error:( NSError * )error;

@end

#pragma mark - TNTConnectionAndError Error

@implementation TNTConnectionAndError

+( instancetype )connection:( TNTHttpConnection * )connection error:( NSError * )error
{
    TNTConnectionAndError *temp = [self new];
    temp.connection = connection;
    temp.error = error;
    return temp;
}

@end

#pragma mark - TNTAuthenticationItem Interface

@interface TNTAuthenticationItem : NSObject

@property( nonatomic, readwrite, assign )BOOL authenticating;

@property( nonatomic, readwrite, strong )NSRegularExpression *servicesRegex;

@property( nonatomic, readwrite, strong )NSString *tokenUrl;
@property( nonatomic, readwrite, assign )TNTHttpMethod httpMethod;
@property( nonatomic, readwrite, strong )NSDictionary *queryString;
@property( nonatomic, readwrite, strong )NSData *body;
@property( nonatomic, readwrite, strong )NSDictionary *headers;
@property( nonatomic, readwrite, strong )NSString *keychainItemId;
@property( nonatomic, readwrite, strong )NSString *keychainItemAccessGroup;

@property( nonatomic, readwrite, copy )TNTHttpConnectionOAuthInformCredentialsBlock onInformCredentialsBlock;
@property( nonatomic, readwrite, copy )TNTHttpConnectionOAuthParseTokenFromResponseBlock onParseTokenFromResponseBlock;
@property( nonatomic, readwrite, copy )TNTHttpConnectionOAuthAuthenticationErrorBlock onAuthenticationErrorBlock;

@property( nonatomic, readwrite, strong )NSMutableArray *connectionsToRetry;

-( NSString * )loadToken;
-( void )saveToken:( NSString * )token;

@end

#pragma mark - TNTAuthenticationItem Implementation

@implementation TNTAuthenticationItem

-( instancetype )init
{
    self = [super init];
    if( self )
        _connectionsToRetry = [NSMutableArray new];
    
    return self;
}

-( NSString * )loadToken
{
    if( [TNTAuthenticationItem validKeychainString: _keychainItemId] )
        return [TNTKeychain load: _keychainItemId];
    
    return [TNTKeychain load: _tokenUrl];
}

-( void )saveToken:( NSString * )token
{
    NSString *finalAccessGroup = [TNTAuthenticationItem validKeychainString: _keychainItemAccessGroup] ? _keychainItemAccessGroup : nil;
    
    if( [TNTAuthenticationItem validKeychainString: _keychainItemId] )
        [TNTKeychain save: _keychainItemId data: token accessGroup: finalAccessGroup];
    else
        [TNTKeychain save: _tokenUrl data: token accessGroup: finalAccessGroup];
}

+( BOOL )validKeychainString:( NSString * )str
{
    NSString *formattedKeychainStr = [str stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return formattedKeychainStr.length > 0;
}

@end

#pragma mark - TNTNSURLConnectionProxy Interface

typedef void( ^TNTHttpConnectionNotificationBlock )( TNTHttpConnection *httpConnection );

@class TNTHttpConnection;

@interface TNTNSURLConnectionProxy : NSObject< NSURLConnectionDataDelegate >

@property( nonatomic, readwrite, weak )id< NSURLConnectionDataDelegate > target;

@end

#pragma mark - TNTNSURLConnectionProxy Implementation

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


-( BOOL )connection:( NSURLConnection * )connection canAuthenticateAgainstProtectionSpace:( NSURLProtectionSpace * )protectionSpace
{
    if( !_target )
        return NO;
    
    @synchronized( _target )
    {
        // We do not use respondsToSelector: since we know TNTHttpConnection does repond
        return [_target connection: connection canAuthenticateAgainstProtectionSpace: protectionSpace];
    }
}

-( void )connection:( NSURLConnection * )connection didReceiveAuthenticationChallenge:( NSURLAuthenticationChallenge * )challenge
{
    if( !_target )
        return;
    
    @synchronized( _target )
    {
        // We do not use respondsToSelector: since we know TNTHttpConnection does repond
        [_target connection: connection didReceiveAuthenticationChallenge: challenge];
    }
}

@end

#pragma mark - TNTHttpConnection Class Extension

@interface TNTHttpConnection()< NSURLConnectionDataDelegate >
{
    NSOperationQueue *notificationQueue;
    TNTNSURLConnectionProxy *urlConnectionProxy;
    
    NSURLConnection *connection;
    NSMutableData *responseDataBuffer;
}
@property( nonatomic, readonly, assign )BOOL managedConnection;
@property( nonatomic, readwrite, assign )BOOL requestAlive;

@property( nonatomic, readwrite, strong )NSURLRequest *lastRequest;
@property( nonatomic, readwrite, strong )NSHTTPURLResponse *lastResponse;

@property( nonatomic, readonly )NSOperationQueue *callerQueue;

@property( nonatomic, readwrite, copy )TNTHttpConnectionDidStartBlock didStartBlock;
@property( nonatomic, readwrite, copy )TNTHttpConnectionSuccessBlock successBlock;
@property( nonatomic, readwrite, copy )TNTHttpConnectionErrorBlock errorBlock;

-( void )failWithError:( NSError * )error;

@end

#pragma mark - TNTHttpConnection Implementation

@implementation TNTHttpConnection

#pragma mark - Ctor & Dtor

+( void )initialize
{
    if( self == [TNTHttpConnection class] )
    {
        TNTHttpConnectionDefaultTimeoutInterval = DEFAULT_CONNECTION_TIMEOUT_INTERVAL_SECS;
        TNTHttpConnectionDefaultCachePolicy = NSURLRequestUseProtocolCachePolicy;
        
        managedConnections = [NSMutableDictionary new];
        
        managedConnectionsSerializerQueue = [NSOperationQueue new];
        managedConnectionsSerializerQueue.maxConcurrentOperationCount = 1;
        managedConnectionsSerializerQueue.name = [NSString stringWithFormat: @"%@ManagedConnectionsSerializerQueue", NSStringFromClass( [self class] )];
        
        authenticationItems = [NSMutableArray new];
        
        authenticationItemsSerializerQueue = [NSOperationQueue new];
        authenticationItemsSerializerQueue.maxConcurrentOperationCount = 1;
        authenticationItemsSerializerQueue.name = [NSString stringWithFormat: @"%@ReauthSerializerQueue", NSStringFromClass( [self class] )];
        
        authenticationItemSerializerQueuesDict = [NSMutableDictionary new];
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
                    queryString:( NSDictionary * )queryString
                           body:( NSData * )body
                        headers:( NSDictionary * )headers
                        managed:( BOOL )managed
{
    [self startRequestWithMethod: httpMethod
                             url: url
                     queryString: queryString
                            body: body
                         headers: headers
                         managed: managed
                      onDidStart: nil
                       onSuccess: nil
                         onError: nil];
}

-( void )startRequestWithMethod:( TNTHttpMethod )httpMethod
                            url:( NSString * )url
                    queryString:( NSDictionary * )queryString
                           body:( NSData * )body
                        headers:( NSDictionary * )headers
                        managed:( BOOL )managed
                     onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock
                      onSuccess:( TNTHttpConnectionSuccessBlock )successBlock
                        onError:( TNTHttpConnectionErrorBlock )errorBlock
{
    if( url.length == 0 )
        return;
    
    if( queryString.count > 0 )
    {
        NSString *formattedQueryString = [queryString toQueryString];
        url = [url stringByAppendingFormat: @"?%@", formattedQueryString];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: url]];
    
    if( body.length > 0 )
        [request setHTTPBody: body];
    
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
    [self makeRequest: _lastRequest  managed: _managedConnection];
}

-( void )cancelRequest
{
    // NSURLConnectionDelegate callbacks are delivered on a different queue from which the user
    // starts or cancels requests. That's why we need synchronization.
    @synchronized( self )
    {
        [self reset];
        
        if( _managedConnection )
            [TNTHttpConnection stopManagingConnection: self];
    }
}

-( void )reset
{
    // Does not need to be synchronized since it is only called inside already
    // synchronized blocks
//    @synchronized( self )
//    {
        [notificationQueue cancelAllOperations];
        
        [connection cancel];
        connection = nil;
        
        urlConnectionProxy.target = nil;
        urlConnectionProxy = nil;
        
        self.requestAlive = NO;
        
        // Caller queue is used to dispatch notifications. So we are only going to reset it
        // if the user starts another request
//        _callerQueue = nil;
    
        // We do not reset lastResponse and responseDataBuffer here because the user
        // may want them after a request has been canceled
//        self.lastResponse = nil;
//        responseDataBuffer = nil;
    
        // We do not reset lastRequest because the user may want to retry
//        self.lastRequest = nil;
//    }
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
        
        _managedConnection = managed;
        
        if( request )
        {
            NSDictionary *authHeaders = [TNTHttpConnection authenticationHeadersForUrl: request.URL];
            if( authHeaders.count > 0 )
            {
                NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithRequest: request];
                
                // We must set, and not add, auth headers because -retry also calls this method.
                // If we added auth headers, we would be incrementally updating them on every retry
                for( NSString *authHeaderKey in [authHeaders allKeys] )
                    [mutableRequest setValue: [authHeaders valueForKey: authHeaderKey] forHTTPHeaderField: authHeaderKey];
                
                request = mutableRequest;
            }
            
            self.lastRequest = request;
            self.lastResponse = nil;

            _callerQueue = [NSOperationQueue currentQueue];
            if( !_callerQueue )
                _callerQueue = [NSOperationQueue mainQueue];
            
            // We use a proxy object since NSURLConnection keeps a strong reference to its delegate (see the docs). If we used self,
            // sometimes we would be kept from being deallocated, what would keep us from canceling the connection.
            // We also have to create the NSURLConnection delegate in the sama queue we create the NSURLConnection object
            urlConnectionProxy = [TNTNSURLConnectionProxy new];
            urlConnectionProxy.target = self;

            connection = [TNTHttpConnection createConnectionWithRequest: request delegate: urlConnectionProxy inQueue: notificationQueue];

            responseDataBuffer = [NSMutableData dataWithCapacity: K_BYTE];

            if( _managedConnection )
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
            if( [TNTHttpConnection tryAuthentication: self originalError: error] )
                return;
            
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
            
            [self reset];
            [self onNotifyConnectionSuccessWithResponse: responseCopy data: responseDataCopy];
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
        [self reset];
        [self onNotifyConnectionError: error];
    }
}

-( BOOL )connection:( NSURLConnection * )urlConnection canAuthenticateAgainstProtectionSpace:( NSURLProtectionSpace * )protectionSpace
{
    // Does not need to be synchronized since we do not change internal state or call the delegate / callbaks
    return [urlConnection.currentRequest.URL.scheme.lowercaseString isEqualToString: @"https"];
}

-( void )connection:( NSURLConnection * )urlConnection didReceiveAuthenticationChallenge:( NSURLAuthenticationChallenge * )challenge
{
    // Does not need to be synchronized since we do not change internal state or call the delegate / callbaks
    
    const NSRange notFoundRange = NSMakeRange( NSNotFound, 0 );
    NSString *urlString = urlConnection.currentRequest.URL.absoluteString;
    
    __block BOOL trusted = NO;
    [authenticationItemsSerializerQueue waitUntilBlockFinished: ^{
        
        for( TNTAuthenticationItem *authItem in authenticationItems )
        {
            NSURL *tokenUrl = [NSURL URLWithString: authItem.tokenUrl];
            if( [tokenUrl.host isEqualToString: challenge.protectionSpace.host] )
            {
                trusted = YES;
                break;
            }
            
            NSRange rangeOfFirstMatch = [authItem.servicesRegex rangeOfFirstMatchInString: urlString
                                                                                  options: 0
                                                                                    range: NSMakeRange( 0, [urlString length] )];
            if( !NSEqualRanges( rangeOfFirstMatch, notFoundRange ))
            {
                trusted = YES;
                break;
            }
        }
    }];
    
    
    if( trusted )
    {
        [challenge.sender useCredential: [NSURLCredential credentialForTrust: challenge.protectionSpace.serverTrust]
             forAuthenticationChallenge: challenge];
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
        
        if( httpConnection.managedConnection )
            [TNTHttpConnection stopManagingConnection: self];
        
        if( [httpConnection.delegate respondsToSelector: @selector( onTNTHttpConnection:didReceiveResponse:withData: )] )
            [httpConnection.delegate onTNTHttpConnection: httpConnection didReceiveResponse: response withData: responseData];
        
        if( httpConnection.successBlock )
            httpConnection.successBlock( httpConnection, response, responseData );
    }];
}

-( void )onNotifyConnectionError:( NSError* )error
{
    [self onNotify: ^( TNTHttpConnection *httpConnection ){
        
        if( httpConnection.managedConnection )
            [TNTHttpConnection stopManagingConnection: self];

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
    __weak NSOperationQueue *weakCallerQueue = _callerQueue;
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
        [weakCallerQueue waitUntilOperationFinished: processNotificationOperation];
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

-( void )failWithError:( NSError * )error
{
    [self connection: connection didFailWithError: error];
}

#pragma mark - Class Methods

+( void )startManagingConnection:( TNTHttpConnection * )connection
{
    if( !connection )
        return;
    
    int address = ( int )connection;
    
    [managedConnectionsSerializerQueue waitUntilBlockFinished: ^{
        managedConnections[@( address )] = connection;
    }];
}

+( void )stopManagingConnection:( TNTHttpConnection * )connection
{
    if( !connection )
        return;
    
    int address = ( int )connection;

    [managedConnectionsSerializerQueue waitUntilBlockFinished: ^{
        [managedConnections removeObjectForKey: @( address )];
    }];
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

#pragma mark - OAuth 2

+( void )authenticateServicesMatchingRegexString:( NSString * )regexString
                            usingTokenRequestUrl:( NSString * )tokenUrl
                                      httpMethod:( TNTHttpMethod )httpMethod
                                     queryString:( NSDictionary * )queryString
                                            body:( NSData * )body
                                         headers:( NSDictionary * )headers
                                  keychainItemId:( NSString * )keychainItemId
                         keychainItemAccessGroup:( NSString * )keychainItemAccessGroup
                             onInformCredentials:( TNTHttpConnectionOAuthInformCredentialsBlock )onInformCredentialsBlock
                        onParseTokenFromResponse:( TNTHttpConnectionOAuthParseTokenFromResponseBlock )onParseTokenFromResponseBlock
                           onAuthenticationError:( TNTHttpConnectionOAuthAuthenticationErrorBlock )onAuthenticationErrorBlock;
{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: regexString
                                                                           options: NSRegularExpressionCaseInsensitive
                                                                             error: &error];
    if( error )
        [NSException raise: NSInvalidArgumentException format: @"Invalid %s %@: %@", EVAL_AND_STRINGIFY( regexString ), regexString, error];
    
    return [self authenticateServicesMatching: regex
                         usingTokenRequestUrl: tokenUrl
                                   httpMethod: httpMethod
                                  queryString: queryString
                                         body: body
                                      headers: headers
                               keychainItemId: keychainItemId
                      keychainItemAccessGroup: keychainItemAccessGroup
                          onInformCredentials: onInformCredentialsBlock
                     onParseTokenFromResponse: onParseTokenFromResponseBlock
                        onAuthenticationError: onAuthenticationErrorBlock];
}

+( void )authenticateServicesMatching:( NSRegularExpression * )regex
                 usingTokenRequestUrl:( NSString * )tokenUrl
                           httpMethod:( TNTHttpMethod )httpMethod
                          queryString:( NSDictionary * )queryString
                                 body:( NSData * )body
                              headers:( NSDictionary * )headers
                       keychainItemId:( NSString * )keychainItemId
              keychainItemAccessGroup:( NSString * )keychainItemAccessGroup
                  onInformCredentials:( TNTHttpConnectionOAuthInformCredentialsBlock )onInformCredentialsBlock
             onParseTokenFromResponse:( TNTHttpConnectionOAuthParseTokenFromResponseBlock )onParseTokenFromResponseBlock
                onAuthenticationError:( TNTHttpConnectionOAuthAuthenticationErrorBlock )onAuthenticationErrorBlock;
{
    if( !regex )
        [NSException raise: NSInvalidArgumentException format: @"%s must not be nil", EVAL_AND_STRINGIFY( regex )];
    
    NSString *trimmedKeychainItemId = [keychainItemId stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if( trimmedKeychainItemId.length == 0 )
        [NSException raise: NSInvalidArgumentException format: @"Invalid %s %@", EVAL_AND_STRINGIFY( keychainItemId ), keychainItemId];
    
    NSURL *url = [NSURL URLWithString: tokenUrl];
    if( !url )
        [NSException raise: NSInvalidArgumentException format: @"Invalid %s %@", EVAL_AND_STRINGIFY( tokenUrl ), tokenUrl];
    
    if( !onInformCredentialsBlock )
        [NSException raise: NSInvalidArgumentException format: @"%s must not be nil", EVAL_AND_STRINGIFY( onInformCredentialsBlock )];
    
    if( !onParseTokenFromResponseBlock )
        [NSException raise: NSInvalidArgumentException format: @"%s must not be nil", EVAL_AND_STRINGIFY( onParseTokenFromResponseBlock )];
        
    TNTAuthenticationItem *authItem = [TNTAuthenticationItem new];
    authItem.servicesRegex = regex;
    authItem.tokenUrl = tokenUrl;
    authItem.httpMethod = httpMethod;
    authItem.queryString = queryString;
    authItem.body = body;
    authItem.headers = headers;
    authItem.keychainItemId = keychainItemId;
    authItem.keychainItemAccessGroup = keychainItemAccessGroup;
    authItem.onInformCredentialsBlock = onInformCredentialsBlock;
    authItem.onParseTokenFromResponseBlock = onParseTokenFromResponseBlock;
    authItem.onAuthenticationErrorBlock = onAuthenticationErrorBlock;
    
    int authItemAddress = ( int )authItem;
    
    [authenticationItemsSerializerQueue waitUntilBlockFinished: ^{
        
        [authenticationItems addObject: authItem];
        
        NSOperationQueue *authenticationItemQueue = [NSOperationQueue new];
        authenticationItemQueue.maxConcurrentOperationCount = 1;
        
        authenticationItemQueue.name = [NSString stringWithFormat: @"AuthenticationItemQueue_%d", authItemAddress];
        authenticationItemSerializerQueuesDict[ @( authItemAddress ) ] = authenticationItemQueue;
    }];
}

+( void )removeAllAuthenticationItems
{
    [authenticationItemsSerializerQueue waitUntilBlockFinished: ^{
        authenticationItems = [NSMutableArray new];
    }];
}

+( TNTAuthenticationItem * )authenticationItemForUrl:( NSURL * )url
{
    NSString *urlString = url.absoluteString;
    
    __block TNTAuthenticationItem *found = nil;
    [authenticationItemsSerializerQueue waitUntilBlockFinished: ^{
        
        const NSRange notFoundRange = NSMakeRange( NSNotFound, 0 );
        for( TNTAuthenticationItem *authItem in authenticationItems )
        {
            NSRange rangeOfFirstMatch = [authItem.servicesRegex rangeOfFirstMatchInString: urlString
                                                                                  options: 0
                                                                                    range: NSMakeRange( 0, [urlString length] )];
            if( !NSEqualRanges( rangeOfFirstMatch, notFoundRange ))
            {
                found = authItem;
                break;
            }
        }
    }];
    
    return found;
}

+( NSDictionary * )authenticationHeadersForUrl:( NSURL * )url
{
    TNTAuthenticationItem *authItem = [self authenticationItemForUrl: url];
    if( !authItem )
        return nil;
    
    NSString *token = [authItem loadToken];
    if( !token )
        return nil;

    return @{ @"Authorization": [NSString stringWithFormat: @"Bearer %@", token] };
}

+( BOOL )tryAuthentication:( TNTHttpConnection * )connectionToAuthenticate originalError:( NSError * )originalError
{
    if( connectionToAuthenticate.lastResponse.statusCode != TNTHttpStatusCodeUnauthorized )
        return NO;
    
    TNTAuthenticationItem *authItem = [self authenticationItemForUrl: connectionToAuthenticate.lastRequest.URL];
    if( !authItem )
        return NO;
    
    NSString *credentials = authItem.onInformCredentialsBlock( connectionToAuthenticate.lastRequest );
    if( !credentials )
        return NO;
    
    int authItemAddress = ( int )authItem;
    NSOperationQueue *serializerQueue = authenticationItemSerializerQueuesDict[@( authItemAddress )];
    
    // Keeps a strong reference for the original request
    NSURLRequest *originalRequest = connectionToAuthenticate.lastRequest;
    
    __weak TNTHttpConnection *weakConnectionToAuthenticate = connectionToAuthenticate;
    
    [serializerQueue addOperationWithBlock: ^{
        
        if( !weakConnectionToAuthenticate )
            return;
        
        [authItem.connectionsToRetry addObject: [TNTConnectionAndError connection: weakConnectionToAuthenticate
                                                                            error: originalError]];
        
        if( authItem.authenticating )
            return;
        
        TNTHttpConnection *authConnection = [TNTHttpConnection new];
        
        //
        // See:
        // http://en.wikipedia.org/wiki/Basic_access_authentication#Client_side
        //
        NSMutableDictionary *customHeadersPlusAuth = [NSMutableDictionary dictionaryWithDictionary: @{ @"Authorization": [NSString stringWithFormat: @"Basic %@", credentials] }];
        if( authItem.headers )
            [customHeadersPlusAuth addEntriesFromDictionary: authItem.headers];
        
        NSBlockOperation *notifyErrorOperation = [NSBlockOperation blockOperationWithBlock: ^{
            
            authItem.authenticating = NO;
            
            for( TNTConnectionAndError *connToRetry in authItem.connectionsToRetry )
            {
                @synchronized( connToRetry.connection )
                {
                    [connToRetry.connection.callerQueue waitUntilBlockFinished: ^{
                        [connToRetry.connection failWithError: connToRetry.error];
                    }];
                }
            }
        }];
        
        [authConnection startRequestWithMethod: authItem.httpMethod
                                           url: authItem.tokenUrl
                                   queryString: authItem.queryString
                                          body: authItem.body
                                       headers: customHeadersPlusAuth
                                       managed: YES
                                    onDidStart: nil
                                     onSuccess: ^( TNTHttpConnection *authConn, NSHTTPURLResponse *response, NSData *data ) {
                                         
                                         NSString *token = authItem.onParseTokenFromResponseBlock( originalRequest, response, data );
                                         if( token )
                                         {
                                             [authItem saveToken: token];
                                             
                                             [serializerQueue addOperationWithBlock: ^{
                                                 
                                                 authItem.authenticating = NO;
                                                 
                                                 for( TNTConnectionAndError *connToRetry in authItem.connectionsToRetry )
                                                 {
                                                     @synchronized( connToRetry.connection )
                                                     {
                                                         [connToRetry.connection.callerQueue waitUntilBlockFinished: ^{
                                                             [connToRetry.connection retryRequest];
                                                         }];
                                                     }
                                                 }
                                             }];
                                         }
                                         else
                                         {
                                             [serializerQueue addOperation: notifyErrorOperation];
                                         }
                                         
                                     } onError: ^( TNTHttpConnection *authConn, NSError *error ) {
                                         
                                         if( authItem.onAuthenticationErrorBlock != nil )
                                         {
                                             BOOL retry = authItem.onAuthenticationErrorBlock( originalRequest, authConn.lastResponse, error );
                                             if( retry )
                                             {
                                                 [authConn retryRequest];
                                                 return;
                                             }
                                         }
                                         
                                         [serializerQueue addOperation: notifyErrorOperation];
                                     }];
        authItem.authenticating = YES;
    }];

    return YES;
}

@end
