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

typedef void ( ^TNTHttpConnectionDidStartBlock )();
typedef void ( ^TNTHttpConnectionSuccessBlock )( NSHTTPURLResponse *response, NSData *data );
typedef void ( ^TNTHttpConnectionErrorBlock )( NSError *error );

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

/***********************************************************************
 *
 * TNTHttpConnection
 *
 ***********************************************************************/

@interface TNTHttpConnection : NSObject

@property( nonatomic, readwrite, weak )id< TNTHttpConnectionDelegate > delegate;

@property( nonatomic, readonly, assign )BOOL requestAlive;

@property( nonatomic, readonly )NSURLRequest *lastRequest;
@property( nonatomic, readonly )NSHTTPURLResponse *lastResponse;

@property( nonatomic, readwrite, assign )NSTimeInterval timeoutInterval;
@property( nonatomic, readwrite, assign )NSURLRequestCachePolicy cachePolicy;

/**
 *  @name Request management
 */
-( void )startRequest:( NSURLRequest * )request;

-( void )startRequest:( NSURLRequest * )request
           onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock
            onSuccess:( TNTHttpConnectionSuccessBlock )successBlock
              onError:( TNTHttpConnectionErrorBlock )errorBlock;

-( void )startRequestWithMethod:( TNTHttpMethod )httpMethod
                            url:( NSString * )url
                         params:( NSDictionary * )params
                        headers:( NSDictionary * )headers;

-( void )startRequestWithMethod:( TNTHttpMethod )httpMethod
                            url:( NSString * )url
                    queryString:( NSDictionary * )queryString
                           body:( NSData * )body
                        headers:( NSDictionary * )headers
                     onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock
                      onSuccess:( TNTHttpConnectionSuccessBlock )successBlock
                        onError:( TNTHttpConnectionErrorBlock )errorBlock;

-( void )startRequestWithMethod:( TNTHttpMethod )httpMethod
                            url:( NSString * )url
                         params:( NSDictionary * )params
                        headers:( NSDictionary * )headers
                     onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock
                      onSuccess:( TNTHttpConnectionSuccessBlock )successBlock
                        onError:( TNTHttpConnectionErrorBlock )errorBlock;

-( void )retry;

-( void )cancel;

/**
 *  @name Default configurations
 */
+( void )setDefaultCachePolicy:( NSURLRequestCachePolicy )cachePolicy;
+( NSURLRequestCachePolicy )defaultCachePolicy;

+( void )setDefaultTimeoutInterval:( NSTimeInterval )timeoutInterval;
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
