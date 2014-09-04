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
 * Error Constants
 *
 ***********************************************************************/

/**
 *  TNTHttpConnection error domain
 */
FOUNDATION_EXPORT NSString * const TNTHttpConnectionErrorDomain;

/**
 *  Describes an HTTP error. That is, every non 2** status. See TNTHttpStatusCodes
 *  for more information.
 */
FOUNDATION_EXPORT const NSInteger TNTHttpConnectionErrorCodeHttpError;

/**
 *  A key contained in the userInfo dictionary property of a NSError object sent
 *  to request failure callbacks. Its value is a NSHTTPURLResponse object which
 *  holds the HTTP response to the failed request.
 */
FOUNDATION_EXPORT NSString * const TNTHttpConnectionErrorUserInfoResponseKey;

/**
 *  A key contained in the userInfo dictionary property of a NSError object sent
 *  to request failure callbacks. Its value is a NSData object which holds the
 *  HTTP response data.
 */
FOUNDATION_EXPORT NSString * const TNTHttpConnectionErrorUserInfoDataKey;

/***********************************************************************
 *
 * Helper Types
 *
 ***********************************************************************/

@class TNTHttpConnection;

/**
 *  Type of a block that is called just after a connection starts a request.
 *
 *  @param connection The connection which did start a request.
 */
typedef void ( ^TNTHttpConnectionDidStartBlock )( TNTHttpConnection *connection );

/**
 *  Type of a block that is called when a request succeeds.
 *
 *  @param connection The connection which started the request.
 *  @param response   The request response
 *  @param data       The data received
 */
typedef void ( ^TNTHttpConnectionSuccessBlock )( TNTHttpConnection *connection, NSHTTPURLResponse *response, NSData *data );

/**
 *  Type of a block that is called when a request fails or when the HTTP status code of the 
 *  response describes a HTTP error.
 *
 *  @param connection The connection which started the request.
 *  @param error      An error describing the cause of the failure.
 */
typedef void ( ^TNTHttpConnectionErrorBlock )( TNTHttpConnection *connection, NSError *error );

/**
 *  The TNTHttpConnectionDelegate protocol describes methods that should be implemented by the delegate for an instance of the TNTHttpConnection class.
 */
@protocol TNTHttpConnectionDelegate< NSObject >

	@optional
        /**
         *  Called just after a connection starts a request.
         *
         *  @param connection The connection which did start a request.
         */
		-( void )onTNTHttpConnectionDidStart:( TNTHttpConnection * )connection;

        /**
         *  Called when a request succeeds.
         *
         *  @param connection The connection which started the request.
         *  @param response   The request response
         *  @param data       The data received
         */
        -( void )onTNTHttpConnection:( TNTHttpConnection * )connection didReceiveResponse:( NSHTTPURLResponse * )response withData:( NSData * )data;

        /**
         *  Called when a request fails or when the HTTP status code of the response describes
         *  a HTTP error.
         *
         *  @param connection The connection which started the request.
         *  @param error      An error describing the cause of the failure.
         */
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
 *  - Easy query string, body and headers configuration.
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

/**
 *  Returns if there is a request being made. This property is KVO compliant.
 */
@property( nonatomic, readonly, assign )BOOL requestAlive;

/**
 *  The last request made by this connection.
 */
@property( nonatomic, readonly )NSURLRequest *lastRequest;

/**
 *  The response received for the last request made by this connection. This property is set to nil on every new request.
 */
@property( nonatomic, readonly )NSHTTPURLResponse *lastResponse;

/**
 *  The timeout interval to be used for requests started by this connection. This value
 *  overrides the default value set by +setDefaultTimeoutInterval:. This value is only
 *  ignored if the request sets a timeout interval for itself.
 *
 *  @see +setDefaultTimeoutInterval:
 *  @see +defaultTimeoutInterval
 */
@property( nonatomic, readwrite, assign )NSTimeInterval timeoutInterval;

