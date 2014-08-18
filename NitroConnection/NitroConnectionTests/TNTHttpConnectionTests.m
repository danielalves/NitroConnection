//
//  TNTHttpConnectionTests.m
//  NitroConnectionTests
//
//  Created by Daniel L. Alves on 30/07/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import <XCTest/XCTest.h>

// NitroConnection
#import "TNTHttpConnection.h"

#pragma mark - Statics

static NSURLRequestCachePolicy cachePolicyDifferentFromDefault;
static NSURLRequestCachePolicy originalCachePolicy;

static NSTimeInterval timeoutIntervalDifferentFromDefault;
static NSTimeInterval originalTimeoutInterval;

#pragma mark - TNTHttpConnectionTests Interface

@interface TNTHttpConnectionTests : XCTestCase

@end

#pragma mark - TNTHttpConnectionTests Implementation

@implementation TNTHttpConnectionTests

#pragma mark - Tests Lifecycle

+( void )setUp
{
    originalCachePolicy = [TNTHttpConnection defaultCachePolicy];
    cachePolicyDifferentFromDefault = originalCachePolicy == NSURLRequestUseProtocolCachePolicy ? NSURLRequestReloadIgnoringCacheData : NSURLRequestUseProtocolCachePolicy;
    
    originalTimeoutInterval = [TNTHttpConnection defaultTimeoutInterval];
    timeoutIntervalDifferentFromDefault = originalTimeoutInterval + 2.0f;
}

-( void )tearDown
{
    [TNTHttpConnection setDefaultCachePolicy: originalCachePolicy];
    [TNTHttpConnection setDefaultTimeoutInterval: originalTimeoutInterval];
}

///**
// *  @name Request management
// */
//-( void )startRequest:( NSURLRequest * )request;
//
//-( void )startRequest:( NSURLRequest * )request
//           onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock
//            onSuccess:( TNTHttpConnectionSuccessBlock )successBlock
//              onError:( TNTHttpConnectionErrorBlock )errorBlock;
//
//-( void )startRequestWithMethod:( TNTHttpMethod )httpMethod
//                            url:( NSString * )url
//                         params:( NSDictionary * )params
//                        headers:( NSDictionary * )headers;
//
//-( void )startRequestWithMethod:( TNTHttpMethod )httpMethod
//                            url:( NSString * )url
//                         params:( NSDictionary * )params
//                        headers:( NSDictionary * )headers
//                     onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock
//                      onSuccess:( TNTHttpConnectionSuccessBlock )successBlock
//                        onError:( TNTHttpConnectionErrorBlock )errorBlock;
//
//-( void )retry;
//
//-( void )cancel;

#pragma mark - Default configurations tests

-( void )test_setDefaultCachePolicy_changes_default_cache_policy
{
    XCTAssertNotEqual( [TNTHttpConnection defaultCachePolicy], cachePolicyDifferentFromDefault );
    
    [TNTHttpConnection setDefaultCachePolicy: cachePolicyDifferentFromDefault];
    
    XCTAssertEqual( [TNTHttpConnection defaultCachePolicy], cachePolicyDifferentFromDefault );
}

-( void )test_setDefaultCachePolicy_affects_new_connections
{
    TNTHttpConnection *conn = [TNTHttpConnection new];
    XCTAssertEqual( conn.cachePolicy, originalCachePolicy );
    
    [TNTHttpConnection setDefaultCachePolicy: cachePolicyDifferentFromDefault];
    
    conn = [TNTHttpConnection new];
    XCTAssertEqual( conn.cachePolicy, cachePolicyDifferentFromDefault );
}

-( void )test_setDefaultTimeoutInterval_changes_default_timeout_interval
{
    XCTAssertNotEqual( [TNTHttpConnection defaultTimeoutInterval], timeoutIntervalDifferentFromDefault );
    
    [TNTHttpConnection setDefaultTimeoutInterval: timeoutIntervalDifferentFromDefault];
    
    XCTAssertEqual( [TNTHttpConnection defaultTimeoutInterval], timeoutIntervalDifferentFromDefault );
}

-( void )test_setDefaultTimeoutInterval_affects_new_connections
{
    TNTHttpConnection *conn = [TNTHttpConnection new];
    XCTAssertEqual( conn.timeoutInterval, originalTimeoutInterval );
    
    [TNTHttpConnection setDefaultTimeoutInterval: timeoutIntervalDifferentFromDefault];
    
    conn = [TNTHttpConnection new];
    XCTAssertEqual( conn.timeoutInterval, timeoutIntervalDifferentFromDefault );
}

@end
