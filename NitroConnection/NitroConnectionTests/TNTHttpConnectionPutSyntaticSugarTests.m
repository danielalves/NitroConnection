//
//  TNTHttpConnectionPutSyntaticSugarTests.m
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

#pragma mark - TNTHttpConnectionPutSyntaticSugarTests Interface

@interface TNTHttpConnectionPutSyntaticSugarTests : TNTTestCase< TNTHttpConnectionDelegate >
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

#pragma mark - TNTHttpConnectionPutSyntaticSugarTests Implementation

@implementation TNTHttpConnectionPutSyntaticSugarTests

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

-( void )test_put_macro_generated_methods_exist
{
    // Managed
    [TNTHttpConnection put: NitroConnectionTestsStubURL delegate: nil];
    [TNTHttpConnection put: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection put: NitroConnectionTestsStubURL params: nil delegate: self];
    [TNTHttpConnection put: NitroConnectionTestsStubURL params: nil onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection put: NitroConnectionTestsStubURL queryString: nil body: nil delegate: self];
    [TNTHttpConnection put: NitroConnectionTestsStubURL queryString: nil body: nil onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection put: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil delegate: self];
    [TNTHttpConnection put: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
    
    // Unmanaged
    [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL delegate: nil];
    [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL params: nil delegate: self];
    [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL params: nil onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL queryString: nil body: nil delegate: self];
    [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL queryString: nil body: nil onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil delegate: self];
    [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
}

-( void )test_put_managed_methods_connections_are_not_deallocated_when_scope_is_left
{
    __weak TNTHttpConnection *weakConnection;
    
    @autoreleasepool
    {
        TNTHttpConnection *put = [TNTHttpConnection put: NitroConnectionTestsStubURL delegate: nil];
        weakConnection = put;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *put = [TNTHttpConnection put: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = put;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *put = [TNTHttpConnection put: NitroConnectionTestsStubURL params: nil delegate: nil];
        weakConnection = put;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *put = [TNTHttpConnection put: NitroConnectionTestsStubURL params: nil onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = put;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *put = [TNTHttpConnection put: NitroConnectionTestsStubURL queryString: nil body: nil delegate: nil];
        weakConnection = put;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *put = [TNTHttpConnection put: NitroConnectionTestsStubURL queryString: nil body: nil onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = put;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *put = [TNTHttpConnection put: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil delegate: nil];
        weakConnection = put;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *put = [TNTHttpConnection put: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = put;
    };
    XCTAssertNotNil( weakConnection );
}

-( void )test_put_unmanaged_methods_connections_are_deallocated_when_scope_is_left
{
    __weak TNTHttpConnection *weakConnection;
    
    @autoreleasepool
    {
        TNTHttpConnection *put = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL delegate: nil];
        weakConnection = put;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *put = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = put;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *put = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL params: nil delegate: nil];
        weakConnection = put;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *put = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL params: nil onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = put;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *put = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL queryString: nil body: nil delegate: nil];
        weakConnection = put;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *put = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL queryString: nil body: nil onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = put;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *put = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil delegate: nil];
        weakConnection = put;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *put = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = put;
    };
    XCTAssertNil( weakConnection );
}

-( void )test_put_methods_use_http_put
{
    // Managed
    TNTHttpConnection *temp = [TNTHttpConnection put: NitroConnectionTestsStubURL delegate: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPut );
    
    temp = [TNTHttpConnection put: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPut );
    
    temp = [TNTHttpConnection put: NitroConnectionTestsStubURL params: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPut );
    
    temp = [TNTHttpConnection put: NitroConnectionTestsStubURL params: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPut );
    
    temp = [TNTHttpConnection put: NitroConnectionTestsStubURL queryString: nil body: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPut );
    
    temp = [TNTHttpConnection put: NitroConnectionTestsStubURL queryString: nil body: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPut );
    
    temp = [TNTHttpConnection put: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPut );
    
    temp = [TNTHttpConnection put: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPut );
    
    // Unmanaged
    temp = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL delegate: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPut );
    
    temp = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPut );
    
    temp = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL params: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPut );
    
    temp = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL params: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPut );
    
    temp = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL queryString: nil body: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPut );
    
    temp = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL queryString: nil body: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPut );
    
    temp = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPut );
    
    temp = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodPut );
}

