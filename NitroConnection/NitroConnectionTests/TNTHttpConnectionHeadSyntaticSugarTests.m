//
//  TNTHttpConnectionHeadSyntaticSugarTests.m
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

#pragma mark - TNTHttpConnectionHeadSyntaticSugarTests Interface

@interface TNTHttpConnectionHeadSyntaticSugarTests : TNTTestCase< TNTHttpConnectionDelegate >
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

#pragma mark - TNTHttpConnectionHeadSyntaticSugarTests Implementation

@implementation TNTHttpConnectionHeadSyntaticSugarTests

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

-( void )test_head_macro_generated_methods_exist
{
    // Managed
    [TNTHttpConnection head: NitroConnectionTestsStubURL delegate: nil];
    [TNTHttpConnection head: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection head: NitroConnectionTestsStubURL params: nil delegate: self];
    [TNTHttpConnection head: NitroConnectionTestsStubURL params: nil onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection head: NitroConnectionTestsStubURL queryString: nil body: nil delegate: self];
    [TNTHttpConnection head: NitroConnectionTestsStubURL queryString: nil body: nil onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection head: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil delegate: self];
    [TNTHttpConnection head: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
    
    // Unmanaged
    [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL delegate: nil];
    [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL params: nil delegate: self];
    [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL params: nil onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL queryString: nil body: nil delegate: self];
    [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL queryString: nil body: nil onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil delegate: self];
    [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
}

-( void )test_head_managed_methods_connections_are_not_deallocated_when_scope_is_left
{
    __weak TNTHttpConnection *weakConnection;
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection head: NitroConnectionTestsStubURL delegate: nil];
        weakConnection = head;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection head: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = head;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection head: NitroConnectionTestsStubURL params: nil delegate: nil];
        weakConnection = head;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection head: NitroConnectionTestsStubURL params: nil onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = head;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection head: NitroConnectionTestsStubURL queryString: nil body: nil delegate: nil];
        weakConnection = head;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection head: NitroConnectionTestsStubURL queryString: nil body: nil onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = head;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection head: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil delegate: nil];
        weakConnection = head;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection head: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = head;
    };
    XCTAssertNotNil( weakConnection );
}

-( void )test_head_unmanaged_methods_connections_are_deallocated_when_scope_is_left
{
    __weak TNTHttpConnection *weakConnection;
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL delegate: nil];
        weakConnection = head;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = head;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL params: nil delegate: nil];
        weakConnection = head;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL params: nil onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = head;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL queryString: nil body: nil delegate: nil];
        weakConnection = head;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL queryString: nil body: nil onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = head;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil delegate: nil];
        weakConnection = head;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *head = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = head;
    };
    XCTAssertNil( weakConnection );
}

-( void )test_head_methods_use_http_head
{
    // Managed
    TNTHttpConnection *temp = [TNTHttpConnection head: NitroConnectionTestsStubURL delegate: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodHead );
    
    temp = [TNTHttpConnection head: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodHead );
    
    temp = [TNTHttpConnection head: NitroConnectionTestsStubURL params: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodHead );
    
    temp = [TNTHttpConnection head: NitroConnectionTestsStubURL params: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodHead );
    
    temp = [TNTHttpConnection head: NitroConnectionTestsStubURL queryString: nil body: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodHead );
    
    temp = [TNTHttpConnection head: NitroConnectionTestsStubURL queryString: nil body: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodHead );
    
    temp = [TNTHttpConnection head: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodHead );
    
    temp = [TNTHttpConnection head: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodHead );
    
    // Unmanaged
    temp = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL delegate: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodHead );
    
    temp = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodHead );
    
    temp = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL params: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodHead );
    
    temp = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL params: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodHead );
    
    temp = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL queryString: nil body: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodHead );
    
    temp = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL queryString: nil body: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodHead );
    
    temp = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodHead );
    
    temp = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL queryString: nil body: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodHead );
}

-( void )test_head_methods_pass_params_in_query_string
{
    NSDictionary *params = @{ @"name": @"storm", @"mutant-power": @"weather control" };
    
    // Managed
    TNTHttpConnection *temp = [TNTHttpConnection head: NitroConnectionTestsStubURL params: params delegate: self];
    XCTAssertRequestQueryString( temp.lastRequest, params );
    
    temp = [TNTHttpConnection head: NitroConnectionTestsStubURL params: params onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestQueryString( temp.lastRequest, params );
    
    // Unmanaged
    temp = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL params: params delegate: self];
    XCTAssertRequestQueryString( temp.lastRequest, params );
    
    temp = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL params: params onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestQueryString( temp.lastRequest, params );
}

-( void )test_head_methods_send_headers
{
    NSDictionary *headers = @{ @"name": @"storm", @"mutant-power": @"weather control" };
    
    // Managed
    TNTHttpConnection *temp = [TNTHttpConnection head: NitroConnectionTestsStubURL queryString: nil body: nil headers: headers delegate: self];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
    
    temp = [TNTHttpConnection head: NitroConnectionTestsStubURL queryString: nil body: nil headers: headers onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
    
    // Unmanaged
    temp = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL queryString: nil body: nil headers: headers delegate: self];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
    
    temp = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL queryString: nil body: nil headers: headers onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
}

-( void )test_head_calls_delegate_on_start
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection head: NitroConnectionTestsStubURL delegate: self];
    }];
    
    XCTAssertTrue( delegateDidStartCalled );
    
    delegateDidStartCalled = NO;
    
    // Unmanaged
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL delegate: self];
    }];
    
    XCTAssertTrue( delegateDidStartCalled );
}

-( void )test_head_calls_delegate_on_success
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection head: NitroConnectionTestsStubURL delegate: self];
    }];
    
    XCTAssertTrue( delegateOnSuccessCalled );
    
    delegateOnSuccessCalled = NO;
    
    // Unmanaged
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL delegate: self];
    }];
    
    XCTAssertTrue( delegateOnSuccessCalled );
}

-( void )test_head_calls_delegate_on_error
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection head: NitroConnectionTestsStubErrorURL delegate: self];
    }];
    
    XCTAssertTrue( delegateOnErrorCalled );
    
    delegateOnErrorCalled = NO;
    
    // Unmanaged
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubErrorURL delegate: self];
    }];
    
    XCTAssertTrue( delegateOnErrorCalled );
}

-( void )test_head_calls_did_start_block_on_start
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection head: NitroConnectionTestsStubURL
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
        connection = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL
                                          onDidStart: ^( TNTHttpConnection *conn ){
                                              didStartBlockRan = YES;
                                              [self finishedAsyncOperation];
                                           }
                                           onSuccess: nil
                                             onError: nil];
    }];
    
    XCTAssertTrue( didStartBlockRan );
}

-( void )test_head_calls_success_block_on_success
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection head: NitroConnectionTestsStubURL
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
        connection = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubURL
                                          onDidStart: nil
                                           onSuccess: ^( TNTHttpConnection *conn, NSHTTPURLResponse *response, NSData *data ) {
                                               onSuccessBlockRan = YES;
                                               [self finishedAsyncOperation];
                                           }
                                             onError: nil];
    }];
    
    XCTAssertTrue( onSuccessBlockRan );
}

-( void )test_head_calls_error_block_on_error
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection head: NitroConnectionTestsStubErrorURL
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
        connection = [TNTHttpConnection unmanagedHead: NitroConnectionTestsStubErrorURL
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















































