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
 *  Type of a block that is called when a request fails or when the HTTP status code of its
 *  response describes a HTTP error.
 *
 *  @param connection The connection which started the request.
 *  @param error      An error describing the cause of the failure.
 */
typedef void ( ^TNTHttpConnectionErrorBlock )( TNTHttpConnection *connection, NSError *error );

/**
 *  Type of a block that is called when an authentication token request needs the user credentials.
 *
 *  @param originalRequest The request which originated the authentication process.
 *
 *  @return The user credentials or nil if you don't have the user credentials. Returning nil
 *          will prevent the authentication process from starting and will trigger the delegate
 *          error callback/error block of the original TNTHttpConnection.
 */
typedef NSString * ( ^TNTHttpConnectionOAuthInformCredentialsBlock )( NSURLRequest *originalRequest );

/**
 *  Type of a block that is called when an authentication token request succeeds. You must parse the 
 *  authentication token and return it.
 *
 *  @param originalRequest         The request which originated the authentication process.
 *  @param authenticationResponse  The authentication token request response.
 *  @param responseData            The authentication token request response data.
 *
 *  @return The authentication token obtained by the authentication process, or nil if you could not
 *          parse the authentication token. Returning nil will trigger the authentication error block.
 *          Returning a valid token will fire a retryRequest for every TNTHttpConnection waiting for 
 *          the authentication process to finish.
 */
typedef NSString * ( ^TNTHttpConnectionOAuthParseTokenFromResponseBlock )( NSURLRequest *originalRequest, NSHTTPURLResponse *authenticationResponse, NSData *responseData );

/**
 *  Type of a block that is called when an authentication token request fails or when the HTTP status code
 *  of its response describes a HTTP error
 *
 *  @param originalRequest         The request which originated the authentication process.
 *  @param authenticationResponse  The authentication token request response.
 *  @param error                   An error specifying why the authentication token request failed.
 *
 *  @return YES if the authentication token request should be retried. NO otherwise. Returning NO will trigger 
 *          the delegate error callback/error block of every TNTHttpConnection waiting for the authentication 
 *          to process to finish.
 */
typedef BOOL ( ^TNTHttpConnectionOAuthAuthenticationErrorBlock )( NSURLRequest *originalRequest, NSHTTPURLResponse *authenticationResponse, NSError *error );

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
 *  - OAuth 2 (without refresh tokens).
 *  - Thread safety.
 *  - GET, HEAD, DELETE, POST, PUT and PATCH HTTP methods.
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
 *
 *
 *  OAuth 2
 *
 *
 *  TNTHttpConnection supports OAuth 2 without refresh tokens. This feature is designed to work transparently. Let's look at its flow, but
 *  keep in mind that the only step that gives you some work is step 1:
 *
 *  1) You set authentication items before making any request. Just after an application starts is a good choice. See these methods
 *     for more info about setting authentication items:
 *     - +authenticateServicesMatching:usingRequestWithMethod:tokenUrl:queryString:body:headers:keychainItemId:keychainItemAccessGroup:onInformCredentials:onParseTokenFromResponse:onAuthenticationError:
 *     - +authenticateServicesMatchingRegexString:usingRequestWithMethod:tokenUrl:queryString:body:headers:keychainItemId:keychainItemAccessGroup:onInformCredentials:onParseTokenFromResponse:onAuthenticationError:
 *
 *  2) After that, every request that fails with a 401 HTTP error code and that matches an authentication item will be put on hold
 *     while the authentication token is being obtained.
 *
 *  3) The authentication token request will be fired. This header will be included with others you may or may not have set:
 *     @{ @"Authorization": @"Basic <credentials>" }
 *
 *  4) While the token is being obtained, if other request that matches the same authentication item is fired (in fact, any other number
 *     of requests), it will be also be put on hold.
 *
 *  5) If the authentication token request ...
 *
 *     5.1) Succeeds, retryRequest will be called on every connection that was put on hold and that is still
 *          alive. But, now, the authentication token will be sent in the Authorization HTTP Header like so:
 *          @{ @"Authorization" : @"Bearer <token>" }
 *
 *     5.2) Fails, you will have the chance to retry the authentication token request or to give up. If you...
 *
 *          5.2.1) Give up, all on hold connections that are still alive will have their delegate error callbacks/ erros
 *                 blocks called, the same way they would if there was no authentication process in place.
 *
 *          5.2.2) Want to retry, you will be back at step 3.
 *
 *  6) When a token expires, you will be back at step 2.
 *
 *  As you can see, besides setting authentication items, there is nothing more you have to do. You just use TNTHttpConnection 
 *  as before =D
 *
 *  TNTHttpConnection automatically handles HTTPS authentication challenges for you: authentication token urls and all urls that are matched
 *  by authentication item regexes will be trusted.
 *
 *  For more information about OAuth 2 and HTTP Basic Authentication, see:
 *    - http://tools.ietf.org/html/rfc6749
 *    - http://en.wikipedia.org/wiki/OAuth
 *    - http://en.wikipedia.org/wiki/Basic_access_authentication
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
 *  @param httpMethod  The request HTTP method.
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
 *  @param httpMethod    The request HTTP method.
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
 *  @name OAuth 2
 */

