//
//  TNTHttpConnectionPatchSyntaticSugarTests.m
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

#pragma mark - TNTHttpConnectionPatchSyntaticSugarTests Interface

@interface TNTHttpConnectionPatchSyntaticSugarTests : TNTTestCase< TNTHttpConnectionDelegate >
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

#pragma mark - TNTHttpConnectionPatchSyntaticSugarTests Implementation

@implementation TNTHttpConnectionPatchSyntaticSugarTests

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

-( void )test_patch_macro_generated_methods_exist
{
    // Managed
    [TNTHttpConnection patch: NitroConnectionTestsStubURL delegate: nil];
    [TNTHttpConnection patch: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection patch: NitroConnectionTestsStubURL withParams: nil delegate: self];
    [TNTHttpConnection patch: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection patch: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: self];
    [TNTHttpConnection patch: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
    
    // Unmanaged
    [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL delegate: nil];
    [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL withParams: nil delegate: self];
    [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: self];
    [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
}

-( void )test_patch_managed_methods_connections_are_not_deallocated_when_scope_is_left
{
    __weak TNTHttpConnection *weakConnection;
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection patch: NitroConnectionTestsStubURL delegate: nil];
        weakConnection = head;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection patch: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = head;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection patch: NitroConnectionTestsStubURL withParams: nil delegate: nil];
        weakConnection = head;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection patch: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = head;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection patch: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: nil];
        weakConnection = head;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection patch: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = head;
    };
    XCTAssertNotNil( weakConnection );
}

-( void )test_patch_unmanaged_methods_connections_are_deallocated_when_scope_is_left
{
    __weak TNTHttpConnection *weakConnection;
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL delegate: nil];
        weakConnection = head;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = head;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL withParams: nil delegate: nil];
        weakConnection = head;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = head;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: nil];
        weakConnection = head;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = head;
    };
    XCTAssertNil( weakConnection );
}

-( void )test_patch_methods_use_http_patch
{
    // Managed
    TNTHttpConnection *temp = [TNTHttpConnection patch: NitroConnectionTestsStubURL delegate: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPatch );
    
    temp = [TNTHttpConnection patch: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPatch );
    
    temp = [TNTHttpConnection patch: NitroConnectionTestsStubURL withParams: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPatch );
    
    temp = [TNTHttpConnection patch: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPatch );
    
    temp = [TNTHttpConnection patch: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPatch );
    
    temp = [TNTHttpConnection patch: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPatch );
    
    // Unmanaged
    temp = [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL delegate: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPatch );
    
    temp = [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPatch );
    
    temp = [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL withParams: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPatch );
    
    temp = [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPatch );
    
    temp = [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPatch );
    
    temp = [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPatch );
}

-( void )test_patch_methods_pass_params_in_request_body
{
    NSDictionary *params = @{ @"name": @"xavier", @"mutant-power": @"telepathy" };
    
    // Managed
    TNTHttpConnection *temp = [TNTHttpConnection patch: NitroConnectionTestsStubURL withParams: params delegate: self];
    XCTAssertRequestBody( temp.lastRequest, params );
    
    temp = [TNTHttpConnection patch: NitroConnectionTestsStubURL withParams: params onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestBody( temp.lastRequest, params );
    
    temp = [TNTHttpConnection patch: NitroConnectionTestsStubURL withParams: params headers: nil delegate: self];
    XCTAssertRequestBody( temp.lastRequest, params );
    
    temp = [TNTHttpConnection patch: NitroConnectionTestsStubURL withParams: params headers: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestBody( temp.lastRequest, params );
    
    // Unmanaged
    temp = [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL withParams: params delegate: self];
    XCTAssertRequestBody( temp.lastRequest, params );
    
    temp = [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL withParams: params onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestBody( temp.lastRequest, params );
    
    temp = [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL withParams: params headers: nil delegate: self];
    XCTAssertRequestBody( temp.lastRequest, params );
    
    temp = [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL withParams: params headers: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestBody( temp.lastRequest, params );
}

-( void )test_patch_methods_send_headers
{
    NSDictionary *headers = @{ @"name": @"xavier", @"mutant-power": @"telepathy" };
    
    // Managed
    TNTHttpConnection *temp = [TNTHttpConnection patch: NitroConnectionTestsStubURL withParams: nil headers: headers delegate: self];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
    
    temp = [TNTHttpConnection patch: NitroConnectionTestsStubURL withParams: nil headers: headers onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
    
    // Unmanaged
    temp = [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL withParams: nil headers: headers delegate: self];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
    
    temp = [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL withParams: nil headers: headers onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
}

-( void )test_patch_calls_delegate_on_start
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection patch: NitroConnectionTestsStubURL delegate: self];
    }];
    
    XCTAssertTrue( delegateDidStartCalled );
    
    delegateDidStartCalled = NO;
    
    // Unmanaged
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL delegate: self];
    }];
    
    XCTAssertTrue( delegateDidStartCalled );
}

