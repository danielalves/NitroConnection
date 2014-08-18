//
//  TNTHttpSession.m
//  NitroConnection
//
//  Created by Daniel L. Alves on 7/8/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import "TNTHttpSession.h"

// NitroConnection
#import "NSDictionary+QueryString.h"
#import "TNTHttpStatusCodes.h"

// Pods
#import <NitroMisc/NTRLogging.h>

#pragma mark - Defines

#if DEBUG
    #define DEFAULT_SESSION_TIMEOUT_INTERVAL_SECS 30
#else
    #define DEFAULT_SESSION_TIMEOUT_INTERVAL_SECS 3
#endif

#pragma mark - Statics

static NSTimeInterval TNTHttpSessionDefaultTimeoutInterval = DEFAULT_SESSION_TIMEOUT_INTERVAL_SECS;
static NSURLRequestCachePolicy TNTHttpSessionDefaultCachePolicy = NSURLRequestUseProtocolCachePolicy;

#pragma mark - Class Extension

@interface TNTHttpSession()
{
}
@property( nonatomic, readwrite, assign )BOOL requestAlive;
@property( nonatomic, readwrite, strong )NSURLSession *session;

@property( nonatomic, readwrite, strong )NSURLRequest *lastRequest;
@property( nonatomic, readwrite, strong )NSHTTPURLResponse *lastResponse;

@property( nonatomic, readwrite, copy )TNTHttpSessionDidStartBlock didStartBlock;
@property( nonatomic, readwrite, copy )TNTHttpSessionCompletionBlock completionBlock;

@end

#pragma mark - Implementation

@implementation TNTHttpSession

#pragma mark - Ctor & Dtor

-( instancetype )init
{
    self = [super init];
	if( self )
	{
        _cachePolicy = [TNTHttpSession defaultCachePolicy];
        _timeoutInterval = [TNTHttpSession defaultTimeoutInterval];
        
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
    self.completionBlock = nil;
	
	[self cancel];
}

#pragma mark - Public Methods

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
                    onCompletion: nil];
}

-( void )startRequestWithMethod:( TNTHttpMethod )httpMethod
                            url:( NSString * )url
                         params:( NSDictionary * )params
                        headers:( NSDictionary * )headers
                     onDidStart:( TNTHttpSessionDidStartBlock )didStartBlock
                   onCompletion:( TNTHttpSessionCompletionBlock )completionBlock
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
          onCompletion: completionBlock];
}

-( void )startRequest:( NSURLRequest * )request
{
    [self startRequest: request onDidStart: nil onCompletion: nil];
}

-( void )startRequest:( NSURLRequest * )request
           onDidStart:( TNTHttpSessionDidStartBlock )didStartBlock
         onCompletion:( TNTHttpSessionCompletionBlock )completionBlock
{
    self.didStartBlock = didStartBlock;
    self.completionBlock = completionBlock;
    
    [self makeRequest: request];
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
        
        responseDataBuffer = nil;
        
        callerQueue = nil;
        
        // We do not reset lastResponse here because the user may want to
        // check a connection response after it has been canceled
//    self.lastResponse = nil;
        
        // We do not reset lastRequest because the user may want to retry
//    self.lastRequest = nil;
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
            
            _connection = [TNTHttpConnection createConnectionWithRequest: request delegate: self];
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

#pragma mark - Class Methods

+( void )setDefaultCachePolicy:( NSURLRequestCachePolicy )_cachePolicy
{
    // This synchronization makes TNTHttpSessionDefaultCachePolicy attribution thread safe
    @synchronized( self )
    {
        TNTHttpSessionDefaultCachePolicy = _cachePolicy;
    }
}

+( NSURLRequestCachePolicy )defaultCachePolicy
{
    // Reads do not need to be synchronized: we will allow dirty reads. Afterall,
    // the user shouldn't change de default cache policy from different threads - this
    // operation is usually done in the application begginning.
//    @synchronized( self )
//    {
        return TNTHttpSessionDefaultCachePolicy;
//    }
}

+( void )setDefaultTimeoutInterval:( NSTimeInterval )timeoutInterval
{
    // This synchronization makes TNTHttpSessionDefaultTimeoutInterval attribution thread safe
    @synchronized( self )
    {
        TNTHttpSessionDefaultTimeoutInterval = timeoutInterval;
    }
}

+( NSTimeInterval )defaultTimeoutInterval
{
    // Reads do not need to be synchronized: we will allow dirty reads. Afterall,
    // the user shouldn't change de default timeout from different threads - this
    // operation is usually done in the application begginning.
//    @synchronized( self )
//    {
        return TNTHttpSessionDefaultTimeoutInterval;
//    }
}

@end
