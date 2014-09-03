//
//  TNTHttpConnection+SyntaticSugar.h
//  NitroConnection
//
//  Created by Daniel L. Alves on 05/08/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import "TNTHttpConnection.h"

// NitroConnection
#import "TNTHttpMethods.h"  

@interface TNTHttpConnection( SyntaticSugar )

/**
 *  @name HTTP GET Syntatic Sugar Methods
 */

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP GET managed request.
 *
 *  @param url      The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param delegate The delegate of the connection. Its callbacks will be called in the same queue
 *                  from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP GET managed request.
 */
+( instancetype )get:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP GET managed request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP GET managed request.
 */
+( instancetype )get:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP GET managed request.
 *
 *  @param url      The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params   The parameters of the request which are sent in its query string. All keys and 
 *                  values will be escaped. This parameter can be nil.
 *
 *  @param delegate The delegate of the connection. Its callbacks will be called in the same queue
 *                  from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP GET managed request.
 */
+( instancetype )get:( NSString * )url params:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP GET managed request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params        The parameters of the request which are sent in its query string. All keys and
 *                       values will be escaped. This parameter can be nil.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP GET managed request.
 */
+( instancetype )get:( NSString * )url params:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP GET managed request.
 *
 *  @param url         The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body        The request body data. This parameter can be nil.
 *
 *  @param delegate    The delegate of the connection. Its callbacks will be called in the same queue
 *                     from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP GET managed request.
 */
+( instancetype )get:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP GET managed request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString   The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body          The request body data. This parameter can be nil.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP GET managed request.
 */
+( instancetype )get:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP GET managed request.
 *
 *  @param url         The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body        The request body data. This parameter can be nil.
 *
 *  @param headers     HTTP headers that should be added to the request HTTP header dictionary.  In keeping with
 *                     the HTTP RFC, HTTP header field names are case-insensitive. Values are added to header fields
 *                     incrementally. If a value was previously set for the specified field, the supplied value is
 *                     appended to the existing value using the HTTP field delimiter, a comma. Additionally, the
 *                     length of the upload body is determined automatically, then the value of Content-Length is set
 *                     for you. You should not modify the following headers: Authorization, Connection, Host and
 *                     WWW-Authenticate. This parameter can be nil.
 *
 *  @param delegate    The delegate of the connection. Its callbacks will be called in the same queue
 *                     from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP GET managed request.
 */
+( instancetype )get:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;

/*
 *  Returns a new TNTHttpConnection with an already configured and started HTTP GET managed request.
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
 *  @param didStartBlock The block that will be called when the request starts. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param successBlock  The block that will be called if the request succeeds. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param errorBlock    The block that will be called if the request fails. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP GET managed request.
 */
+( instancetype )get:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP GET unmanaged request.
 *
 *  @param url      The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param delegate The delegate of the connection. Its callbacks will be called in the same queue
 *                  from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP GET unmanaged request.
 */
+( instancetype )unmanagedGet:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP GET unmanaged request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP GET unmanaged request.
 */
+( instancetype )unmanagedGet:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP GET unmanaged request.
 *
 *  @param url      The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params   The parameters of the request which are sent in its query string. All keys and
 *                  values will be escaped. This parameter can be nil.
 *
 *  @param delegate The delegate of the connection. Its callbacks will be called in the same queue
 *                  from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP GET unmanaged request.
 */
+( instancetype )unmanagedGet:( NSString * )url params:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP GET unmanaged request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params        The parameters of the request which are sent in its query string. All keys and
 *                       values will be escaped. This parameter can be nil.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP GET unmanaged request.
 */
+( instancetype )unmanagedGet:( NSString * )url params:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP GET unmanaged request.
 *
 *  @param url         The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body        The request body data. This parameter can be nil.
 *
 *  @param delegate    The delegate of the connection. Its callbacks will be called in the same queue
 *                     from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP GET unmanaged request.
 */
+( instancetype )unmanagedGet:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP GET unmanaged request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString   The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body          The request body data. This parameter can be nil.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP GET unmanaged request.
 */
