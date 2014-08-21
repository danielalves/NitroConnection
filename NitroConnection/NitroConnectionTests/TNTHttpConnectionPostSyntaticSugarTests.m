//
//  TNTHttpConnectionPostSyntaticSugarTests.m
//  NitroConnectionTests
//
//  Created by Daniel L. Alves on 30/07/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import "TNTTestCase.h"

// NitroConnection
#import "NSDictionary+QueryString.h"
#import "TNTHttpConnection+SyntaticSugar.h"
#import "TNTHttpStatusCodes.h"

// NitroConnectionTests
#import "TNTXCTTestMacros.h"

// Pods
#import <OHHTTPStubs/OHHTTPStubs.h>

#pragma mark - Constants

static NSString * const NitroConnectionTestsStubURL = @"http://success.nitroconnection.com";
static NSString * const NitroConnectionTestsStubErrorURL = @"http://error.nitroconnection.com";

#pragma mark - TNTHttpConnectionPostSyntaticSugarTests Interface

@interface TNTHttpConnectionPostSyntaticSugarTests : TNTTestCase< TNTHttpConnectionDelegate >
{
    TNTHttpConnection *connection;
    
    BOOL delegateDidStartCalled;
    BOOL delegateOnSuccessCalled;
    BOOL delegateOnErrorCalled;
    
    BOOL didStartBlockRan;
    BOOL onSuccessBlockRan;
    BOOL onErrorBlockRan;
}
@end

#pragma mark - TNTHttpConnectionPostSyntaticSugarTests Implementation

@implementation TNTHttpConnectionPostSyntaticSugarTests

#pragma mark - Tests Lifecycle

+( void )setUp
{
    [super setUp];
    
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

+( void )tearDown
{
    [OHHTTPStubs removeAllStubs];
}

#pragma mark - Cases

-( void )test_post_macro_generated_methods_exist
{
    // Managed
    [TNTHttpConnection post: NitroConnectionTestsStubURL delegate: nil];
    [TNTHttpConnection post: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: nil delegate: self];
    [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: self];
    [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
    
    // Unmanaged
    [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL delegate: nil];
    [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL withParams: nil delegate: self];
    [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: self];
    [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
}

-( void )test_post_managed_methods_connections_are_not_deallocated_when_scope_is_left
{
    __weak TNTHttpConnection *weakConnection;
    
    @autoreleasepool
    {
        TNTHttpConnection *post = [TNTHttpConnection post: NitroConnectionTestsStubURL delegate: nil];
        weakConnection = post;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *post = [TNTHttpConnection post: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = post;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *post = [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: nil delegate: nil];
        weakConnection = post;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *post = [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = post;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *post = [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: nil];
        weakConnection = post;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *post = [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = post;
    };
    XCTAssertNotNil( weakConnection );
}

-( void )test_post_unmanaged_methods_connections_are_deallocated_when_scope_is_left
{
    __weak TNTHttpConnection *weakConnection;
    
    @autoreleasepool
    {
        TNTHttpConnection *post = [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL delegate: nil];
        weakConnection = post;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *post = [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = post;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *post = [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL withParams: nil delegate: nil];
        weakConnection = post;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *post = [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = post;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *post = [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: nil];
        weakConnection = post;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *post = [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = post;
    };
    XCTAssertNil( weakConnection );
}

-( void )test_post_methods_use_http_post
{
    // Managed
    TNTHttpConnection *temp = [TNTHttpConnection post: NitroConnectionTestsStubURL delegate: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPost );
    
    temp = [TNTHttpConnection post: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPost );
    
    temp = [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPost );
    
    temp = [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPost );
    
    temp = [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPost );
    
    temp = [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPost );
    
    // Unmanaged
    temp = [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL delegate: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPost );
    
    temp = [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPost );
    
    temp = [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL withParams: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPost );
    
    temp = [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPost );
    
    temp = [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPost );
    
    temp = [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPost );
}

-( void )test_post_methods_pass_params_in_request_body
{
    NSDictionary *params = @{ @"name": @"psylocke", @"mutant-power": @"psychic katana" };
    
    // Managed
    TNTHttpConnection *temp = [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: params delegate: self];
    XCTAssertRequestBody( temp.lastRequest, params );
    
    temp = [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: params onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestBody( temp.lastRequest, params );
    
    temp = [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: params headers: nil delegate: self];
    XCTAssertRequestBody( temp.lastRequest, params );
    
    temp = [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: params headers: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestBody( temp.lastRequest, params );
    
    // Unmanaged
    temp = [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL withParams: params delegate: self];
    XCTAssertRequestBody( temp.lastRequest, params );
    
    temp = [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL withParams: params onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestBody( temp.lastRequest, params );
    
    temp = [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL withParams: params headers: nil delegate: self];
    XCTAssertRequestBody( temp.lastRequest, params );
    
    temp = [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL withParams: params headers: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestBody( temp.lastRequest, params );
}

-( void )test_post_methods_send_headers
{
    NSDictionary *headers = @{ @"name": @"psylocke", @"mutant-power": @"psychic katana" };
    
    // Managed
    TNTHttpConnection *temp = [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: nil headers: headers delegate: self];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
    
    temp = [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: nil headers: headers onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
    
    // Unmanaged
    temp = [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL withParams: nil headers: headers delegate: self];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
    
    temp = [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL withParams: nil headers: headers onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
}

-( void )test_post_calls_delegate_on_start
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection post: NitroConnectionTestsStubURL delegate: self];
    }];
    
    XCTAssertTrue( delegateDidStartCalled );
    
    delegateDidStartCalled = NO;
    
    // Unmanaged
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL delegate: self];
    }];
    
    XCTAssertTrue( delegateDidStartCalled );
}

-( void )test_post_calls_delegate_on_success
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection post: NitroConnectionTestsStubURL delegate: self];
    }];
    
    XCTAssertTrue( delegateOnSuccessCalled );
    
    delegateOnSuccessCalled = NO;
    
    // Unmanaged
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL delegate: self];
    }];
    
    XCTAssertTrue( delegateOnSuccessCalled );
}

-( void )test_post_calls_delegate_on_error
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection post: NitroConnectionTestsStubErrorURL delegate: self];
    }];
    
    XCTAssertTrue( delegateOnErrorCalled );
    
    delegateOnErrorCalled = NO;
    
    // Unmanaged
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubErrorURL delegate: self];
    }];
    
    XCTAssertTrue( delegateOnErrorCalled );
}

