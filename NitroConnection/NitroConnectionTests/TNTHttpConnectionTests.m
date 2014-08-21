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
            [temp startRequestWithMethod: currentMethod url: NitroConnectionTestsStubURL params: nil headers: nil managed: YES];
            weakConnection = temp;
        };
        XCTAssertNotNil( weakConnection );
        
        @autoreleasepool
        {
            TNTHttpConnection *temp = [TNTHttpConnection new];
            [temp startRequestWithMethod: currentMethod url: NitroConnectionTestsStubURL params: nil headers: nil managed: YES];
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
            [temp startRequestWithMethod: currentMethod url: NitroConnectionTestsStubURL params: nil headers: nil managed: NO];
            weakConnection = temp;
        };
        XCTAssertNil( weakConnection );
        
        @autoreleasepool
        {
            TNTHttpConnection *temp = [TNTHttpConnection new];
            [temp startRequestWithMethod: currentMethod url: NitroConnectionTestsStubURL params: nil headers: nil managed: NO];
            weakConnection = temp;
        };
        XCTAssertNil( weakConnection );
    }
}

-( void )test_requests_use_correct_http_method
{
    for( NSNumber *boxedHttpMethod in httpMethods )
    {
        TNTHttpMethod currentMethod = [boxedHttpMethod unsignedIntegerValue];
        
        [successRequest setHTTPMethod: [NSString stringFromHttpMethod: currentMethod]];

        TNTHttpConnection *temp = [TNTHttpConnection new];
        [temp startRequest: successRequest managed: NO];
        XCTAssertRequestHttpMethod( temp.lastRequest, currentMethod );
        
        temp = [TNTHttpConnection new];
        [temp startRequest: successRequest managed: NO onDidStart: nil onSuccess: nil onError: nil];
        XCTAssertRequestHttpMethod( temp.lastRequest, currentMethod );
        
        temp = [TNTHttpConnection new];
        [temp startRequestWithMethod: currentMethod url: NitroConnectionTestsStubURL params: nil headers: nil managed: NO];
        XCTAssertRequestHttpMethod( temp.lastRequest, currentMethod );
        
        temp = [TNTHttpConnection new];
        [temp startRequestWithMethod: currentMethod url: NitroConnectionTestsStubURL params: nil headers: nil managed: NO];
        XCTAssertRequestHttpMethod( temp.lastRequest, currentMethod );
    }
}

-( void )test_get_requests_pass_params_in_query_string
{
    NSDictionary *params = @{ @"name": @"colossus", @"mutant-power": @"iron skin, super strength" };
    
    [successRequest setHTTPMethod: [NSString stringFromHttpMethod: TNTHttpMethodGet]];

    TNTHttpConnection *temp = [TNTHttpConnection new];
    [temp startRequestWithMethod: TNTHttpMethodGet url: NitroConnectionTestsStubURL params: params headers: nil managed: NO];
    XCTAssertRequestQueryString( temp.lastRequest, params );
    
    temp = [TNTHttpConnection new];
    [temp startRequestWithMethod: TNTHttpMethodGet url: NitroConnectionTestsStubURL params: params headers: nil managed: NO];
    XCTAssertRequestQueryString( temp.lastRequest, params );
}

-( void )test_head_requests_pass_params_in_query_string
{
    NSDictionary *params = @{ @"name": @"colossus", @"mutant-power": @"iron skin, super strength" };
    
    [successRequest setHTTPMethod: [NSString stringFromHttpMethod: TNTHttpMethodHead]];
    
    TNTHttpConnection *temp = [TNTHttpConnection new];
    [temp startRequestWithMethod: TNTHttpMethodHead url: NitroConnectionTestsStubURL params: params headers: nil managed: NO];
    XCTAssertRequestQueryString( temp.lastRequest, params );
    
    temp = [TNTHttpConnection new];
    [temp startRequestWithMethod: TNTHttpMethodHead url: NitroConnectionTestsStubURL params: params headers: nil managed: NO];
    XCTAssertRequestQueryString( temp.lastRequest, params );
}

-( void )test_delete_requests_pass_params_in_query_string
{
    NSDictionary *params = @{ @"name": @"colossus", @"mutant-power": @"iron skin, super strength" };
    
    [successRequest setHTTPMethod: [NSString stringFromHttpMethod: TNTHttpMethodDelete]];

    TNTHttpConnection *temp = [TNTHttpConnection new];
    [temp startRequestWithMethod: TNTHttpMethodDelete url: NitroConnectionTestsStubURL params: params headers: nil managed: NO];
    XCTAssertRequestQueryString( temp.lastRequest, params );
    
    temp = [TNTHttpConnection new];
    [temp startRequestWithMethod: TNTHttpMethodDelete url: NitroConnectionTestsStubURL params: params headers: nil managed: NO];
    XCTAssertRequestQueryString( temp.lastRequest, params );
}