+( instancetype )unmanagedGet:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP GET unmanaged request.
 *
 *  @param url         The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body        The request body data. This parameter can be nil.
 *
 *  @param headers     HTTP headers that should be added to the request HTTP header dictionary.  In keeping with
 *                     the HTTP RFC, HTTP header field names are case-insensitive. Values are added to header fields
 *                     incrementally. If a value was previously set for the specified field, the supplied value is
 *                     appended to the existing value using the HTTP field delimiter, a comma. Additionally, the
 *                     length of the upload body is determined automatically, then the value of Content-Length is set
 *                     for you. You should not modify the following headers: Authorization, Connection, Host and
 *                     WWW-Authenticate. This parameter can be nil.
 *
 *  @param delegate    The delegate of the connection. Its callbacks will be called in the same queue
 *                     from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP GET unmanaged request.
 */
+( instancetype )unmanagedGet:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP GET unmanaged request.
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
 *  @param didStartBlock The block that will be called when the request starts. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param successBlock  The block that will be called if the request succeeds. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param errorBlock    The block that will be called if the request fails. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP GET unmanaged request.
 */
+( instancetype )unmanagedGet:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  @name HTTP HEAD Syntatic Sugar Methods
 */

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP HEAD managed request.
 *
 *  @param url      The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param delegate The delegate of the connection. Its callbacks will be called in the same queue
 *                  from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP HEAD managed request.
 */
+( instancetype )head:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP HEAD managed request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP HEAD managed request.
 */
+( instancetype )head:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP HEAD managed request.
 *
 *  @param url      The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params   The parameters of the request which are sent in its query string. All keys and
 *                  values will be escaped. This parameter can be nil.
 *
 *  @param delegate The delegate of the connection. Its callbacks will be called in the same queue
 *                  from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP HEAD managed request.
 */
+( instancetype )head:( NSString * )url params:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP HEAD managed request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params        The parameters of the request which are sent in its query string. All keys and
 *                       values will be escaped. This parameter can be nil.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP HEAD managed request.
 */
+( instancetype )head:( NSString * )url params:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP HEAD managed request.
 *
 *  @param url         The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body        The request body data. This parameter can be nil.
 *
 *  @param delegate    The delegate of the connection. Its callbacks will be called in the same queue
 *                     from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP HEAD managed request.
 */
+( instancetype )head:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP HEAD managed request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString   The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body          The request body data. This parameter can be nil.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP HEAD managed request.
 */
+( instancetype )head:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP HEAD managed request.
 *
 *  @param url         The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body        The request body data. This parameter can be nil.
 *
 *  @param headers     HTTP headers that should be added to the request HTTP header dictionary.  In keeping with
 *                     the HTTP RFC, HTTP header field names are case-insensitive. Values are added to header fields
 *                     incrementally. If a value was previously set for the specified field, the supplied value is
 *                     appended to the existing value using the HTTP field delimiter, a comma. Additionally, the
 *                     length of the upload body is determined automatically, then the value of Content-Length is set
 *                     for you. You should not modify the following headers: Authorization, Connection, Host and
 *                     WWW-Authenticate. This parameter can be nil.
 *
 *  @param delegate    The delegate of the connection. Its callbacks will be called in the same queue
 *                     from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP HEAD managed request.
 */
+( instancetype )head:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;

/*
 *  Returns a new TNTHttpConnection with an already configured and started HTTP HEAD managed request.
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
 *  @param didStartBlock The block that will be called when the request starts. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param successBlock  The block that will be called if the request succeeds. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param errorBlock    The block that will be called if the request fails. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP HEAD managed request.
 */
+( instancetype )head:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP HEAD unmanaged request.
 *
 *  @param url      The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param delegate The delegate of the connection. Its callbacks will be called in the same queue
 *                  from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP HEAD unmanaged request.
 */
+( instancetype )unmanagedHead:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP HEAD unmanaged request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP HEAD unmanaged request.
 */
+( instancetype )unmanagedHead:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP HEAD unmanaged request.
 *
 *  @param url      The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params   The parameters of the request which are sent in its query string. All keys and
 *                  values will be escaped. This parameter can be nil.
 *
 *  @param delegate The delegate of the connection. Its callbacks will be called in the same queue
 *                  from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP HEAD unmanaged request.
 */
+( instancetype )unmanagedHead:( NSString * )url params:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP HEAD unmanaged request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params        The parameters of the request which are sent in its query string. All keys and
 *                       values will be escaped. This parameter can be nil.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP HEAD unmanaged request.
 */