-( void )test_post_calls_did_start_block_on_start
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection post: NitroConnectionTestsStubURL
                                   onDidStart: ^{ didStartBlockRan = YES;
                                       [self finishedAsyncOperation]; }
                                    onSuccess: nil
                                      onError: nil];
    }];
    
    XCTAssertTrue( didStartBlockRan );
    
    didStartBlockRan = NO;
    
    // Unmanaged
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL
                                            onDidStart: ^{ didStartBlockRan = YES;
                                                [self finishedAsyncOperation]; }
                                             onSuccess: nil
                                               onError: nil];
    }];
    
    XCTAssertTrue( didStartBlockRan );
}

-( void )test_post_calls_success_block_on_success
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection post: NitroConnectionTestsStubURL
                                   onDidStart: nil
                                    onSuccess: ^( NSHTTPURLResponse *response, NSData *data ) {
                                        onSuccessBlockRan = YES;
                                        [self finishedAsyncOperation];
                                    }
                                      onError: nil];
    }];
    
    XCTAssertTrue( onSuccessBlockRan );
    
    onSuccessBlockRan = NO;
    
    // Unmanaged
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubURL
                                            onDidStart: nil
                                             onSuccess: ^( NSHTTPURLResponse *response, NSData *data ) {
                                                 onSuccessBlockRan = YES;
                                                 [self finishedAsyncOperation];
                                             }
                                               onError: nil];
    }];
    
    XCTAssertTrue( onSuccessBlockRan );
}

-( void )test_post_calls_error_block_on_error
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection post: NitroConnectionTestsStubErrorURL
                                   onDidStart: nil
                                    onSuccess: nil
                                      onError: ^( NSError *error ) {
                                          onErrorBlockRan = YES;
                                          [self finishedAsyncOperation];
                                      }];
    }];
    
    XCTAssertTrue( onErrorBlockRan );
    
    onErrorBlockRan = NO;
    
    // Unmanaged
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection unmanagedPost: NitroConnectionTestsStubErrorURL
                                            onDidStart: nil
                                             onSuccess: nil
                                               onError: ^( NSError *error ) {
                                                   onErrorBlockRan = YES;
                                                   [self finishedAsyncOperation];
                                               }];
    }];
    
    XCTAssertTrue( onErrorBlockRan );
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















































