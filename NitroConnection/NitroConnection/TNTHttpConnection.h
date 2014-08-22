//
//  TNTHttpConnection.h
//  NitroConnection
//
//  Created by Daniel L. Alves on 31/03/11.
//  Copyright 2011 Daniel L. Alves. All rights reserved.
//

#import <Foundation/Foundation.h>

// NitroConnection
#import "TNTHttpMethods.h"

/***********************************************************************
 *
 * Constants
 *
 ***********************************************************************/

FOUNDATION_EXPORT NSString * const TNTHttpConnectionErrorDomain;

FOUNDATION_EXPORT NSString * const TNTHttpConnectionErrorUserInfoResponseKey;
FOUNDATION_EXPORT NSString * const TNTHttpConnectionErrorUserInfoDataKey;

FOUNDATION_EXPORT const NSInteger TNTHttpConnectionErrorCodeHttpError;

/***********************************************************************
 *
 * Helper Types
 *
 ***********************************************************************/

@class TNTHttpConnection;

typedef void ( ^TNTHttpConnectionDidStartBlock )( TNTHttpConnection *connection );
typedef void ( ^TNTHttpConnectionSuccessBlock )( TNTHttpConnection *connection, NSHTTPURLResponse *response, NSData *data );
typedef void ( ^TNTHttpConnectionErrorBlock )( TNTHttpConnection *connection, NSError *error );

/***********************************************************************
 *
 * TNTHttpConnectionDelegate
 *
 ***********************************************************************/

@class TNTHttpConnection;

@protocol TNTHttpConnectionDelegate< NSObject >

	@optional
		-( void )onTNTHttpConnectionDidStart:( TNTHttpConnection * )connection;

        -( void )onTNTHttpConnection:( TNTHttpConnection * )connection didReceiveResponse:( NSHTTPURLResponse * )response withData:( NSData * )data;

		-( void )onTNTHttpConnection:( TNTHttpConnection * )connection didFailWithError:( NSError * )error;
@end


/**
 *  TNTHttpConnection is a very fast, simple and lightweight HTTP connection wrapper for iOS. It focus on performance and on the fact that the programmer 
 *  should not pay for something he/she is not using. That is, your code should not loose performance or cause unneeded internet traffic because a connection
 *  was kept alive, running in background, while it should have already been canceled. Nevertheless, NitroConnection strives to achieve ease of use and to offer
 *  common functionality, like fire and forget requests.
 *
 *  Some of its features are:
 *
 *  - Thread safety.
 *  - It supports GET, HEAD, DELETE, POST, PUT and PATCH HTTP methods.
 *  - Easy query string, body params and headers configuration.
 *  - Global, per connection and per request cache policy and timeout interval configuration.
 *  - Its callbacks come in two flavors: via delegate and via blocks.
 *  - A single NitroConnection can be used to make any number of requests.
 *  - Simple retry! Just call... retryRequest!
 *  - All requests are ran outside of the main queue, so the application interface keeps as fast as it should.
 *  - Offers a way to set a request as managed or unmanaged, giving you more control on what is happening behind the scenes.
 *
 *  Managed requests make their connections live outside the scope in which they were created. Therefore the user should know that, if he/she does not cancel them, 
 *  they will run until failure or success, keeping their connection in memory during the process.
 *
 *  As opposed to managed requests, unmanaged requests do not hold their connections alive, so those connections are released as soon as the scope in which they were 
 *  created is left. That is, there is no need for the user to call cancelRequest on a connection running an unmanaged request prior to its deallocation. Therefore the
 *  user must keep a strong reference to the connection to keep it alive.
 */
@interface TNTHttpConnection : NSObject

/**
 *  The delegate of the connection. Its callbacks will be called in the same queue
 *  from which the current request was started.
 */
@property( nonatomic, readwrite, weak )id< TNTHttpConnectionDelegate > delegate;