+( instancetype )unmanagedHead:( NSString * )url params:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP HEAD unmanaged request.
 *
 *  @param url         The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body        The request body data. This parameter can be nil.
 *
 *  @param delegate    The delegate of the connection. Its callbacks will be called in the same queue
 *                     from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP HEAD unmanaged request.
 */
+( instancetype )unmanagedHead:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP HEAD unmanaged request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString   The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body          The request body data. This parameter can be nil.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP HEAD unmanaged request.
 */
+( instancetype )unmanagedHead:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP HEAD unmanaged request.
 *
 *  @param url         The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body        The request body data. This parameter can be nil.
 *
 *  @param headers     HTTP headers that should be added to the request HTTP header dictionary.  In keeping with
 *                     the HTTP RFC, HTTP header field names are case-insensitive. Values are added to header fields
 *                     incrementally. If a value was previously set for the specified field, the supplied value is
 *                     appended to the existing value using the HTTP field delimiter, a comma. Additionally, the
 *                     length of the upload body is determined automatically, then the value of Content-Length is set
 *                     for you. You should not modify the following headers: Authorization, Connection, Host and
 *                     WWW-Authenticate. This parameter can be nil.
 *
 *  @param delegate    The delegate of the connection. Its callbacks will be called in the same queue
 *                     from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP HEAD unmanaged request.
 */
+( instancetype )unmanagedHead:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP HEAD unmanaged request.
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
 *  @param didStartBlock The block that will be called when the request starts. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param successBlock  The block that will be called if the request succeeds. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param errorBlock    The block that will be called if the request fails. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP HEAD unmanaged request.
 */
+( instancetype )unmanagedHead:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  @name HTTP DELETE Syntatic Sugar Methods
 */

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP DELETE managed request.
 *
 *  @param url      The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param delegate The delegate of the connection. Its callbacks will be called in the same queue
 *                  from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP DELETE managed request.
 */
+( instancetype )delete:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP DELETE managed request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP DELETE managed request.
 */
+( instancetype )delete:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP DELETE managed request.
 *
 *  @param url      The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params   The parameters of the request which are sent in its query string. All keys and
 *                  values will be escaped. This parameter can be nil.
 *
 *  @param delegate The delegate of the connection. Its callbacks will be called in the same queue
 *                  from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP DELETE managed request.
 */
+( instancetype )delete:( NSString * )url params:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP DELETE managed request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params        The parameters of the request which are sent in its query string. All keys and
 *                       values will be escaped. This parameter can be nil.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP DELETE managed request.
 */
+( instancetype )delete:( NSString * )url params:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP DELETE managed request.
 *
 *  @param url         The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body        The request body data. This parameter can be nil.
 *
 *  @param delegate    The delegate of the connection. Its callbacks will be called in the same queue
 *                     from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP DELETE managed request.
 */
+( instancetype )delete:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP DELETE managed request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString   The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body          The request body data. This parameter can be nil.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP DELETE managed request.
 */
+( instancetype )delete:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP DELETE managed request.
 *
 *  @param url         The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body        The request body data. This parameter can be nil.
 *
 *  @param headers     HTTP headers that should be added to the request HTTP header dictionary.  In keeping with
 *                     the HTTP RFC, HTTP header field names are case-insensitive. Values are added to header fields
 *                     incrementally. If a value was previously set for the specified field, the supplied value is
 *                     appended to the existing value using the HTTP field delimiter, a comma. Additionally, the
 *                     length of the upload body is determined automatically, then the value of Content-Length is set
 *                     for you. You should not modify the following headers: Authorization, Connection, Host and
 *                     WWW-Authenticate. This parameter can be nil.
 *
 *  @param delegate    The delegate of the connection. Its callbacks will be called in the same queue
 *                     from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP DELETE managed request.
 */
+( instancetype )delete:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;

/*
 *  Returns a new TNTHttpConnection with an already configured and started HTTP DELETE managed request.
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
 *  @param didStartBlock The block that will be called when the request starts. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param successBlock  The block that will be called if the request succeeds. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param errorBlock    The block that will be called if the request fails. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP DELETE managed request.
 */
+( instancetype )delete:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP DELETE unmanaged request.
 *
 *  @param url      The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param delegate The delegate of the connection. Its callbacks will be called in the same queue
 *                  from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP DELETE unmanaged request.
 */
+( instancetype )unmanagedDelete:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP DELETE unmanaged request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP DELETE unmanaged request.
 */