-( void )test_put_methods_pass_params_in_request_body
{
    NSDictionary *params = @{ @"name": @"rogue", @"mutant-power": @"absorption of memories, skills and powers by touch" };
    
    // Managed
    TNTHttpConnection *temp = [TNTHttpConnection put: NitroConnectionTestsStubURL params: params delegate: self];
    XCTAssertRequestBody( temp.lastRequest, params );
    
    temp = [TNTHttpConnection put: NitroConnectionTestsStubURL params: params onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestBody( temp.lastRequest, params );
    
    // Unmanaged
    temp = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL params: params delegate: self];
    XCTAssertRequestBody( temp.lastRequest, params );
    
    temp = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL params: params onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestBody( temp.lastRequest, params );
}

-( void )test_put_methods_send_headers
{
    NSDictionary *headers = @{ @"name": @"rogue", @"mutant-power": @"absorption of memories, skills and powers by touch" };
    
    // Managed
    TNTHttpConnection *temp = [TNTHttpConnection put: NitroConnectionTestsStubURL queryString: nil body: nil headers: headers delegate: self];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
    
    temp = [TNTHttpConnection put: NitroConnectionTestsStubURL queryString: nil body: nil headers: headers onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
    
    // Unmanaged
    temp = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL queryString: nil body: nil headers: headers delegate: self];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
    
    temp = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL queryString: nil body: nil headers: headers onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
}

-( void )test_put_calls_delegate_on_start
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection put: NitroConnectionTestsStubURL delegate: self];
    }];
    
    XCTAssertTrue( delegateDidStartCalled );
    
    delegateDidStartCalled = NO;
    
    // Unmanaged
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL delegate: self];
    }];
    
    XCTAssertTrue( delegateDidStartCalled );
}

-( void )test_put_calls_delegate_on_success
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection put: NitroConnectionTestsStubURL delegate: self];
    }];
    
    XCTAssertTrue( delegateOnSuccessCalled );
    
    delegateOnSuccessCalled = NO;
    
    // Unmanaged
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL delegate: self];
    }];
    
    XCTAssertTrue( delegateOnSuccessCalled );
}

-( void )test_put_calls_delegate_on_error
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection put: NitroConnectionTestsStubErrorURL delegate: self];
    }];
    
    XCTAssertTrue( delegateOnErrorCalled );
    
    delegateOnErrorCalled = NO;
    
    // Unmanaged
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubErrorURL delegate: self];
    }];
    
    XCTAssertTrue( delegateOnErrorCalled );
}

-( void )test_put_calls_did_start_block_on_start
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection put: NitroConnectionTestsStubURL
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
        connection = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL
                                           onDidStart: ^( TNTHttpConnection *conn ){
                                               didStartBlockRan = YES;
                                               [self finishedAsyncOperation];
                                            }
                                            onSuccess: nil
                                              onError: nil];
    }];
    
    XCTAssertTrue( didStartBlockRan );
}

-( void )test_put_calls_success_block_on_success
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection put: NitroConnectionTestsStubURL
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
        connection = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubURL
                                           onDidStart: nil
                                            onSuccess: ^( TNTHttpConnection *conn, NSHTTPURLResponse *response, NSData *data ) {
                                                onSuccessBlockRan = YES;
                                                [self finishedAsyncOperation];
                                            }
                                              onError: nil];
    }];
    
    XCTAssertTrue( onSuccessBlockRan );
}

-( void )test_put_calls_error_block_on_error
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection put: NitroConnectionTestsStubErrorURL
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
        connection = [TNTHttpConnection unmanagedPut: NitroConnectionTestsStubErrorURL
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















