/**
 *  The cache policy to be used for requests started by this connection. This value
 *  overrides the default value set by +setDefaultCachePolicy:. This value is only
 *  ignored if the request sets a cache policy for itself.
 *
 *  @see +setDefaultCachePolicy:
 *  @see +defaultCachePolicy
 */
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
 *                 If request sets a cache policy and/or a timeout interval for itself, these values will
 *                 override the class values and the values set for the connection.
 *
 *  @param managed If the request is managed or not. Managed requests make their connections live outside
 *                 the scope in which they were created, while unmanaged requests do not. If you do not cancel a
 *                 managed request prior to its end, it will run until it fails or succeeds. As for unmanaged 
 *                 requests, there is no need to cancel them explicitly, since this will be done automatically 
 *                 when the scope in which their connections were created is left - therefore you must keep a strong
 *                 reference to the connection to keep it alive.
 *
 *  @see -startRequest:managed:onDidStart:onSuccess:onError:
 *  @see -startRequestWithMethod:url:queryString:body:headers:managed:
 *  @see -startRequestWithMethod:url:queryString:body:headers:managed:onDidStart:onSuccess:onError:
 *  @see -cancelRequest
 *  @see -retryRequest
 */
-( void )startRequest:( NSURLRequest * )request managed:( BOOL )managed;

/**
 *  Starts a new request. If there is already a request being made, cancels it
 *  and then starts the new one.
 *
 *  @param request       The request that should be made. If this parameter is nil, this method does nothing.
 *                       If request sets a cache policy and/or a timeout interval for itself, these values will
 *                       override the class values and the values set for the connection.
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
 *
 *  @see -startRequest:managed:
 *  @see -startRequestWithMethod:url:queryString:body:headers:managed:
 *  @see -startRequestWithMethod:url:queryString:body:headers:managed:onDidStart:onSuccess:onError:
 *  @see -cancelRequest
 *  @see -retryRequest
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
 *  @param httpMethod  The HTTP request method.
 *
 *  @param url         The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body        The request body data. This parameter can be nil.
 *
 *  @param headers     HTTP headers that should be added to the request HTTP header dictionary. In keeping with
 *                     the HTTP RFC, HTTP header field names are case-insensitive. Values are added to header fields
 *                     incrementally. If a value was previously set for the specified field, the supplied value is
 *                     appended to the existing value using the HTTP field delimiter, a comma. Additionally, the
 *                     length of the upload body is determined automatically, then the value of Content-Length is set
 *                     for you. You should not modify the following headers: Authorization, Connection, Host and
 *                     WWW-Authenticate. This parameter can be nil.
 *
 *  @param managed     If the request is managed or not. Managed requests make their connections live outside
 *                     the scope in which they were created, while unmanaged requests do not. If you do not cancel a
 *                     managed request prior to its end, it will run until it fails or succeeds. As for unmanaged
 *                     requests, there is no need to cancel them explicitly, since this will be done automatically
 *                     when the scope in which their connections were created is left - therefore you must keep a strong
 *                     reference to the connection to keep it alive.
 *
 *  @see -startRequest:managed:
 *  @see -startRequest:managed:onDidStart:onSuccess:onError:
 *  @see -startRequestWithMethod:url:queryString:body:headers:managed:onDidStart:onSuccess:onError:
 *  @see -cancelRequest
 *  @see -retryRequest
 */
-( void )startRequestWithMethod:( TNTHttpMethod )httpMethod
                            url:( NSString * )url
                    queryString:( NSDictionary * )queryString
                           body:( NSData * )body
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
 *  @param queryString   The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body          The request body data. This parameter can be nil.
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
 *
 *  @see -startRequest:managed:
 *  @see -startRequest:managed:onDidStart:onSuccess:onError:
 *  @see -startRequestWithMethod:url:queryString:body:headers:managed:
 *  @see -cancelRequest
 *  @see -retryRequest
 */
-( void )startRequestWithMethod:( TNTHttpMethod )httpMethod
                            url:( NSString * )url
                    queryString:( NSDictionary * )queryString
                           body:( NSData * )body
                        headers:( NSDictionary * )headers
                        managed:( BOOL )managed
                     onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock
                      onSuccess:( TNTHttpConnectionSuccessBlock )successBlock
                        onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Retries the last request made. If there is a request being made and it has not yet finished,
 *  cancels it and then retries it.
 *
 *  @see -cancelRequest
 */