+( instancetype )unmanagedDelete:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP DELETE unmanaged request.
 *
 *  @param url      The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params   The parameters of the request which are sent in its query string. All keys and
 *                  values will be escaped. This parameter can be nil.
 *
 *  @param delegate The delegate of the connection. Its callbacks will be called in the same queue
 *                  from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP DELETE unmanaged request.
 */
+( instancetype )unmanagedDelete:( NSString * )url params:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP DELETE unmanaged request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params        The parameters of the request which are sent in its query string. All keys and
 *                       values will be escaped. This parameter can be nil.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP DELETE unmanaged request.
 */
+( instancetype )unmanagedDelete:( NSString * )url params:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP DELETE unmanaged request.
 *
 *  @param url         The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body        The request body data. This parameter can be nil.
 *
 *  @param delegate    The delegate of the connection. Its callbacks will be called in the same queue
 *                     from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP DELETE unmanaged request.
 */
+( instancetype )unmanagedDelete:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP DELETE unmanaged request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString   The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body          The request body data. This parameter can be nil.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP DELETE unmanaged request.
 */
+( instancetype )unmanagedDelete:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP DELETE unmanaged request.
 *
 *  @param url         The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body        The request body data. This parameter can be nil.
 *
 *  @param headers     HTTP headers that should be added to the request HTTP header dictionary.  In keeping with
 *                     the HTTP RFC, HTTP header field names are case-insensitive. Values are added to header fields
 *                     incrementally. If a value was previously set for the specified field, the supplied value is
 *                     appended to the existing value using the HTTP field delimiter, a comma. Additionally, the
 *                     length of the upload body is determined automatically, then the value of Content-Length is set
 *                     for you. You should not modify the following headers: Authorization, Connection, Host and
 *                     WWW-Authenticate. This parameter can be nil.
 *
 *  @param delegate    The delegate of the connection. Its callbacks will be called in the same queue
 *                     from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP DELETE unmanaged request.
 */
+( instancetype )unmanagedDelete:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP DELETE unmanaged request.
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
 *  @param didStartBlock The block that will be called when the request starts. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param successBlock  The block that will be called if the request succeeds. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param errorBlock    The block that will be called if the request fails. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP DELETE unmanaged request.
 */
+( instancetype )unmanagedDelete:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  @name HTTP POST Syntatic Sugar Methods
 */

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP POST managed request.
 *
 *  @param url      The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param delegate The delegate of the connection. Its callbacks will be called in the same queue
 *                  from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP POST managed request.
 */
+( instancetype )post:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP POST managed request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP POST managed request.
 */
+( instancetype )post:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP POST managed request.
 *
 *  @param url      The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params   The parameters of the request which are sent in its body. All keys and
 *                  values will be escaped. This parameter can be nil.
 *
 *  @param delegate The delegate of the connection. Its callbacks will be called in the same queue
 *                  from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP POST managed request.
 */
+( instancetype )post:( NSString * )url params:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP POST managed request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params        The parameters of the request which are sent in its body. All keys and
 *                       values will be escaped. This parameter can be nil.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP POST managed request.
 */
+( instancetype )post:( NSString * )url params:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP POST managed request.
 *
 *  @param url         The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body        The request body data. This parameter can be nil.
 *
 *  @param delegate    The delegate of the connection. Its callbacks will be called in the same queue
 *                     from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP POST managed request.
 */
+( instancetype )post:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP POST managed request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString   The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body          The request body data. This parameter can be nil.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP POST managed request.
 */
+( instancetype )post:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP POST managed request.
 *
 *  @param url         The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body        The request body data. This parameter can be nil.
 *
 *  @param headers     HTTP headers that should be added to the request HTTP header dictionary.  In keeping with
 *                     the HTTP RFC, HTTP header field names are case-insensitive. Values are added to header fields
 *                     incrementally. If a value was previously set for the specified field, the supplied value is
 *                     appended to the existing value using the HTTP field delimiter, a comma. Additionally, the
 *                     length of the upload body is determined automatically, then the value of Content-Length is set
 *                     for you. You should not modify the following headers: Authorization, Connection, Host and
 *                     WWW-Authenticate. This parameter can be nil.
 *
 *  @param delegate    The delegate of the connection. Its callbacks will be called in the same queue
 *                     from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP POST managed request.
 */
+( instancetype )post:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;

