//
//  TNTHttpConnectionSyntaticSugarTests.m
//  NitroConnectionTests
//
//  Created by Daniel L. Alves on 30/07/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import <XCTest/XCTest.h>

// ios
#import <Foundation/Foundation.h>

// NitroConnection
#import "NSDictionary+QueryString.h"
#import "TNTHttpConnection+SyntaticSugar.h"
#import "TNTHttpStatusCodes.h"

// NitroMisc
#import "XCTestCase+Nitro_Utils.h"

// Pods
#import <OHHTTPStubs/OHHTTPStubs.h>

#pragma mark - Defines

#define XCTAssertRequestHttpMethod( request, httpMethod ) XCTAssertEqualObjects( request.HTTPMethod, [NSString stringFromHttpMethod: httpMethod] )

#define XCTAssertRequestQueryString( request, queryStringParams )                                                            \
{                                                                                                                            \
    BOOL ret = [temp.lastRequest.URL.absoluteString hasSuffix: [NSString stringWithFormat: @"?%@", [params toQueryString]]]; \
    XCTAssertTrue( ret );                                                                                                    \
}

#define XCTAssertRequestHeaders( request, headers )                  \
{                                                                    \
    NSDictionary *allHeaders = request.allHTTPHeaderFields;          \
    for( NSString *key in headers )                                  \
    {                                                                \
        XCTAssertNotNil( allHeaders[ key ] );                        \
        XCTAssertEqualObjects( allHeaders[ key ], headers[ key ] );  \
    }                                                                \
}

#define XCTAssertRequestBody( request, params )                                 \
{                                                                               \
    NSString *formattedParams = [params toQueryString];                         \
    NSData *data = [formattedParams dataUsingEncoding: NSUTF8StringEncoding];   \
    XCTAssertTrue( [temp.lastRequest.HTTPBody isEqualToData: data] );           \
}

#pragma mark - Constants

static NSString * const NitroConnectionTestsStubURL = @"http://success.nitroconnection.com";
static NSString * const NitroConnectionTestsStubErrorURL = @"http://error.nitroconnection.com";

#pragma mark - TNTHttpConnectionSyntaticSugarTests Interface

@interface TNTHttpConnectionSyntaticSugarTests : XCTestCase< TNTHttpConnectionDelegate >
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

#pragma mark - TNTHttpConnectionSyntaticSugarTests Implementation

@implementation TNTHttpConnectionSyntaticSugarTests