/**
 *  Creates an authentication item that will handle all TNTHttpConnections whose urls are matched by regex.
 *  See TNTHttpConnection class documentation for more info about the authentication process.
 *
 *  This is the same as calling:
 *
 *  +authenticateServicesMatching:
 *         usingRequestWithMethod:
 *                       tokenUrl:
 *                    queryString:
 *                           body:
 *                        headers:
 *                 keychainItemId:
 *        keychainItemAccessGroup:
 *            onInformCredentials:
 *       onParseTokenFromResponse:
 *          onAuthenticationError:
 *
 *  With a regex created like this:
 *
 *  @code
 *  NSError *error;
 *  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: regexString
 *                                                                         options: NSRegularExpressionCaseInsensitive
 *                                                                           error: &error];
 *  @endcode
 *
 *  @param regexString                   A string that will be converted into a regex describing which urls should be handled by this
 *                                       authentication item. This parameter cannot be nil.
 *
 *  @param httpMethod                    The authentication token request HTTP method.
 *
 *  @param tokenUrl                      The authentication token request url - should be HTTPS. This parameter cannot be nil.
 *
 *  @param queryString                   The authentication token request query string. All keys and values will be escaped. This
 *                                       parameter can be nil.
 *
 *  @param body                          The authentication token request body data. This parameter can be nil.
 *
 *  @param headers                       HTTP headers that should be added to the authentication token request HTTP header dictionary.
 *                                       In keeping with the HTTP RFC, HTTP header field names are case-insensitive. Values are added
 *                                       to header fields incrementally. If a value was previously set for the specified field, the
 *                                       supplied value is appended to the existing value using the HTTP field delimiter, a comma.
 *                                       Additionally, the length of the upload body is determined automatically, then the value of
 *                                       Content-Length is set for you. You should not modify the following headers: Authorization,
 *                                       Connection, Host and WWW-Authenticate. This parameter can be nil.
 *
 *  @param keychainItemId                The keychain item id under which the authentication token will be stored. This value must be
 *                                       unique for each keychain entry. This parameter cannot be nil.
 *
 *  @param keychainItemAccessGroup       The keychain item access group for the authentication token. The keychain access group attribute
 *                                       determines if an item can be shared amongst multiple apps whose code signing entitlements contain
 *                                       the same keychain access group. This parameter can be nil.
 *
 *  @param onInformCredentialsBlock      The block that is called when an authentication token request needs the user credentials. See
 *                                       TNTHttpConnectionOAuthInformCredentialsBlock documentation for more info. This parameter cannot
 *                                       be nil.
 *
 *  @param onParseTokenFromResponseBlock The block that is called when an authentication token request succeeds. See
 *                                       TNTHttpConnectionOAuthParseTokenFromResponseBlock documentation for more info. This parameter cannot
 *                                       be nil.
 *
 *  @param onAuthenticationErrorBlock    The block that is called when an authentication token request fails or when the HTTP status code
 *                                       of its response describes a HTTP error. This parameter can be nil.
 *
 *  @throws NSInvalidArgumentException if onInformCredentialsBlock or onParseTokenFromResponseBlock is nil.
 *  @throws NSInvalidArgumentException if regexString, tokenUrl or keychainItemId is invalid.
 *
 *  @see +authenticateServicesMatching:usingRequestWithMethod:tokenUrl:queryString:body:headers:keychainItemId:keychainItemAccessGroup:onInformCredentials:onParseTokenFromResponse:onAuthenticationError:
 *  @see +removeAllAuthenticationItems
 */

+( void )authenticateServicesMatchingRegexString:( NSString * )regexString
                          usingRequestWithMethod:( TNTHttpMethod )httpMethod
                                        tokenUrl:( NSString * )tokenUrl
                                     queryString:( NSDictionary * )queryString
                                            body:( NSData * )body
                                         headers:( NSDictionary * )headers
                                  keychainItemId:( NSString * )keychainItemId
                         keychainItemAccessGroup:( NSString * )keychainItemAccessGroup
                             onInformCredentials:( TNTHttpConnectionOAuthInformCredentialsBlock )onInformCredentialsBlock
                        onParseTokenFromResponse:( TNTHttpConnectionOAuthParseTokenFromResponseBlock )onParseTokenFromResponseBlock
                           onAuthenticationError:( TNTHttpConnectionOAuthAuthenticationErrorBlock )onAuthenticationErrorBlock;

