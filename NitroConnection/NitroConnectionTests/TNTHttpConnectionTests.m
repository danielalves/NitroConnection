//
//  TNTHttpConnectionTests.m
//  NitroConnectionTests
//
//  Created by Daniel L. Alves on 30/07/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import "TNTTestCase.h"

// NitroConnection
#import "NSDictionary+QueryString.h"
#import "TNTHttpConnection.h"
#import "TNTHttpStatusCodes.h"

// NitroConnectionTests
#import "TNTXCTTestMacros.h"

// Pods
#import <OHHTTPStubs/OHHTTPStubs.h>

#pragma mark - Constants

static NSString * const NitroConnectionTestsStubURL = @"http://success.nitroconnection.com";
static NSString * const NitroConnectionTestsStubErrorURL = @"http://error.nitroconnection.com";

#pragma mark - Statics

static NSURLRequestCachePolicy cachePolicyDifferentFromDefault;
static NSURLRequestCachePolicy originalCachePolicy;

static NSTimeInterval timeoutIntervalDifferentFromDefault;
static NSTimeInterval originalTimeoutInterval;

#pragma mark - TNTHttpConnectionTests Interface

@interface TNTHttpConnectionTests : TNTTestCase< TNTHttpConnectionDelegate >
{
    TNTHttpConnection *connection;
    
    NSArray *httpMethods;
    NSMutableURLRequest *errorRequest;
    NSMutableURLRequest *successRequest;
    
    BOOL delegateDidStartCalled;
    BOOL delegateOnSuccessCalled;
    BOOL delegateOnErrorCalled;
    
    BOOL didStartBlockRan;
    BOOL onSuccessBlockRan;
    BOOL onErrorBlockRan;
}
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

-( void )setUp
{
    httpMethods = @[ @( TNTHttpMethodGet ),
                     @( TNTHttpMethodPost ),
                     @( TNTHttpMethodDelete ),
                     @( TNTHttpMethodPut ),
                     @( TNTHttpMethodPatch ),
                     @( TNTHttpMethodHead ) ];
    
    errorRequest = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: NitroConnectionTestsStubErrorURL]];
    successRequest = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: NitroConnectionTestsStubURL]];
    
    [OHHTTPStubs stubRequestsPassingTest: ^BOOL( NSURLRequest *request ) {
        return [request.URL.absoluteString isEqualToString: NitroConnectionTestsStubURL];
    }
                        withStubResponse: ^OHHTTPStubsResponse* ( NSURLRequest *request ) {
                            
                            return [OHHTTPStubsResponse responseWithData: [@"ok" dataUsingEncoding: NSUTF8StringEncoding]
                                                              statusCode: TNTHttpStatusCodeOk
                                                                 headers: @{ @"Content-Type": @"text/json" }];
                        }];
    
    [OHHTTPStubs stubRequestsPassingTest: ^BOOL( NSURLRequest *request ) {
        return [request.URL.absoluteString isEqualToString: NitroConnectionTestsStubErrorURL];
    }
                        withStubResponse: ^OHHTTPStubsResponse* ( NSURLRequest *request ) {
                            return [OHHTTPStubsResponse responseWithError: [NSError errorWithDomain: TNTHttpConnectionErrorDomain
                                                                                               code: TNTHttpConnectionErrorCodeHttpError
                                                                                           userInfo: nil]];
                        }];
}

-( void )tearDown
{
    [TNTHttpConnection setDefaultCachePolicy: originalCachePolicy];
    [TNTHttpConnection setDefaultTimeoutInterval: originalTimeoutInterval];
    
    [OHHTTPStubs removeAllStubs];
}

#pragma mark - Cases

