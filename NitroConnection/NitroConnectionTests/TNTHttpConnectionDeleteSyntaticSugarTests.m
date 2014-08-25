//
//  TNTHttpConnectionDeleteSyntaticSugarTests.m
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

#pragma mark - TNTHttpConnectionDeleteSyntaticSugarTests Interface

@interface TNTHttpConnectionDeleteSyntaticSugarTests : TNTTestCase< TNTHttpConnectionDelegate >
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

#pragma mark - TNTHttpConnectionDeleteSyntaticSugarTests Implementation

@implementation TNTHttpConnectionDeleteSyntaticSugarTests

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

-( void )test_delete_macro_generated_methods_exist
{
    // Managed
    [TNTHttpConnection delete: NitroConnectionTestsStubURL delegate: nil];
    [TNTHttpConnection delete: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: nil delegate: self];
    [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: self];
    [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
    
    // Unmanaged
    [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL delegate: nil];
    [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL withParams: nil delegate: self];
    [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: self];
    [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
}

-( void )test_delete_managed_methods_connections_are_not_deallocated_when_scope_is_left
{
    __weak TNTHttpConnection *weakConnection;
    
    @autoreleasepool
    {
        TNTHttpConnection *delete = [TNTHttpConnection delete: NitroConnectionTestsStubURL delegate: nil];
        weakConnection = delete;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *delete = [TNTHttpConnection delete: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = delete;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *delete = [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: nil delegate: nil];
        weakConnection = delete;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *delete = [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = delete;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *delete = [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: nil];
        weakConnection = delete;
    };
    XCTAssertNotNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *delete = [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = delete;
    };
    XCTAssertNotNil( weakConnection );
}

-( void )test_delete_unmanaged_methods_connections_are_deallocated_when_scope_is_left
{
    __weak TNTHttpConnection *weakConnection;
    
    @autoreleasepool
    {
        TNTHttpConnection *delete = [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL delegate: nil];
        weakConnection = delete;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *delete = [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = delete;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *delete = [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL withParams: nil delegate: nil];
        weakConnection = delete;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *delete = [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = delete;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *delete = [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: nil];
        weakConnection = delete;
    };
    XCTAssertNil( weakConnection );
    
    @autoreleasepool
    {
        TNTHttpConnection *delete = [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
        weakConnection = delete;
    };
    XCTAssertNil( weakConnection );
}

-( void )test_delete_methods_use_http_delete
{
    // Managed
    TNTHttpConnection *temp = [TNTHttpConnection delete: NitroConnectionTestsStubURL delegate: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodDelete );
    
    temp = [TNTHttpConnection delete: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodDelete );
    
    temp = [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodDelete );
    
    temp = [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodDelete );
    
    temp = [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodDelete );
    
    temp = [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodDelete );
    
    // Unmanaged
    temp = [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL delegate: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodDelete );
    
    temp = [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodDelete );
    
    temp = [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL withParams: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodDelete );
    
    temp = [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodDelete );
    
    temp = [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodDelete );
    
    temp = [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodDelete );
}

-( void )test_delete_methods_pass_params_in_query_string
{
    NSDictionary *params = @{ @"name": @"wolverine", @"mutant-power": @"healing factor" };
    
    // Managed
    TNTHttpConnection *temp = [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: params delegate: self];
    XCTAssertRequestQueryString( temp.lastRequest, params );
    
    temp = [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: params onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestQueryString( temp.lastRequest, params );
    
    temp = [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: params headers: nil delegate: self];
    XCTAssertRequestQueryString( temp.lastRequest, params );
    
    temp = [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: params headers: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestQueryString( temp.lastRequest, params );
    
    // Unmanaged
    temp = [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL withParams: params delegate: self];
    XCTAssertRequestQueryString( temp.lastRequest, params );
    
    temp = [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL withParams: params onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestQueryString( temp.lastRequest, params );
    
    temp = [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL withParams: params headers: nil delegate: self];
    XCTAssertRequestQueryString( temp.lastRequest, params );
    
    temp = [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL withParams: params headers: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestQueryString( temp.lastRequest, params );
}

-( void )test_delete_methods_send_headers
{
    NSDictionary *headers = @{ @"name": @"wolverine", @"mutant-power": @"healing factor" };
    
    // Managed
    TNTHttpConnection *temp = [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: nil headers: headers delegate: self];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
    
    temp = [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: nil headers: headers onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
    
    // Unmanaged
    temp = [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL withParams: nil headers: headers delegate: self];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
    
    temp = [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL withParams: nil headers: headers onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
}

-( void )test_delete_calls_delegate_on_start
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection delete: NitroConnectionTestsStubURL delegate: self];
    }];
    
    XCTAssertTrue( delegateDidStartCalled );
    
    delegateDidStartCalled = NO;
    
    // Unmanaged
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL delegate: self];
    }];
    
    XCTAssertTrue( delegateDidStartCalled );
}

-( void )test_delete_calls_delegate_on_success
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection delete: NitroConnectionTestsStubURL delegate: self];
    }];
    
    XCTAssertTrue( delegateOnSuccessCalled );
    
    delegateOnSuccessCalled = NO;
    
    // Unmanaged
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL delegate: self];
    }];
    
    XCTAssertTrue( delegateOnSuccessCalled );
}

-( void )test_delete_calls_delegate_on_error
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection delete: NitroConnectionTestsStubErrorURL delegate: self];
    }];
    
    XCTAssertTrue( delegateOnErrorCalled );
    
    delegateOnErrorCalled = NO;
    
    // Unmanaged
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubErrorURL delegate: self];
    }];
    
    XCTAssertTrue( delegateOnErrorCalled );
}

-( void )test_delete_calls_did_start_block_on_start
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection delete: NitroConnectionTestsStubURL
                                  onDidStart: ^( TNTHttpConnection *conn ){ didStartBlockRan = YES;
                                      [self finishedAsyncOperation]; }
                                   onSuccess: nil
                                     onError: nil];
    }];
    
    XCTAssertTrue( didStartBlockRan );
    
    didStartBlockRan = NO;
    
    // Unmanaged
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL
                                           onDidStart: ^( TNTHttpConnection *conn ){ didStartBlockRan = YES;
                                               [self finishedAsyncOperation]; }
                                            onSuccess: nil
                                              onError: nil];
    }];
    
    XCTAssertTrue( didStartBlockRan );
}

-( void )test_delete_calls_success_block_on_success
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection delete: NitroConnectionTestsStubURL
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
        connection = [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubURL
                                           onDidStart: nil
                                            onSuccess: ^( TNTHttpConnection *conn, NSHTTPURLResponse *response, NSData *data ) {
                                                onSuccessBlockRan = YES;
                                                [self finishedAsyncOperation];
                                            }
                                              onError: nil];
    }];
    
    XCTAssertTrue( onSuccessBlockRan );
}

-( void )test_delete_calls_error_block_on_error
{
    // Managed
    [self waitForAsyncCode: ^{
        connection = [TNTHttpConnection delete: NitroConnectionTestsStubErrorURL
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
        connection = [TNTHttpConnection unmanagedDelete: NitroConnectionTestsStubErrorURL
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















