/**
 *  Creates an authentication item that will handle all TNTHttpConnections whose urls are matched by regex.
 *  See TNTHttpConnection class documentation for more info about the authentication process.
 *
 *  @param regex                         A regex describing which urls should be handled by this authentication item. This
 *                                       parameter cannot be nil.
 *
 *  @param httpMethod                    The authentication token request HTTP method.
 *
 *  @param tokenUrl                      The authentication token request url - should be HTTPS. This parameter cannot be nil.
 *
 *  @param queryString                   The authentication token request query string. All keys and values will be escaped. This
 *                                       parameter can be nil.
 *
 *  @param body                          The authentication token request body data. This parameter can be nil.
 *
 *  @param headers                       HTTP headers that should be added to the authentication token request HTTP header dictionary.
 *                                       In keeping with the HTTP RFC, HTTP header field names are case-insensitive. Values are added 
 *                                       to header fields incrementally. If a value was previously set for the specified field, the 
 *                                       supplied value is appended to the existing value using the HTTP field delimiter, a comma. 
 *                                       Additionally, the length of the upload body is determined automatically, then the value of 
 *                                       Content-Length is set for you. You should not modify the following headers: Authorization, 
 *                                       Connection, Host and WWW-Authenticate. This parameter can be nil.
 *
 *  @param keychainItemId                The keychain item id under which the authentication token will be stored. This value must be 
 *                                       unique for each keychain entry. This parameter cannot be nil.
 *
 *  @param keychainItemAccessGroup       The keychain item access group for the authentication token. The keychain access group attribute
 *                                       determines if an item can be shared amongst multiple apps whose code signing entitlements contain
 *                                       the same keychain access group. This parameter can be nil.
 *
 *  @param onInformCredentialsBlock      The block that is called when an authentication token request needs the user credentials. See
 *                                       TNTHttpConnectionOAuthInformCredentialsBlock documentation for more info. This parameter cannot 
 *                                       be nil.
 *
 *  @param onParseTokenFromResponseBlock The block that is called when an authentication token request succeeds. See
 *                                       TNTHttpConnectionOAuthParseTokenFromResponseBlock documentation for more info. This parameter cannot 
 *                                       be nil.
 *
 *  @param onAuthenticationErrorBlock    The block that is called when an authentication token request fails or when the HTTP status code
 *                                       of its response describes a HTTP error. This parameter can be nil.
 *
 *  @throws NSInvalidArgumentException if regex, onInformCredentialsBlock or onParseTokenFromResponseBlock is nil.
 *  @throws NSInvalidArgumentException if tokenUrl or keychainItemId is invalid.
 *
 *  @see +authenticateServicesMatchingRegexString:usingRequestWithMethod:tokenUrl:queryString:body:headers:keychainItemId:keychainItemAccessGroup:onInformCredentials:onParseTokenFromResponse:onAuthenticationError:
 *  @see +removeAllAuthenticationItems
 */
+( void )authenticateServicesMatching:( NSRegularExpression * )regex
               usingRequestWithMethod:( TNTHttpMethod )httpMethod
                             tokenUrl:( NSString * )tokenUrl
                          queryString:( NSDictionary * )queryString
                                 body:( NSData * )body
                              headers:( NSDictionary * )headers
                       keychainItemId:( NSString * )keychainItemId
              keychainItemAccessGroup:( NSString * )keychainItemAccessGroup
                  onInformCredentials:( TNTHttpConnectionOAuthInformCredentialsBlock )onInformCredentialsBlock
             onParseTokenFromResponse:( TNTHttpConnectionOAuthParseTokenFromResponseBlock )onParseTokenFromResponseBlock
                onAuthenticationError:( TNTHttpConnectionOAuthAuthenticationErrorBlock )onAuthenticationErrorBlock;

/**
 *  Deletes all authentication items.
 *
 *  @see +authenticateServicesMatching:usingRequestWithMethod:tokenUrl:queryString:body:headers:keychainItemId:keychainItemAccessGroup:onInformCredentials:onParseTokenFromResponse:onAuthenticationError:
 *  @see +authenticateServicesMatchingRegexString:usingRequestWithMethod:tokenUrl:queryString:body:headers:keychainItemId:keychainItemAccessGroup:onInformCredentials:onParseTokenFromResponse:onAuthenticationError:
 */
+( void )removeAllAuthenticationItems;

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