/*
 *  Returns a new TNTHttpConnection with an already configured and started HTTP POST managed request.
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
 *  @param didStartBlock The block that will be called when the request starts. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param successBlock  The block that will be called if the request succeeds. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param errorBlock    The block that will be called if the request fails. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP POST managed request.
 */
+( instancetype )post:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP POST unmanaged request.
 *
 *  @param url      The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param delegate The delegate of the connection. Its callbacks will be called in the same queue
 *                  from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP POST unmanaged request.
 */
+( instancetype )unmanagedPost:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP POST unmanaged request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP POST unmanaged request.
 */
+( instancetype )unmanagedPost:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP POST unmanaged request.
 *
 *  @param url      The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params   The parameters of the request which are sent in its body. All keys and
 *                  values will be escaped. This parameter can be nil.
 *
 *  @param delegate The delegate of the connection. Its callbacks will be called in the same queue
 *                  from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP POST unmanaged request.
 */
+( instancetype )unmanagedPost:( NSString * )url params:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP POST unmanaged request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params        The parameters of the request which are sent in its body. All keys and
 *                       values will be escaped. This parameter can be nil.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP POST unmanaged request.
 */
+( instancetype )unmanagedPost:( NSString * )url params:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP POST unmanaged request.
 *
 *  @param url         The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body        The request body data. This parameter can be nil.
 *
 *  @param delegate    The delegate of the connection. Its callbacks will be called in the same queue
 *                     from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP POST unmanaged request.
 */
+( instancetype )unmanagedPost:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP POST unmanaged request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString   The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body          The request body data. This parameter can be nil.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP POST unmanaged request.
 */
+( instancetype )unmanagedPost:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP POST unmanaged request.
 *
 *  @param url         The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body        The request body data. This parameter can be nil.
 *
 *  @param headers     HTTP headers that should be added to the request HTTP header dictionary.  In keeping with
 *                     the HTTP RFC, HTTP header field names are case-insensitive. Values are added to header fields
 *                     incrementally. If a value was previously set for the specified field, the supplied value is
 *                     appended to the existing value using the HTTP field delimiter, a comma. Additionally, the
 *                     length of the upload body is determined automatically, then the value of Content-Length is set
 *                     for you. You should not modify the following headers: Authorization, Connection, Host and
 *                     WWW-Authenticate. This parameter can be nil.
 *
 *  @param delegate    The delegate of the connection. Its callbacks will be called in the same queue
 *                     from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP POST unmanaged request.
 */
+( instancetype )unmanagedPost:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP POST unmanaged request.
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
 *  @param didStartBlock The block that will be called when the request starts. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param successBlock  The block that will be called if the request succeeds. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param errorBlock    The block that will be called if the request fails. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP POST unmanaged request.
 */
+( instancetype )unmanagedPost:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  @name HTTP PUT Syntatic Sugar Methods
 */

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PUT managed request.
 *
 *  @param url      The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param delegate The delegate of the connection. Its callbacks will be called in the same queue
 *                  from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP PUT managed request.
 */
+( instancetype )put:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PUT managed request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP PUT managed request.
 */
+( instancetype )put:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PUT managed request.
 *
 *  @param url      The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params   The parameters of the request which are sent in its body. All keys and
 *                  values will be escaped. This parameter can be nil.
 *
 *  @param delegate The delegate of the connection. Its callbacks will be called in the same queue
 *                  from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP PUT managed request.
 */
+( instancetype )put:( NSString * )url params:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PUT managed request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params        The parameters of the request which are sent in its body. All keys and
 *                       values will be escaped. This parameter can be nil.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP PUT managed request.
 */
+( instancetype )put:( NSString * )url params:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PUT managed request.
 *
 *  @param url         The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body        The request body data. This parameter can be nil.
 *
 *  @param delegate    The delegate of the connection. Its callbacks will be called in the same queue
 *                     from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP PUT managed request.
 */
+( instancetype )put:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PUT managed request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString   The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body          The request body data. This parameter can be nil.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP PUT managed request.
 */