+( void )setUp
{
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

#pragma mark - Http Get

-( void )test_get_methods_compile
{
    [TNTHttpConnection get: NitroConnectionTestsStubURL delegate: nil];
    [TNTHttpConnection get: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection get: NitroConnectionTestsStubURL withParams: nil delegate: self];
    [TNTHttpConnection get: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection get: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: self];
    [TNTHttpConnection get: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
}

-( void )test_get_methods_use_http_get
{
    TNTHttpConnection *temp = [TNTHttpConnection get: NitroConnectionTestsStubURL delegate: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodGet );
    
    temp = [TNTHttpConnection get: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodGet );
    
    temp = [TNTHttpConnection get: NitroConnectionTestsStubURL withParams: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodGet );
    
    temp = [TNTHttpConnection get: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodGet );
    
    temp = [TNTHttpConnection get: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodGet );
    
    temp = [TNTHttpConnection get: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodGet );
}

-( void )test_get_methods_pass_params_in_query_string
{
    NSDictionary *params = @{ @"name": @"wolverine", @"mutant-power": @"healing factor" };

    TNTHttpConnection *temp = [TNTHttpConnection get: NitroConnectionTestsStubURL withParams: params delegate: self];
    XCTAssertRequestQueryString( temp.lastRequest, params );
    
    temp = [TNTHttpConnection get: NitroConnectionTestsStubURL withParams: params onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestQueryString( temp.lastRequest, params );
    
    temp = [TNTHttpConnection get: NitroConnectionTestsStubURL withParams: params headers: nil delegate: self];
    XCTAssertRequestQueryString( temp.lastRequest, params );
    
    temp = [TNTHttpConnection get: NitroConnectionTestsStubURL withParams: params headers: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestQueryString( temp.lastRequest, params );
}

-( void )test_get_methods_send_headers
{
    NSDictionary *headers = @{ @"name": @"wolverine", @"mutant-power": @"healing factor" };
    
    TNTHttpConnection *temp = [TNTHttpConnection get: NitroConnectionTestsStubURL withParams: nil headers: headers delegate: self];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
    
    temp = [TNTHttpConnection get: NitroConnectionTestsStubURL withParams: nil headers: headers onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
}

-( void )test_get_calls_delegate_on_start
{
    [self runAsyncCode: ^{ connection = [TNTHttpConnection get: NitroConnectionTestsStubURL delegate: self]; }
   andWaitForCondition: ^{ return delegateDidStartCalled; }];
    
    XCTAssertTrue( delegateDidStartCalled );
}

-( void )test_get_calls_delegate_on_success
{
    [self runAsyncCode: ^{ connection = [TNTHttpConnection get: NitroConnectionTestsStubURL delegate: self]; }
   andWaitForCondition: ^{ return delegateOnSuccessCalled; }];
    
    XCTAssertTrue( delegateOnSuccessCalled );
}

-( void )test_get_calls_delegate_on_error
{
    [self runAsyncCode: ^{ connection = [TNTHttpConnection get: NitroConnectionTestsStubErrorURL delegate: self]; }
   andWaitForCondition: ^{ return delegateOnErrorCalled; }];
    
    XCTAssertTrue( delegateOnErrorCalled );
}

-( void )test_get_calls_did_start_block_on_start
{
    [self runAsyncCode: ^{ connection = [TNTHttpConnection get: NitroConnectionTestsStubURL
                                                    onDidStart: ^{ didStartBlockRan = YES; }
                                                     onSuccess: nil
                                                       onError: nil]; }
   andWaitForCondition: ^{ return didStartBlockRan; }];
    
    XCTAssertTrue( didStartBlockRan );
}

-( void )test_get_calls_success_block_on_success
{
    [self runAsyncCode: ^{ connection = [TNTHttpConnection get: NitroConnectionTestsStubURL
                                                    onDidStart: nil
                                                     onSuccess: ^( NSHTTPURLResponse *response, NSData *data ) { onSuccessBlockRan = YES; }
                                                       onError: nil]; }
   andWaitForCondition: ^{ return onSuccessBlockRan; }];
    
    XCTAssertTrue( onSuccessBlockRan );
}

-( void )test_get_calls_error_block_on_error
{
    [self runAsyncCode: ^{ connection = [TNTHttpConnection get: NitroConnectionTestsStubErrorURL
                                                    onDidStart: nil
                                                     onSuccess: nil
                                                       onError: ^( NSError *error ) { onErrorBlockRan = YES; }]; }
   andWaitForCondition: ^{ return onErrorBlockRan; }];
    
    XCTAssertTrue( onErrorBlockRan );
}

#pragma mark - Http Head

-( void )test_head_methods_compile
{
    [TNTHttpConnection head: NitroConnectionTestsStubURL delegate: nil];
    [TNTHttpConnection head: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection head: NitroConnectionTestsStubURL withParams: nil delegate: self];
    [TNTHttpConnection head: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection head: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: self];
    [TNTHttpConnection head: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
}

-( void )test_head_methods_use_http_head
{
    TNTHttpConnection *temp = [TNTHttpConnection head: NitroConnectionTestsStubURL delegate: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodHead );
    
    temp = [TNTHttpConnection head: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodHead );
    
    temp = [TNTHttpConnection head: NitroConnectionTestsStubURL withParams: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodHead );
    
    temp = [TNTHttpConnection head: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodHead );
    
    temp = [TNTHttpConnection head: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: self];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodHead );
    
    temp = [TNTHttpConnection head: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHttpMethod( temp.lastRequest, TNTHttpMethodHead );
}

-( void )test_head_methods_pass_params_in_query_string
{
    NSDictionary *params = @{ @"name": @"storm", @"mutant-power": @"weather change" };
    
    TNTHttpConnection *temp = [TNTHttpConnection head: NitroConnectionTestsStubURL withParams: params delegate: self];
    XCTAssertRequestQueryString( temp.lastRequest, params );
    
    temp = [TNTHttpConnection head: NitroConnectionTestsStubURL withParams: params onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestQueryString( temp.lastRequest, params );
    
    temp = [TNTHttpConnection head: NitroConnectionTestsStubURL withParams: params headers: nil delegate: self];
    XCTAssertRequestQueryString( temp.lastRequest, params );
    
    temp = [TNTHttpConnection head: NitroConnectionTestsStubURL withParams: params headers: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestQueryString( temp.lastRequest, params );
}

-( void )test_head_methods_send_headers
{
    NSDictionary *headers = @{ @"name": @"storm", @"mutant-power": @"weather change" };
    
    TNTHttpConnection *temp = [TNTHttpConnection head: NitroConnectionTestsStubURL withParams: nil headers: headers delegate: self];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
    
    temp = [TNTHttpConnection head: NitroConnectionTestsStubURL withParams: nil headers: headers onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
}

-( void )test_head_calls_delegate_on_start
{
    [self runAsyncCode: ^{ connection = [TNTHttpConnection head: NitroConnectionTestsStubURL delegate: self]; }
   andWaitForCondition: ^{ return delegateDidStartCalled; }];
    
    XCTAssertTrue( delegateDidStartCalled );
}

-( void )test_head_calls_delegate_on_success
{
    [self runAsyncCode: ^{ connection = [TNTHttpConnection head: NitroConnectionTestsStubURL delegate: self]; }
   andWaitForCondition: ^{ return delegateOnSuccessCalled; }];
    
    XCTAssertTrue( delegateOnSuccessCalled );
}

-( void )test_head_calls_delegate_on_error
{
    [self runAsyncCode: ^{ connection = [TNTHttpConnection head: NitroConnectionTestsStubErrorURL delegate: self]; }
   andWaitForCondition: ^{ return delegateOnErrorCalled; }];
    
    XCTAssertTrue( delegateOnErrorCalled );
}

-( void )test_head_calls_did_start_block_on_start
{
    [self runAsyncCode: ^{ connection = [TNTHttpConnection head: NitroConnectionTestsStubURL
                                                    onDidStart: ^{ didStartBlockRan = YES; }
                                                     onSuccess: nil
                                                       onError: nil]; }
   andWaitForCondition: ^{ return didStartBlockRan; }];
    
    XCTAssertTrue( didStartBlockRan );
}

-( void )test_head_calls_success_block_on_success
{
    [self runAsyncCode: ^{ connection = [TNTHttpConnection head: NitroConnectionTestsStubURL
                                                    onDidStart: nil
                                                     onSuccess: ^( NSHTTPURLResponse *response, NSData *data ) { onSuccessBlockRan = YES; }
                                                       onError: nil]; }
   andWaitForCondition: ^{ return onSuccessBlockRan; }];
    
    XCTAssertTrue( onSuccessBlockRan );
}

-( void )test_head_calls_error_block_on_error
{
    [self runAsyncCode: ^{ connection = [TNTHttpConnection head: NitroConnectionTestsStubErrorURL
                                                    onDidStart: nil
                                                     onSuccess: nil
                                                       onError: ^( NSError *error ) { onErrorBlockRan = YES; }]; }
   andWaitForCondition: ^{ return onErrorBlockRan; }];
    
    XCTAssertTrue( onErrorBlockRan );
}

#pragma mark - Http Delete

-( void )test_delete_methods_compile
{
    [TNTHttpConnection delete: NitroConnectionTestsStubURL delegate: nil];
    [TNTHttpConnection delete: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: nil delegate: self];
    [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: self];
    [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
}

-( void )test_delete_methods_use_http_delete
{
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
}

-( void )test_delete_methods_pass_params_in_query_string
{
    NSDictionary *params = @{ @"name": @"xavier", @"mutant-power": @"telepathy" };
    
    TNTHttpConnection *temp = [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: params delegate: self];
    XCTAssertRequestQueryString( temp.lastRequest, params );
    
    temp = [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: params onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestQueryString( temp.lastRequest, params );
    
    temp = [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: params headers: nil delegate: self];
    XCTAssertRequestQueryString( temp.lastRequest, params );
    
    temp = [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: params headers: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestQueryString( temp.lastRequest, params );
}

-( void )test_delete_methods_send_headers
{
    NSDictionary *headers = @{ @"name": @"xavier", @"mutant-power": @"telepathy" };
    
    TNTHttpConnection *temp = [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: nil headers: headers delegate: self];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
    
    temp = [TNTHttpConnection delete: NitroConnectionTestsStubURL withParams: nil headers: headers onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
}

-( void )test_delete_calls_delegate_on_start
{
    [self runAsyncCode: ^{ connection = [TNTHttpConnection delete: NitroConnectionTestsStubURL delegate: self]; }
   andWaitForCondition: ^{ return delegateDidStartCalled; }];
    
    XCTAssertTrue( delegateDidStartCalled );
}

-( void )test_delete_calls_delegate_on_success
{
    [self runAsyncCode: ^{ connection = [TNTHttpConnection delete: NitroConnectionTestsStubURL delegate: self]; }
   andWaitForCondition: ^{ return delegateOnSuccessCalled; }];
    
    XCTAssertTrue( delegateOnSuccessCalled );
}

-( void )test_delete_calls_delegate_on_error
{
    [self runAsyncCode: ^{ connection = [TNTHttpConnection delete: NitroConnectionTestsStubErrorURL delegate: self]; }
   andWaitForCondition: ^{ return delegateOnErrorCalled; }];
    
    XCTAssertTrue( delegateOnErrorCalled );
}

-( void )test_delete_calls_did_start_block_on_start
{
    [self runAsyncCode: ^{ connection = [TNTHttpConnection delete: NitroConnectionTestsStubURL
                                                     onDidStart: ^{ didStartBlockRan = YES; }
                                                      onSuccess: nil
                                                        onError: nil]; }
   andWaitForCondition: ^{ return didStartBlockRan; }];
    
    XCTAssertTrue( didStartBlockRan );
}

-( void )test_delete_calls_success_block_on_success
{
    [self runAsyncCode: ^{ connection = [TNTHttpConnection delete: NitroConnectionTestsStubURL
                                                     onDidStart: nil
                                                      onSuccess: ^( NSHTTPURLResponse *response, NSData *data ) { onSuccessBlockRan = YES; }
                                                        onError: nil]; }
   andWaitForCondition: ^{ return onSuccessBlockRan; }];
    
    XCTAssertTrue( onSuccessBlockRan );
}

-( void )test_delete_calls_error_block_on_error
{
    [self runAsyncCode: ^{ connection = [TNTHttpConnection delete: NitroConnectionTestsStubErrorURL
                                                     onDidStart: nil
                                                      onSuccess: nil
                                                        onError: ^( NSError *error ) { onErrorBlockRan = YES; }]; }
   andWaitForCondition: ^{ return onErrorBlockRan; }];
    
    XCTAssertTrue( onErrorBlockRan );
}

#pragma mark - Http Post

-( void )test_post_methods_compile
{
    [TNTHttpConnection post: NitroConnectionTestsStubURL delegate: nil];
    [TNTHttpConnection post: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: nil delegate: self];
    [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: self];
    [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
}

-( void )test_post_methods_use_http_post
{
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
}

-( void )test_post_methods_pass_params_in_http_body
{
    NSDictionary *params = @{ @"name": @"colossus", @"mutant-power": @"iron skin" };
    
    TNTHttpConnection *temp = [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: params delegate: self];
    XCTAssertRequestBody( temp.lastRequest, params );
    
    temp = [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: params onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestBody( temp.lastRequest, params );
    
    temp = [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: params headers: nil delegate: self];
    XCTAssertRequestBody( temp.lastRequest, params );
    
    temp = [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: params headers: nil onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestBody( temp.lastRequest, params );
}

-( void )test_post_methods_send_headers
{
    NSDictionary *headers = @{ @"name": @"colossus", @"mutant-power": @"iron skin" };
    
    TNTHttpConnection *temp = [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: nil headers: headers delegate: self];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
    
    temp = [TNTHttpConnection post: NitroConnectionTestsStubURL withParams: nil headers: headers onDidStart: nil onSuccess: nil onError: nil];
    XCTAssertRequestHeaders( temp.lastRequest, headers );
}

-( void )test_post_calls_delegate_on_start
{
    [self runAsyncCode: ^{ connection = [TNTHttpConnection post: NitroConnectionTestsStubURL delegate: self]; }
   andWaitForCondition: ^{ return delegateDidStartCalled; }];
    
    XCTAssertTrue( delegateDidStartCalled );
}

-( void )test_post_calls_delegate_on_success
{
    [self runAsyncCode: ^{ connection = [TNTHttpConnection post: NitroConnectionTestsStubURL delegate: self]; }
   andWaitForCondition: ^{ return delegateOnSuccessCalled; }];
    
    XCTAssertTrue( delegateOnSuccessCalled );
}

-( void )test_post_calls_delegate_on_error
{
    [self runAsyncCode: ^{ connection = [TNTHttpConnection post: NitroConnectionTestsStubErrorURL delegate: self]; }
   andWaitForCondition: ^{ return delegateOnErrorCalled; }];
    
    XCTAssertTrue( delegateOnErrorCalled );
}

-( void )test_post_calls_did_start_block_on_start
{
    [self runAsyncCode: ^{ connection = [TNTHttpConnection post: NitroConnectionTestsStubURL
                                                       onDidStart: ^{ didStartBlockRan = YES; }
                                                        onSuccess: nil
                                                          onError: nil]; }
   andWaitForCondition: ^{ return didStartBlockRan; }];
    
    XCTAssertTrue( didStartBlockRan );
}

-( void )test_post_calls_success_block_on_success
{
    [self runAsyncCode: ^{ connection = [TNTHttpConnection post: NitroConnectionTestsStubURL
                                                       onDidStart: nil
                                                        onSuccess: ^( NSHTTPURLResponse *response, NSData *data ) { onSuccessBlockRan = YES; }
                                                          onError: nil]; }
   andWaitForCondition: ^{ return onSuccessBlockRan; }];
    
    XCTAssertTrue( onSuccessBlockRan );
}

-( void )test_post_calls_error_block_on_error
{
    [self runAsyncCode: ^{ connection = [TNTHttpConnection post: NitroConnectionTestsStubErrorURL
                                                       onDidStart: nil
                                                        onSuccess: nil
                                                          onError: ^( NSError *error ) { onErrorBlockRan = YES; }]; }
   andWaitForCondition: ^{ return onErrorBlockRan; }];
    
    XCTAssertTrue( onErrorBlockRan );
}

#pragma mark - Http Put

-( void )test_put_methods_compile
{
    [TNTHttpConnection put: NitroConnectionTestsStubURL delegate: nil];
    [TNTHttpConnection put: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection put: NitroConnectionTestsStubURL withParams: nil delegate: self];
    [TNTHttpConnection put: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection put: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: self];
    [TNTHttpConnection put: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
}

#pragma mark - Http Patch

-( void )test_patch_methods_compile
{
    [TNTHttpConnection patch: NitroConnectionTestsStubURL delegate: nil];
    [TNTHttpConnection patch: NitroConnectionTestsStubURL onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection patch: NitroConnectionTestsStubURL withParams: nil delegate: self];
    [TNTHttpConnection patch: NitroConnectionTestsStubURL withParams: nil onDidStart: nil onSuccess: nil onError: nil];
    
    [TNTHttpConnection patch: NitroConnectionTestsStubURL withParams: nil headers: nil delegate: self];
    [TNTHttpConnection patch: NitroConnectionTestsStubURL withParams: nil headers: nil onDidStart: nil onSuccess: nil onError: nil];
}

#pragma mark - TNTHttpConnectionDelegate

-( void )onTNTHttpConnectionDidStart:( TNTHttpConnection * )connection
{
    delegateDidStartCalled = YES;
}

-( void )onTNTHttpConnection:( TNTHttpConnection * )connection didReceiveResponse:( NSHTTPURLResponse * )response withData:( NSData * )data
{
    delegateOnSuccessCalled = YES;
}

-( void )onTNTHttpConnection:( TNTHttpConnection * )connection didFailWithError:( NSError * )error
{
    delegateOnErrorCalled = YES;
}

@end















