-( void )retryRequest;

/**
 *  Cancels the current request. If there is no current request, does nothing.
 *
 *  @see -retryRequest
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
 *
 *  @see +defaultCachePolicy
 */
+( void )setDefaultCachePolicy:( NSURLRequestCachePolicy )cachePolicy;

/**
 *  Returns the current default cache policy being used to configure all newly
 *  created connections.
 *
 *  @return The current default cache policy.
 *
 *  @see +setDefaultCachePolicy:
 */
+( NSURLRequestCachePolicy )defaultCachePolicy;

/**
 *  Sets the default timeout interval for all connection that will be created.
 *  Initially this value is 3 seconds for non DEBUG builds and 30 seconds
 *  otherwise.
 *
 *  @param timeoutInterval The new default timeout interval.
 *
 *  @see +defaultTimeoutInterval
 */
+( void )setDefaultTimeoutInterval:( NSTimeInterval )timeoutInterval;

/**
 *  Returns the current default timeout interval value being used to configure all newly
 *  created connections.
 *
 *  @return The current default timeout interval.
 *
 *  @see +setDefaultTimeoutInterval:
 */
+( NSTimeInterval )defaultTimeoutInterval;

/**
 *  @name HTTP Basic Access Authentication
 */

/**
 *  <#Description#>
 *
 *  @param regex                         <#regex description#>
 *  @param httpMethod                    <#httpMethod description#>
 *  @param url                           <#url description#>
 *  @param queryString                   <#queryString description#>
 *  @param body                          <#body description#>
 *  @param headers                       <#headers description#>
 *  @param onInformCredentialsBlock      <#onInformCredentialsBlock description#>
 *  @param onParseTokenFromResponseBlock <#onParseTokenFromResponseBlock description#>
 *  @param onAuthenticationErrorBlock    <#onAuthenticationErrorBlock description#>
 *
 *  @see http://en.wikipedia.org/wiki/Basic_access_authentication
 */
+( void )authenticateServicesMatching:( NSRegularExpression * )regex
               usingRequestWithMethod:( TNTHttpMethod )httpMethod
                                  url:( NSString * )url
                          queryString:( NSDictionary * )queryString
                                 body:( NSData * )body
                              headers:( NSDictionary * )headers
                  onInformCredentials:( NSString * (^)( NSURLRequest *originalRequest ))onInformCredentialsBlock
             onParseTokenFromResponse:( NSString * (^)( NSURLRequest *originalRequest, NSHTTPURLResponse *authenticationResponse ))onParseTokenFromResponseBlock
                onAuthenticationError:( BOOL(^)( NSURLRequest *originalRequest, NSHTTPURLResponse *authenticationResponse, NSError *error ))onAuthenticationErrorBlock;

@end

/***********************************************************************
 *
 * Overridable in subclasses
 *
 ***********************************************************************/

@interface TNTHttpConnection( Virtual )

/**
 *  Called as a connection loads data incrementally.
 *  The default implementation appends data to dataBuffer.
 *
 *  @param data       The newly available data.
 *
 *  @param dataBuffer The buffer that should be used to concatenate the contents of each data object delivered 
 *                    to build up the complete data for a URL load.
 */
-( void )onDidReceiveResponseData:( NSData * )data buffer:( NSData * )dataBuffer;

/**
 *  Returns if a request was successful.
 *  The default implementation returns YES for every 2** HTTP status codes, NO otherwise.
 *
 *  @param response     The HTTP response.
 *
 *  @param responseData The complete response data.
 *
 *  @param error        Should return an error describing why the request failed, or nil if the request
 *                      was successful.
 *
 *  @return YES if a request was successful, NO otherwise.
 */
-( BOOL )isSuccessfulResponse:( NSHTTPURLResponse * )response data:( NSData * )responseData error:( out NSError ** )error;

@end