+( instancetype )put:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PUT managed request.
 *
 *  @param url         The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body        The request body data. This parameter can be nil.
 *
 *  @param headers     HTTP headers that should be added to the request HTTP header dictionary.  In keeping with
 *                     the HTTP RFC, HTTP header field names are case-insensitive. Values are added to header fields
 *                     incrementally. If a value was previously set for the specified field, the supplied value is
 *                     appended to the existing value using the HTTP field delimiter, a comma. Additionally, the
 *                     length of the upload body is determined automatically, then the value of Content-Length is set
 *                     for you. You should not modify the following headers: Authorization, Connection, Host and
 *                     WWW-Authenticate. This parameter can be nil.
 *
 *  @param delegate    The delegate of the connection. Its callbacks will be called in the same queue
 *                     from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP PUT managed request.
 */
+( instancetype )put:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;

/*
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PUT managed request.
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
 *  @param didStartBlock The block that will be called when the request starts. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param successBlock  The block that will be called if the request succeeds. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param errorBlock    The block that will be called if the request fails. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP PUT managed request.
 */
+( instancetype )put:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PUT unmanaged request.
 *
 *  @param url      The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param delegate The delegate of the connection. Its callbacks will be called in the same queue
 *                  from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP PUT unmanaged request.
 */
+( instancetype )unmanagedPut:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PUT unmanaged request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP PUT unmanaged request.
 */
+( instancetype )unmanagedPut:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PUT unmanaged request.
 *
 *  @param url      The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params   The parameters of the request which are sent in its body. All keys and
 *                  values will be escaped. This parameter can be nil.
 *
 *  @param delegate The delegate of the connection. Its callbacks will be called in the same queue
 *                  from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP PUT unmanaged request.
 */
+( instancetype )unmanagedPut:( NSString * )url params:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PUT unmanaged request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params        The parameters of the request which are sent in its body. All keys and
 *                       values will be escaped. This parameter can be nil.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP PUT unmanaged request.
 */
+( instancetype )unmanagedPut:( NSString * )url params:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PUT unmanaged request.
 *
 *  @param url         The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body        The request body data. This parameter can be nil.
 *
 *  @param delegate    The delegate of the connection. Its callbacks will be called in the same queue
 *                     from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP PUT unmanaged request.
 */
+( instancetype )unmanagedPut:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PUT unmanaged request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString   The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body          The request body data. This parameter can be nil.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP PUT unmanaged request.
 */
+( instancetype )unmanagedPut:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PUT unmanaged request.
 *
 *  @param url         The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body        The request body data. This parameter can be nil.
 *
 *  @param headers     HTTP headers that should be added to the request HTTP header dictionary.  In keeping with
 *                     the HTTP RFC, HTTP header field names are case-insensitive. Values are added to header fields
 *                     incrementally. If a value was previously set for the specified field, the supplied value is
 *                     appended to the existing value using the HTTP field delimiter, a comma. Additionally, the
 *                     length of the upload body is determined automatically, then the value of Content-Length is set
 *                     for you. You should not modify the following headers: Authorization, Connection, Host and
 *                     WWW-Authenticate. This parameter can be nil.
 *
 *  @param delegate    The delegate of the connection. Its callbacks will be called in the same queue
 *                     from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP PUT unmanaged request.
 */
+( instancetype )unmanagedPut:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PUT unmanaged request.
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
 *  @param didStartBlock The block that will be called when the request starts. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param successBlock  The block that will be called if the request succeeds. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param errorBlock    The block that will be called if the request fails. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP PUT unmanaged request.
 */
+( instancetype )unmanagedPut:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  @name HTTP PATCH Syntatic Sugar Methods
 */

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PATCH managed request.
 *
 *  @param url      The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param delegate The delegate of the connection. Its callbacks will be called in the same queue
 *                  from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP PATCH managed request.
 */
+( instancetype )patch:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PATCH managed request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP PATCH managed request.
 */
+( instancetype )patch:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PATCH managed request.
 *
 *  @param url      The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params   The parameters of the request which are sent in its body. All keys and
 *                  values will be escaped. This parameter can be nil.
 *
 *  @param delegate The delegate of the connection. Its callbacks will be called in the same queue
 *                  from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP PATCH managed request.
 */
+( instancetype )patch:( NSString * )url params:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PATCH managed request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params        The parameters of the request which are sent in its body. All keys and
 *                       values will be escaped. This parameter can be nil.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP PATCH managed request.
 */
+( instancetype )patch:( NSString * )url params:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PATCH managed request.
 *
 *  @param url         The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body        The request body data. This parameter can be nil.
 *
 *  @param delegate    The delegate of the connection. Its callbacks will be called in the same queue
 *                     from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP PATCH managed request.
 */