-( void )test_managed_requests_are_not_deallocated_when_scope_is_left
{
    __weak TNTHttpConnection *weakConnection;

    for( NSNumber *boxedHttpMethod in httpMethods )
    {
        TNTHttpMethod currentMethod = [boxedHttpMethod unsignedIntegerValue];
        
        [successRequest setHTTPMethod: [NSString stringFromHttpMethod: currentMethod]];
        
        @autoreleasepool
        {
            TNTHttpConnection *temp = [TNTHttpConnection new];
            [temp startRequest: successRequest managed: YES];
            weakConnection = temp;
        };
        XCTAssertNotNil( weakConnection );
        
        @autoreleasepool
        {
            TNTHttpConnection *temp = [TNTHttpConnection new];
            [temp startRequest: successRequest managed: YES onDidStart: nil onSuccess: nil onError: nil];
            weakConnection = temp;
        };
        XCTAssertNotNil( weakConnection );
        
        @autoreleasepool
        {
            TNTHttpConnection *temp = [TNTHttpConnection new];
            [temp startRequestWithMethod: currentMethod url: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil managed: YES];
            weakConnection = temp;
        };
        XCTAssertNotNil( weakConnection );
        
        @autoreleasepool
        {
            TNTHttpConnection *temp = [TNTHttpConnection new];
            [temp startRequestWithMethod: currentMethod url: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil managed: YES onDidStart: nil onSuccess: nil onError: nil];
            weakConnection = temp;
        };
        XCTAssertNotNil( weakConnection );
    }
}

-( void )test_unmanaged_requests_are_deallocated_when_scope_is_left
{
    __weak TNTHttpConnection *weakConnection;

    for( NSNumber *boxedHttpMethod in httpMethods )
    {
        TNTHttpMethod currentMethod = [boxedHttpMethod unsignedIntegerValue];
        
        [successRequest setHTTPMethod: [NSString stringFromHttpMethod: currentMethod]];
        
        @autoreleasepool
        {
            TNTHttpConnection *temp = [TNTHttpConnection new];
            [temp startRequest: successRequest managed: NO];
            weakConnection = temp;
        };
        XCTAssertNil( weakConnection );
        
        @autoreleasepool
        {
            TNTHttpConnection *temp = [TNTHttpConnection new];
            [temp startRequest: successRequest managed: NO onDidStart: nil onSuccess: nil onError: nil];
            weakConnection = temp;
        };
        XCTAssertNil( weakConnection );
        
        @autoreleasepool
        {
            TNTHttpConnection *temp = [TNTHttpConnection new];
            [temp startRequestWithMethod: currentMethod url: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil managed: NO];
            weakConnection = temp;
        };
        XCTAssertNil( weakConnection );
        
        @autoreleasepool
        {
            TNTHttpConnection *temp = [TNTHttpConnection new];
            [temp startRequestWithMethod: currentMethod url: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil managed: NO onDidStart: nil onSuccess: nil onError: nil];
            weakConnection = temp;
        };
        XCTAssertNil( weakConnection );
    }
}

-( void )test_requests_use_correct_http_method
{
    BOOL managed = NO;
    do
    {
        for( NSNumber *boxedHttpMethod in httpMethods )
        {
            TNTHttpMethod currentMethod = [boxedHttpMethod unsignedIntegerValue];
            
            [successRequest setHTTPMethod: [NSString stringFromHttpMethod: currentMethod]];

            TNTHttpConnection *temp = [TNTHttpConnection new];
            [temp startRequest: successRequest managed: managed];
            XCTAssertRequestHttpMethod( temp.lastRequest, currentMethod );
            
            temp = [TNTHttpConnection new];
            [temp startRequest: successRequest managed: managed onDidStart: nil onSuccess: nil onError: nil];
            XCTAssertRequestHttpMethod( temp.lastRequest, currentMethod );
            
            temp = [TNTHttpConnection new];
            [temp startRequestWithMethod: currentMethod url: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil managed: managed];
            XCTAssertRequestHttpMethod( temp.lastRequest, currentMethod );
            
            temp = [TNTHttpConnection new];
            [temp startRequestWithMethod: currentMethod url: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil managed: managed onDidStart: nil onSuccess: nil onError: nil];
            XCTAssertRequestHttpMethod( temp.lastRequest, currentMethod );
        }
        managed = !managed;
    }
    while( managed );
}

