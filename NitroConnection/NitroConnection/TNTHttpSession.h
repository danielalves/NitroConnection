//
//  TNTHttpSession.h
//  NitroConnection
//
//  Created by Daniel L. Alves on 7/8/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import <Foundation/Foundation.h>

// NitroConnection
#import "TNTHttpMethods.h"

/***********************************************************************
 *
 * Helper Types
 *
 ***********************************************************************/

typedef void ( ^TNTHttpSessionDidStartBlock )();
typedef void ( ^TNTHttpSessionCompletionBlock )( NSData *data, NSHTTPURLResponse *response, NSError *error );

/***********************************************************************
 *
 * TNTHttpSessionDelegate
 *
 ***********************************************************************/

@class TNTHttpSession;

@protocol TNTHttpSessionDelegate< NSObject >

    @optional
        -( void )onTNTHttpSessionDidStart:( TNTHttpSession * )session;

        -( void )onTNTHttpSession:( TNTHttpSession * )session didCompleteWithData:( NSData * )data response:( NSHTTPURLResponse * )response error:( NSError * )error;
@end

/***********************************************************************
 *
 * TNTHttpConnection
 *
 ***********************************************************************/

@interface TNTHttpSession : NSObject

@property( nonatomic, readwrite, weak )id< TNTHttpSessionDelegate > delegate;

@property( nonatomic, readonly, assign )BOOL requestAlive;

@property( nonatomic, readonly )NSURLRequest *lastRequest;
@property( nonatomic, readonly )NSHTTPURLResponse *lastResponse;

@property( nonatomic, readwrite, assign )NSTimeInterval timeoutInterval;
@property( nonatomic, readwrite, assign )NSURLRequestCachePolicy cachePolicy;

//
// Request management
//
-( void )startRequest:( NSURLRequest * )request;

-( void )startRequest:( NSURLRequest * )request
           onDidStart:( TNTHttpSessionDidStartBlock )didStartBlock
         onCompletion:( TNTHttpSessionCompletionBlock )completionBlock;

-( void )startRequestWithMethod:( TNTHttpMethod )httpMethod
                            url:( NSString * )url
                         params:( NSDictionary * )params
                        headers:( NSDictionary * )headers;

-( void )startRequestWithMethod:( TNTHttpMethod )httpMethod
                            url:( NSString * )url
                         params:( NSDictionary * )params
                        headers:( NSDictionary * )headers
                     onDidStart:( TNTHttpSessionDidStartBlock )didStartBlock
                   onCompletion:( TNTHttpSessionCompletionBlock )completionBlock;

-( void )retry;

-( void )cancel;

//
// Default configurations
//
+( void )setDefaultCachePolicy:( NSURLRequestCachePolicy )cachePolicy;
+( NSURLRequestCachePolicy )defaultCachePolicy;

+( void )setDefaultTimeoutInterval:( NSTimeInterval )timeoutInterval;
+( NSTimeInterval )defaultTimeoutInterval;

@end