+( instancetype )patch:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PATCH managed request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString   The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body          The request body data. This parameter can be nil.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP PATCH managed request.
 */
+( instancetype )patch:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PATCH managed request.
 *
 *  @param url         The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body        The request body data. This parameter can be nil.
 *
 *  @param headers     HTTP headers that should be added to the request HTTP header dictionary.  In keeping with
 *                     the HTTP RFC, HTTP header field names are case-insensitive. Values are added to header fields
 *                     incrementally. If a value was previously set for the specified field, the supplied value is
 *                     appended to the existing value using the HTTP field delimiter, a comma. Additionally, the
 *                     length of the upload body is determined automatically, then the value of Content-Length is set
 *                     for you. You should not modify the following headers: Authorization, Connection, Host and
 *                     WWW-Authenticate. This parameter can be nil.
 *
 *  @param delegate    The delegate of the connection. Its callbacks will be called in the same queue
 *                     from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP PATCH managed request.
 */
+( instancetype )patch:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;

/*
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PATCH managed request.
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
 *  @param didStartBlock The block that will be called when the request starts. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param successBlock  The block that will be called if the request succeeds. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param errorBlock    The block that will be called if the request fails. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP PATCH managed request.
 */
+( instancetype )patch:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PATCH unmanaged request.
 *
 *  @param url      The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param delegate The delegate of the connection. Its callbacks will be called in the same queue
 *                  from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP PATCH unmanaged request.
 */
+( instancetype )unmanagedPatch:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PATCH unmanaged request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP PATCH unmanaged request.
 */
+( instancetype )unmanagedPatch:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PATCH unmanaged request.
 *
 *  @param url      The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params   The parameters of the request which are sent in its body. All keys and
 *                  values will be escaped. This parameter can be nil.
 *
 *  @param delegate The delegate of the connection. Its callbacks will be called in the same queue
 *                  from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP PATCH unmanaged request.
 */
+( instancetype )unmanagedPatch:( NSString * )url params:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PATCH unmanaged request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param params        The parameters of the request which are sent in its body. All keys and
 *                       values will be escaped. This parameter can be nil.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP PATCH unmanaged request.
 */
+( instancetype )unmanagedPatch:( NSString * )url params:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PATCH unmanaged request.
 *
 *  @param url         The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body        The request body data. This parameter can be nil.
 *
 *  @param delegate    The delegate of the connection. Its callbacks will be called in the same queue
 *                     from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP PATCH unmanaged request.
 */
+( instancetype )unmanagedPatch:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PATCH unmanaged request.
 *
 *  @param url           The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString   The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body          The request body data. This parameter can be nil.
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
 *  @return A new TNTHttpConnection with an already configured and started HTTP PATCH unmanaged request.
 */
+( instancetype )unmanagedPatch:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PATCH unmanaged request.
 *
 *  @param url         The URL of the request. If this parameter is nil, this method does nothing.
 *
 *  @param queryString The request query string. All keys and values will be escaped. This parameter can be nil.
 *
 *  @param body        The request body data. This parameter can be nil.
 *
 *  @param headers     HTTP headers that should be added to the request HTTP header dictionary.  In keeping with
 *                     the HTTP RFC, HTTP header field names are case-insensitive. Values are added to header fields
 *                     incrementally. If a value was previously set for the specified field, the supplied value is
 *                     appended to the existing value using the HTTP field delimiter, a comma. Additionally, the
 *                     length of the upload body is determined automatically, then the value of Content-Length is set
 *                     for you. You should not modify the following headers: Authorization, Connection, Host and
 *                     WWW-Authenticate. This parameter can be nil.
 *
 *  @param delegate    The delegate of the connection. Its callbacks will be called in the same queue
 *                     from which this method was called. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP PATCH unmanaged request.
 */
+( instancetype )unmanagedPatch:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;

/**
 *  Returns a new TNTHttpConnection with an already configured and started HTTP PATCH unmanaged request.
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
 *  @param didStartBlock The block that will be called when the request starts. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param successBlock  The block that will be called if the request succeeds. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @param errorBlock    The block that will be called if the request fails. The block will be called in the same queue
 *                       from which the request was started. This parameter can be nil.
 *
 *  @return A new TNTHttpConnection with an already configured and started HTTP PATCH unmanaged request.
 */
+( instancetype )unmanagedPatch:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;

@end