-( void )test_requests_send_headers
{
    NSDictionary *headers = @{ @"name": @"colossus", @"mutant-power": @"iron skin, super strength" };
    
    BOOL managed = NO;
    do
    {
        for( NSNumber *boxedHttpMethod in httpMethods )
        {
            TNTHttpMethod currentMethod = [boxedHttpMethod unsignedIntegerValue];
            
            [successRequest setHTTPMethod: [NSString stringFromHttpMethod: currentMethod]];

            TNTHttpConnection *temp = [TNTHttpConnection new];
            [temp startRequestWithMethod: currentMethod url: NitroConnectionTestsStubURL queryString: nil body: nil headers: headers managed: managed];
            XCTAssertRequestHeaders( temp.lastRequest, headers );
            
            temp = [TNTHttpConnection new];
            [temp startRequestWithMethod: currentMethod url: NitroConnectionTestsStubURL queryString: nil body: nil headers: headers managed: managed onDidStart: nil onSuccess: nil onError: nil];
            XCTAssertRequestHeaders( temp.lastRequest, headers );
        }
        managed = !managed;
    }
    while( managed );
}

-( void )test_requests_append_query_string
{
    NSDictionary *queryString = @{ @"name": @"rogue", @"mutant-power": @"steal other powers and memories" };

    BOOL managed = NO;
    do
    {
        for( NSNumber *boxedHttpMethod in httpMethods )
        {
            TNTHttpMethod currentMethod = [boxedHttpMethod unsignedIntegerValue];
            
            [successRequest setHTTPMethod: [NSString stringFromHttpMethod: currentMethod]];
            
            TNTHttpConnection *temp = [TNTHttpConnection new];
            [temp startRequestWithMethod: currentMethod url: NitroConnectionTestsStubURL queryString: queryString body: nil headers: nil managed: managed];
            XCTAssertRequestQueryString( temp.lastRequest, queryString );
            
            temp = [TNTHttpConnection new];
            [temp startRequestWithMethod: currentMethod url: NitroConnectionTestsStubURL queryString: queryString body: nil headers: nil managed: managed onDidStart: nil onSuccess: nil onError: nil];
            XCTAssertRequestQueryString( temp.lastRequest, queryString );
        }
        managed = !managed;
    }
    while( managed );
}

-( void )test_requests_send_body
{
    NSDictionary *bodyParams = @{ @"name": @"ice man", @"mutant-power": @"generate ice" };
    NSString *formattedParams = [bodyParams toQueryString];
    NSData *bodyData = [formattedParams dataUsingEncoding: NSUTF8StringEncoding];

    BOOL managed = NO;
    do
    {
        for( NSNumber *boxedHttpMethod in httpMethods )
        {
            TNTHttpMethod currentMethod = [boxedHttpMethod unsignedIntegerValue];
            
            [successRequest setHTTPMethod: [NSString stringFromHttpMethod: currentMethod]];
            
            TNTHttpConnection *temp = [TNTHttpConnection new];
            [temp startRequestWithMethod: currentMethod url: NitroConnectionTestsStubURL queryString: nil body: bodyData headers: nil managed: managed];
            XCTAssertRequestBody( temp.lastRequest, bodyParams );
            
            temp = [TNTHttpConnection new];
            [temp startRequestWithMethod: currentMethod url: NitroConnectionTestsStubURL queryString: nil body: bodyData headers: nil managed: managed onDidStart: nil onSuccess: nil onError: nil];
            XCTAssertRequestBody( temp.lastRequest, bodyParams );
        }
        managed = !managed;
    }
    while( managed );
}