-( void )test_post_requests_pass_params_in_request_body
{
    NSDictionary *params = @{ @"name": @"colossus", @"mutant-power": @"iron skin, super strength" };
    
    [successRequest setHTTPMethod: [NSString stringFromHttpMethod: TNTHttpMethodPost]];

    TNTHttpConnection *temp = [TNTHttpConnection new];
    [temp startRequestWithMethod: TNTHttpMethodPost url: NitroConnectionTestsStubURL params: params headers: nil managed: NO];
    XCTAssertRequestBody( temp.lastRequest, params );
    
    temp = [TNTHttpConnection new];
    [temp startRequestWithMethod: TNTHttpMethodPost url: NitroConnectionTestsStubURL params: params headers: nil managed: NO];
    XCTAssertRequestBody( temp.lastRequest, params );
}

-( void )test_put_requests_pass_params_in_request_body
{
    NSDictionary *params = @{ @"name": @"colossus", @"mutant-power": @"iron skin, super strength" };
    
    [successRequest setHTTPMethod: [NSString stringFromHttpMethod: TNTHttpMethodPut]];

    TNTHttpConnection *temp = [TNTHttpConnection new];
    [temp startRequestWithMethod: TNTHttpMethodPut url: NitroConnectionTestsStubURL params: params headers: nil managed: NO];
    XCTAssertRequestBody( temp.lastRequest, params );
    
    temp = [TNTHttpConnection new];
    [temp startRequestWithMethod: TNTHttpMethodPut url: NitroConnectionTestsStubURL params: params headers: nil managed: NO];
    XCTAssertRequestBody( temp.lastRequest, params );
}

-( void )test_patch_requests_pass_params_in_request_body
{
    NSDictionary *params = @{ @"name": @"colossus", @"mutant-power": @"iron skin, super strength" };
    
    [successRequest setHTTPMethod: [NSString stringFromHttpMethod: TNTHttpMethodPatch]];

    TNTHttpConnection *temp = [TNTHttpConnection new];
    [temp startRequestWithMethod: TNTHttpMethodPatch url: NitroConnectionTestsStubURL params: params headers: nil managed: NO];
    XCTAssertRequestBody( temp.lastRequest, params );
    
    temp = [TNTHttpConnection new];
    [temp startRequestWithMethod: TNTHttpMethodPatch url: NitroConnectionTestsStubURL params: params headers: nil managed: NO];
    XCTAssertRequestBody( temp.lastRequest, params );
}

-( void )test_requests_send_headers
{
    NSDictionary *headers = @{ @"name": @"colossus", @"mutant-power": @"iron skin, super strength" };

    for( NSNumber *boxedHttpMethod in httpMethods )
    {
        TNTHttpMethod currentMethod = [boxedHttpMethod unsignedIntegerValue];
        
        [successRequest setHTTPMethod: [NSString stringFromHttpMethod: currentMethod]];

        TNTHttpConnection *temp = [TNTHttpConnection new];
        [temp startRequestWithMethod: currentMethod url: NitroConnectionTestsStubURL params: nil headers: headers managed: NO];
        XCTAssertRequestHeaders( temp.lastRequest, headers );
        
        temp = [TNTHttpConnection new];
        [temp startRequestWithMethod: currentMethod url: NitroConnectionTestsStubURL params: nil headers: headers managed: NO];
        XCTAssertRequestHeaders( temp.lastRequest, headers );
    }
}

-( void )test_calls_delegate_on_start
{
    connection = [TNTHttpConnection new];
    connection.delegate = self;
    
    for( NSNumber *boxedHttpMethod in httpMethods )
    {
        TNTHttpMethod currentMethod = [boxedHttpMethod unsignedIntegerValue];
        [successRequest setHTTPMethod: [NSString stringFromHttpMethod: currentMethod]];
        
        [self waitForAsyncCode: ^{
            [connection startRequest: successRequest managed: NO];
        }];
        
        XCTAssertTrue( delegateDidStartCalled );
        delegateDidStartCalled = NO;

        [self waitForAsyncCode: ^{
            [connection startRequestWithMethod: currentMethod url: NitroConnectionTestsStubURL params: nil headers: nil managed: NO];
        }];
        
        XCTAssertTrue( delegateDidStartCalled );
        delegateDidStartCalled = NO;
    }
}