-( void )test_patch_calls_delegate_on_success
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection patch: NitroConnectionTestsStubURL delegate: self];
    }];
    
    XCTAssertTrue( delegateOnSuccessCalled );
    
    delegateOnSuccessCalled = NO;
    
    // Unmanaged
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL delegate: self];
    }];
    
    XCTAssertTrue( delegateOnSuccessCalled );
}

-( void )test_patch_calls_delegate_on_error
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection patch: NitroConnectionTestsStubErrorURL delegate: self];
    }];
    
    XCTAssertTrue( delegateOnErrorCalled );
    
    delegateOnErrorCalled = NO;
    
    // Unmanaged
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubErrorURL delegate: self];
    }];
    
    XCTAssertTrue( delegateOnErrorCalled );
}

-( void )test_patch_calls_did_start_block_on_start
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection patch: NitroConnectionTestsStubURL
                                    onDidStart: ^( TNTHttpConnection *conn ){
                                        didStartBlockRan = YES;
                                        [self finishedAsyncOperation];
                                     }
                                     onSuccess: nil
                                       onError: nil];
    }];
    
    XCTAssertTrue( didStartBlockRan );
    
    didStartBlockRan = NO;
    
    // Unmanaged
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL
                                             onDidStart: ^( TNTHttpConnection *conn ){
                                                 didStartBlockRan = YES;
                                                 [self finishedAsyncOperation];
                                              }
                                              onSuccess: nil
                                                onError: nil];
    }];
    
    XCTAssertTrue( didStartBlockRan );
}

-( void )test_patch_calls_success_block_on_success
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection patch: NitroConnectionTestsStubURL
                                    onDidStart: nil
                                     onSuccess: ^( TNTHttpConnection *conn, NSHTTPURLResponse *response, NSData *data ) {
                                         onSuccessBlockRan = YES;
                                         [self finishedAsyncOperation];
                                     }
                                       onError: nil];
    }];
    
    XCTAssertTrue( onSuccessBlockRan );
    
    onSuccessBlockRan = NO;
    
    // Unmanaged
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubURL
                                             onDidStart: nil
                                              onSuccess: ^( TNTHttpConnection *conn, NSHTTPURLResponse *response, NSData *data ) {
                                                  onSuccessBlockRan = YES;
                                                  [self finishedAsyncOperation];
                                              }
                                                onError: nil];
    }];
    
    XCTAssertTrue( onSuccessBlockRan );
}

-( void )test_patch_calls_error_block_on_error
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection patch: NitroConnectionTestsStubErrorURL
                                    onDidStart: nil
                                     onSuccess: nil
                                       onError: ^( TNTHttpConnection *conn, NSError *error ) {
                                           onErrorBlockRan = YES;
                                           [self finishedAsyncOperation];
                                       }];
    }];
    
    XCTAssertTrue( onErrorBlockRan );
    
    onErrorBlockRan = NO;
    
    // Unmanaged
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection unmanagedPatch: NitroConnectionTestsStubErrorURL
                                             onDidStart: nil
                                              onSuccess: nil
                                                onError: ^( TNTHttpConnection *conn, NSError *error ) {
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















