-( void )test_calls_delegate_on_start
{
    connection = [TNTHttpConnection new];
    connection.delegate = self;
    
    BOOL managed = NO;
    do
    {
        for( NSNumber *boxedHttpMethod in httpMethods )
        {
            TNTHttpMethod currentMethod = [boxedHttpMethod unsignedIntegerValue];
            [successRequest setHTTPMethod: [NSString stringFromHttpMethod: currentMethod]];
            
            [self waitForAsyncCode: ^{
                [connection startRequest: successRequest managed: managed];
            }];
            
            XCTAssertTrue( delegateDidStartCalled );
            delegateDidStartCalled = NO;

            [self waitForAsyncCode: ^{
                [connection startRequestWithMethod: currentMethod url: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil managed: managed];
            }];
            
            XCTAssertTrue( delegateDidStartCalled );
            delegateDidStartCalled = NO;
        }
        managed = !managed;
    }
    while( managed );
}

-( void )test_calls_delegate_on_success
{
    connection = [TNTHttpConnection new];
    connection.delegate = self;
    
    BOOL managed = NO;
    do
    {
        for( NSNumber *boxedHttpMethod in httpMethods )
        {
            TNTHttpMethod currentMethod = [boxedHttpMethod unsignedIntegerValue];
            [successRequest setHTTPMethod: [NSString stringFromHttpMethod: currentMethod]];
            
            [self waitForAsyncCode: ^{
                [connection startRequest: successRequest managed: managed];
            }];
            
            XCTAssertTrue( delegateOnSuccessCalled );
            delegateOnSuccessCalled = NO;
            
            [self waitForAsyncCode: ^{
                [connection startRequestWithMethod: currentMethod url: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil managed: managed];
            }];
            
            XCTAssertTrue( delegateOnSuccessCalled );
            delegateOnSuccessCalled = NO;
        }
        managed = !managed;
    }
    while( managed );
}

-( void )test_calls_delegate_on_error
{
    connection = [TNTHttpConnection new];
    connection.delegate = self;
    
    BOOL managed = NO;
    do
    {
        for( NSNumber *boxedHttpMethod in httpMethods )
        {
            TNTHttpMethod currentMethod = [boxedHttpMethod unsignedIntegerValue];
            [errorRequest setHTTPMethod: [NSString stringFromHttpMethod: currentMethod]];
            
            [self waitForAsyncCode: ^{
                [connection startRequest: errorRequest managed: managed];
            }];
            
            XCTAssertTrue( delegateOnErrorCalled );
            delegateOnErrorCalled = NO;
            
            [self waitForAsyncCode: ^{
                [connection startRequestWithMethod: currentMethod url: NitroConnectionTestsStubErrorURL queryString: nil body: nil headers: nil managed: managed];
            }];
            
            XCTAssertTrue( delegateOnErrorCalled );
            delegateOnErrorCalled = NO;
        }
        managed = !managed;
    }
    while( managed );
}

-( void )test_calls_did_start_block_on_start
{
    connection = [TNTHttpConnection new];
    connection.delegate = self;
    
    BOOL managed = NO;
    do
    {
        for( NSNumber *boxedHttpMethod in httpMethods )
        {
            TNTHttpMethod currentMethod = [boxedHttpMethod unsignedIntegerValue];
            [successRequest setHTTPMethod: [NSString stringFromHttpMethod: currentMethod]];
            
            [self waitForAsyncCode: ^{
                [connection startRequest: successRequest
                                 managed: managed
                              onDidStart: ^( TNTHttpConnection *conn ){
                                  didStartBlockRan = YES;
                                  [self finishedAsyncOperation];
                               }
                               onSuccess: nil
                                 onError: nil];
            }];
            
            XCTAssertTrue( didStartBlockRan );
            didStartBlockRan = NO;
            
            [self waitForAsyncCode: ^{
                [connection startRequestWithMethod: currentMethod
                                               url: NitroConnectionTestsStubURL
                                       queryString: nil
                                              body: nil
                                           headers: nil
                                           managed: managed
                                        onDidStart: ^( TNTHttpConnection *conn ){
                                            didStartBlockRan = YES;
                                            [self finishedAsyncOperation];
                                         }
                                         onSuccess: nil
                                           onError: nil];
            }];
            
            XCTAssertTrue( didStartBlockRan );
            didStartBlockRan = NO;
        }
        managed = !managed;
    }
    while( managed );
}