-( void )test_calls_delegate_on_success
{
    connection = [TNTHttpConnection new];
    connection.delegate = self;
    
    for( NSNumber *boxedHttpMethod in httpMethods )
    {
        TNTHttpMethod currentMethod = [boxedHttpMethod unsignedIntegerValue];
        [successRequest setHTTPMethod: [NSString stringFromHttpMethod: currentMethod]];
        
        [self waitForAsyncCode: ^{
            [connection startRequest: successRequest managed: NO];
        }];
        
        XCTAssertTrue( delegateOnSuccessCalled );
        delegateOnSuccessCalled = NO;
        
        [self waitForAsyncCode: ^{
            [connection startRequestWithMethod: currentMethod url: NitroConnectionTestsStubURL params: nil headers: nil managed: NO];
        }];
        
        XCTAssertTrue( delegateOnSuccessCalled );
        delegateOnSuccessCalled = NO;
    }
}

-( void )test_calls_delegate_on_error
{
    connection = [TNTHttpConnection new];
    connection.delegate = self;
    
    for( NSNumber *boxedHttpMethod in httpMethods )
    {
        TNTHttpMethod currentMethod = [boxedHttpMethod unsignedIntegerValue];
        [errorRequest setHTTPMethod: [NSString stringFromHttpMethod: currentMethod]];
        
        [self waitForAsyncCode: ^{
            [connection startRequest: errorRequest managed: NO];
        }];
        
        XCTAssertTrue( delegateOnErrorCalled );
        delegateOnErrorCalled = NO;
        
        [self waitForAsyncCode: ^{
            [connection startRequestWithMethod: currentMethod url: NitroConnectionTestsStubErrorURL params: nil headers: nil managed: NO];
        }];
        
        XCTAssertTrue( delegateOnErrorCalled );
        delegateOnErrorCalled = NO;
    }
}

-( void )test_calls_did_start_block_on_start
{
    connection = [TNTHttpConnection new];
    connection.delegate = self;
    
    for( NSNumber *boxedHttpMethod in httpMethods )
    {
        TNTHttpMethod currentMethod = [boxedHttpMethod unsignedIntegerValue];
        [successRequest setHTTPMethod: [NSString stringFromHttpMethod: currentMethod]];
        
        [self waitForAsyncCode: ^{
            [connection startRequest: successRequest
                             managed: NO
                          onDidStart: ^{
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
                                        params: nil
                                       headers: nil
                                       managed: NO
                                    onDidStart: ^{
                                        didStartBlockRan = YES;
                                        [self finishedAsyncOperation];
                                     }
                                     onSuccess: nil
                                       onError: nil];
        }];
        
        XCTAssertTrue( didStartBlockRan );
        didStartBlockRan = NO;
    }
}

-( void )test_calls_success_block_on_success
{
    connection = [TNTHttpConnection new];
    connection.delegate = self;
    
    for( NSNumber *boxedHttpMethod in httpMethods )
    {
        TNTHttpMethod currentMethod = [boxedHttpMethod unsignedIntegerValue];
        [successRequest setHTTPMethod: [NSString stringFromHttpMethod: currentMethod]];
        
        [self waitForAsyncCode: ^{
            [connection startRequest: successRequest
                             managed: NO
                          onDidStart: nil
                           onSuccess: ^( NSHTTPURLResponse *response, NSData *data ) {
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
                                        params: nil
                                       headers: nil
                                       managed: NO
                                    onDidStart: nil
                                     onSuccess: ^( NSHTTPURLResponse *response, NSData *data ) {
                                         onSuccessBlockRan = YES;
                                         [self finishedAsyncOperation];
                                       }
                                       onError: nil];
        }];
        
        XCTAssertTrue( onSuccessBlockRan );
        onSuccessBlockRan = NO;
    }
}

-( void )test_calls_error_block_on_error
{
    connection = [TNTHttpConnection new];
    connection.delegate = self;
    
    for( NSNumber *boxedHttpMethod in httpMethods )
    {
        TNTHttpMethod currentMethod = [boxedHttpMethod unsignedIntegerValue];
        [errorRequest setHTTPMethod: [NSString stringFromHttpMethod: currentMethod]];
        
        [self waitForAsyncCode: ^{
            [connection startRequest: errorRequest
                             managed: NO
                          onDidStart: nil
                           onSuccess: nil
                             onError: ^( NSError *error ) {
                                 onErrorBlockRan = YES;
                                 [self finishedAsyncOperation];
                             }];
        }];
        
        XCTAssertTrue( onErrorBlockRan );
        onErrorBlockRan = NO;
        
        [self waitForAsyncCode: ^{
            [connection startRequestWithMethod: currentMethod
                                           url: NitroConnectionTestsStubErrorURL
                                        params: nil
                                       headers: nil
                                       managed: NO
                                    onDidStart: nil
                                     onSuccess: nil
                                       onError: ^( NSError *error ) {
                                           onErrorBlockRan = YES;
                                           [self finishedAsyncOperation];
                                       }];
        }];
        
        XCTAssertTrue( onErrorBlockRan );
        onErrorBlockRan = NO;
    }
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