@property( nonatomic, readonly, assign )BOOL requestAlive;

@property( nonatomic, readonly )NSURLRequest *lastRequest;
@property( nonatomic, readonly )NSHTTPURLResponse *lastResponse;

@property( nonatomic, readwrite, assign )NSTimeInterval timeoutInterval;
@property( nonatomic, readwrite, assign )NSURLRequestCachePolicy cachePolicy;

/***********************************************************************
 *
 * @name Request management
 *
 ***********************************************************************/

/**
 *  Starts a new request. If there is already a request being made, cancels it
 *  and then starts the new one.
 *
 *  @param request The request that should be made. If this parameter is nil, this method does nothing.
 *
 *  @param managed If the request is managed or not. Managed requests make their connections live outside
 *                 the scope in which they were created, while unmanaged requests do not. If you do not cancel a
 *                 managed request prior to its end, it will run until it fails or succeeds. As for unmanaged 
 *                 requests, there is no need to cancel them explicitly, since this will be done automatically 
 *                 when the scope in which their connections were created is left - therefore you must keep a strong
 *                 reference to the connection to keep it alive.
 */
-( void )startRequest:( NSURLRequest * )request managed:( BOOL )managed;

/**
 *  Starts a new request. If there is already a request being made, cancels it
 *  and then starts the new one.
 *
 *  @param request       The request that should be made. If this parameter is nil, this method does nothing.
 *
 *  @param managed       If the request is managed or not. Managed requests make their connections live outside
 *                       the scope in which they were created, while unmanaged requests do not. If you do not cancel a
 *                       managed request prior to its end, it will run until it fails or succeeds. As for unmanaged
 *                       requests, there is no need to cancel them explicitly, since this will be done automatically
 *                       when the scope in which their connections were created is left - therefore you must keep a strong
 *                       reference to the connection to keep it alive.
 *
 *  @param didStartBlock The block that will be called when the request starts. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param successBlock  The block that will be called if the request succeeds. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param errorBlock    The block that will be called if the request fails. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 */
-( void )startRequest:( NSURLRequest * )request
              managed:( BOOL )managed
           onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock
            onSuccess:( TNTHttpConnectionSuccessBlock )successBlock
              onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Starts a new request. If there is already a request being made, cancels it
 *  and then starts the new one.
 *
 *  @param httpMethod The HTTP request method.
 *
 *  @param url        The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params     The parameters of the request. If httpMethod is TNTHttpMethodGet, TNTHttpMethodHead
 *                    or TNTHttpMethodDelete, sends the parameters in the query string. If httpMethod is
 *                    TNTHttpMethodPost, TNTHttpMethodPut or TNTHttpMethodPatch, sends the parameters in
 *                    the request body. This parameter can be nil.
 *
 *  @param headers    HTTP headers that should be added to the request HTTP header dictionary. In keeping with
 *                    the HTTP RFC, HTTP header field names are case-insensitive. Values are added to header fields
 *                    incrementally. If a value was previously set for the specified field, the supplied value is
 *                    appended to the existing value using the HTTP field delimiter, a comma. Additionally, the
 *                    length of the upload body is determined automatically, then the value of Content-Length is set
 *                    for you. You should not modify the following headers: Authorization, Connection, Host and
 *                    WWW-Authenticate. This parameter can be nil.
 *
 *  @param managed    If the request is managed or not. Managed requests make their connections live outside
 *                    the scope in which they were created, while unmanaged requests do not. If you do not cancel a
 *                    managed request prior to its end, it will run until it fails or succeeds. As for unmanaged
 *                    requests, there is no need to cancel them explicitly, since this will be done automatically
 *                    when the scope in which their connections were created is left - therefore you must keep a strong
 *                    reference to the connection to keep it alive.
 */
-( void )startRequestWithMethod:( TNTHttpMethod )httpMethod
                            url:( NSString * )url
                         params:( NSDictionary * )params
                        headers:( NSDictionary * )headers
                        managed:( BOOL )managed;