-( void )test_calls_success_block_on_success
{
    connection = [TNTHttpConnection new];
    connection.delegate = self;
    
    BOOL managed = NO;
    do
    {
        for( NSNumber *boxedHttpMethod in httpMethods )
        {
            TNTHttpMethod currentMethod = [boxedHttpMethod unsignedIntegerValue];
            [successRequest setHTTPMethod: [NSString stringFromHttpMethod: currentMethod]];
            
            [self waitForAsyncCode: ^{
                [connection startRequest: successRequest
                                 managed: managed
                              onDidStart: nil
                               onSuccess: ^( TNTHttpConnection *conn, NSHTTPURLResponse *response, NSData *data ) {
                                   onSuccessBlockRan = YES;
                                   [self finishedAsyncOperation];
                                 }
                                 onError: nil];
            }];
            
            XCTAssertTrue( onSuccessBlockRan );
            onSuccessBlockRan = NO;
            
            [self waitForAsyncCode: ^{
                [connection startRequestWithMethod: currentMethod
                                               url: NitroConnectionTestsStubURL
                                       queryString: nil
                                              body: nil
                                           headers: nil
                                           managed: managed
                                        onDidStart: nil
                                         onSuccess: ^( TNTHttpConnection *conn, NSHTTPURLResponse *response, NSData *data ) {
                                             onSuccessBlockRan = YES;
                                             [self finishedAsyncOperation];
                                           }
                                           onError: nil];
            }];
            
            XCTAssertTrue( onSuccessBlockRan );
            onSuccessBlockRan = NO;
        }
        managed = !managed;
    }
    while( managed );
}

-( void )test_calls_error_block_on_error
{
    connection = [TNTHttpConnection new];
    connection.delegate = self;
    
    BOOL managed = NO;
    do
    {
        for( NSNumber *boxedHttpMethod in httpMethods )
        {
            TNTHttpMethod currentMethod = [boxedHttpMethod unsignedIntegerValue];
            [errorRequest setHTTPMethod: [NSString stringFromHttpMethod: currentMethod]];
            
            [self waitForAsyncCode: ^{
                [connection startRequest: errorRequest
                                 managed: managed
                              onDidStart: nil
                               onSuccess: nil
                                 onError: ^( TNTHttpConnection *conn, NSError *error ) {
                                     onErrorBlockRan = YES;
                                     [self finishedAsyncOperation];
                                 }];
            }];
            
            XCTAssertTrue( onErrorBlockRan );
            onErrorBlockRan = NO;
            
            [self waitForAsyncCode: ^{
                [connection startRequestWithMethod: currentMethod
                                               url: NitroConnectionTestsStubErrorURL
                                       queryString: nil
                                              body: nil
                                           headers: nil
                                           managed: managed
                                        onDidStart: nil
                                         onSuccess: nil
                                           onError: ^( TNTHttpConnection *conn, NSError *error ) {
                                               onErrorBlockRan = YES;
                                               [self finishedAsyncOperation];
                                           }];
            }];
            
            XCTAssertTrue( onErrorBlockRan );
            onErrorBlockRan = NO;
        }
        managed = !managed;
    }
    while( managed );
}

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

#pragma mark - TNTHttpConnectionDelegate

-( void )onTNTHttpConnectionDidStart:( TNTHttpConnection * )connection
{
    delegateDidStartCalled = YES;
}

-( void )onTNTHttpConnection:( TNTHttpConnection * )connection didReceiveResponse:( NSHTTPURLResponse * )response withData:( NSData * )data
{
    delegateOnSuccessCalled = YES;
    [self finishedAsyncOperation];
}

-( void )onTNTHttpConnection:( TNTHttpConnection * )connection didFailWithError:( NSError * )error
{
    delegateOnErrorCalled = YES;
    [self finishedAsyncOperation];
}

@end