/**
 *  Starts a new request. If there is already a request being made, cancels it
 *  and then starts the new one.
 *
 *  @param httpMethod    The HTTP request method.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params        The parameters of the request. If httpMethod is TNTHttpMethodGet, TNTHttpMethodHead 
 *                       or TNTHttpMethodDelete, sends the parameters in the query string. If httpMethod is
 *                       TNTHttpMethodPost, TNTHttpMethodPut or TNTHttpMethodPatch, sends the parameters in
 *                       the request body. This parameter can be nil.
 *
 *  @param headers       HTTP headers that should be added to the request HTTP header dictionary.  In keeping with 
 *                       the HTTP RFC, HTTP header field names are case-insensitive. Values are added to header fields
 *                       incrementally. If a value was previously set for the specified field, the supplied value is
 *                       appended to the existing value using the HTTP field delimiter, a comma. Additionally, the
 *                       length of the upload body is determined automatically, then the value of Content-Length is set
 *                       for you. You should not modify the following headers: Authorization, Connection, Host and 
 *                       WWW-Authenticate. This parameter can be nil.
 *
 *  @param managed       If the request is managed or not. Managed requests make their connections live outside
 *                       the scope in which they were created, while unmanaged requests do not. If you do not cancel a
 *                       managed request prior to its end, it will run until it fails or succeeds. As for unmanaged
 *                       requests, there is no need to cancel them explicitly, since this will be done automatically
 *                       when the scope in which their connections were created is left - therefore you must keep a strong
 *                       reference to the connection to keep it alive.
 *
 *  @param didStartBlock The block that will be called when the request starts. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param successBlock  The block that will be called if the request succeeds. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param errorBlock    The block that will be called if the request fails. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 */
-( void )startRequestWithMethod:( TNTHttpMethod )httpMethod
                            url:( NSString * )url
                         params:( NSDictionary * )params
                        headers:( NSDictionary * )headers
                        managed:( BOOL )managed
                     onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock
                      onSuccess:( TNTHttpConnectionSuccessBlock )successBlock
                        onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Retries the last request made. If there is a request being made and it has not yet finished,
 *  cancels it and then retries it.
 */
-( void )retryRequest;

/**
 *  Cancels the current request. If there is no current request, does nothing.
 */
-( void )cancelRequest;

/***********************************************************************
 *
 * @name Default configurations
 *
 ***********************************************************************/

/**
 *  Sets the default cache policy for all connection that will be created.
 *  Initially this value is NSURLRequestUseProtocolCachePolicy.
 *
 *  @param cachePolicy The new default cache policy.
 */
+( void )setDefaultCachePolicy:( NSURLRequestCachePolicy )cachePolicy;

/**
 *  Returns the current default cache policy being used to configure all newly
 *  created connections.
 *
 *  @return The current default cache policy.
 */
+( NSURLRequestCachePolicy )defaultCachePolicy;

/**
 *  Sets the default timeout interval for all connection that will be created.
 *  Initially this value is 3 seconds for non DEBUG builds and 30 seconds
 *  otherwise.
 *
 *  @param timeoutInterval The new default timeout interval.
 */
+( void )setDefaultTimeoutInterval:( NSTimeInterval )timeoutInterval;

/**
 *  Returns the current default timeout interval value being used to configure all newly
 *  created connections.
 *
 *  @return The current default timeout interval.
 */
+( NSTimeInterval )defaultTimeoutInterval;

@end

/***********************************************************************
 *
 * Overridable in subclasses
 *
 ***********************************************************************/

@interface TNTHttpConnection( Virtual )

-( void )onDidReceiveResponseData:( NSData * )data buffer:( NSData * )dataBuffer;
-( BOOL )isSuccessfulResponse:( NSHTTPURLResponse * )response data:( NSData * )responseData error:( out NSError ** )error;

@end
