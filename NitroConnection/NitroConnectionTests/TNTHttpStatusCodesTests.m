//
//  TNTHttpStatusCodesTests.m
//  NitroConnectionTests
//
//  Created by Daniel L. Alves on 30/07/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import <XCTest/XCTest.h>

// NitroConnection
#import "TNTHttpStatusCodes.h"

@interface TNTHttpStatusCodesTests : XCTestCase

@end

@implementation TNTHttpStatusCodesTests

#pragma mark - Informational status codes tests

-( void )test_informational_status_codes_are_correct
{
    XCTAssertEqual( TNTHttpStatusCodeContinue, 100 );
    XCTAssertEqual( TNTHttpStatusCodeSwitchingProtocols, 101 );
}

#pragma mark - Successful status codes tests

-( void )test_successful_status_codes_are_correct
{
    XCTAssertEqual( TNTHttpStatusCodeOk, 200 );
    XCTAssertEqual( TNTHttpStatusCodeCreated, 201 );
    XCTAssertEqual( TNTHttpStatusCodeAccepted, 202 );
    XCTAssertEqual( TNTHttpStatusCodeNonAuthoritativeInformation, 203 );
    XCTAssertEqual( TNTHttpStatusCodeNoContent, 204 );
    XCTAssertEqual( TNTHttpStatusCodeResetContent, 205 );
    XCTAssertEqual( TNTHttpStatusCodePartialContent, 206 );
}

#pragma mark - Redirection status codes tests

-( void )test_redirection_status_codes_are_correct
{
    XCTAssertEqual( TNTHttpStatusCodeMultipleChoices, 300 );
    XCTAssertEqual( TNTHttpStatusCodeMovedPermanently, 301 );
    XCTAssertEqual( TNTHttpStatusCodeFound, 302 );
    XCTAssertEqual( TNTHttpStatusCodeSeeOther, 303 );
    XCTAssertEqual( TNTHttpStatusCodeNotModified, 304 );
    XCTAssertEqual( TNTHttpStatusCodeUseProxy, 305 );
    XCTAssertEqual( TNTHttpStatusCodeTemporaryRedirect, 307 );
}

#pragma mark - Client error status codes tests

-( void )test_client_error_status_codes_are_correct
{
    XCTAssertEqual( TNTHttpStatusCodeBadRequest, 400 );
    XCTAssertEqual( TNTHttpStatusCodeUnauthorized, 401 );
    XCTAssertEqual( TNTHttpStatusCodePaymentRequired, 402 );
    XCTAssertEqual( TNTHttpStatusCodeForbidden, 403 );
    XCTAssertEqual( TNTHttpStatusCodeNotFound, 404 );
    XCTAssertEqual( TNTHttpStatusCodeMethodNotAllowed, 405 );
    XCTAssertEqual( TNTHttpStatusCodeNotAcceptable, 406 );
    XCTAssertEqual( TNTHttpStatusCodeProxyAuthenticationRequired, 407 );
    XCTAssertEqual( TNTHttpStatusCodeRequestTimeout, 408 );
    XCTAssertEqual( TNTHttpStatusCodeConflict, 409 );
    XCTAssertEqual( TNTHttpStatusCodeGone, 410 );
    XCTAssertEqual( TNTHttpStatusCodeLengthRequired, 411 );
    XCTAssertEqual( TNTHttpStatusCodePreconditionFailed, 412 );
    XCTAssertEqual( TNTHttpStatusCodeRequestEntityTooLarge, 413 );
    XCTAssertEqual( TNTHttpStatusCodeRequestURITooLong, 414 );
    XCTAssertEqual( TNTHttpStatusCodeUnsupportedMediaType, 415 );
    XCTAssertEqual( TNTHttpStatusCodeRequestedRangeNotSatisfiable, 416 );
    XCTAssertEqual( TNTHttpStatusCodeExpectationFailed, 417 );
}

#pragma mark - Server error status codes tests

-( void )test_server_error_status_codes_are_correct
{
    XCTAssertEqual( TNTHttpStatusCodeInternalServerError, 500 );
    XCTAssertEqual( TNTHttpStatusCodeNotImplemented, 501 );
    XCTAssertEqual( TNTHttpStatusCodeBadGateway, 502 );
    XCTAssertEqual( TNTHttpStatusCodeServiceUnavailable, 503 );
    XCTAssertEqual( TNTHttpStatusCodeGatewayTimeout, 504 );
    XCTAssertEqual( TNTHttpStatusCodeHTTPVersionNotSupported, 505 );
}

#pragma mark - IS_HTTP_STATUS_INFORMATIONAL tests

-( void )test_IS_HTTP_STATUS_INFORMATIONAL_returns_if_status_code_is_informational
{
    XCTAssertTrue(IS_HTTP_STATUS_INFORMATIONAL(100));
    XCTAssertTrue(IS_HTTP_STATUS_INFORMATIONAL(150));
    XCTAssertTrue(IS_HTTP_STATUS_INFORMATIONAL(199));
    
    XCTAssertFalse(IS_HTTP_STATUS_INFORMATIONAL(99));
    XCTAssertFalse(IS_HTTP_STATUS_INFORMATIONAL(200));
}

#pragma mark - IS_HTTP_STATUS_SUCCESS tests

-( void )test_IS_HTTP_STATUS_SUCCESS_returns_if_status_code_is_success
{
    XCTAssertTrue(IS_HTTP_STATUS_SUCCESS(200));
    XCTAssertTrue(IS_HTTP_STATUS_SUCCESS(250));
    XCTAssertTrue(IS_HTTP_STATUS_SUCCESS(299));
    
    XCTAssertFalse(IS_HTTP_STATUS_SUCCESS(199));
    XCTAssertFalse(IS_HTTP_STATUS_SUCCESS(300));
}

#pragma mark - IS_HTTP_STATUS_REDIRECTION tests

-( void )test_IS_HTTP_STATUS_REDIRECTION_returns_if_status_code_is_success
{
    XCTAssertTrue(IS_HTTP_STATUS_REDIRECTION(300));
    XCTAssertTrue(IS_HTTP_STATUS_REDIRECTION(350));
    XCTAssertTrue(IS_HTTP_STATUS_REDIRECTION(399));
    
    XCTAssertFalse(IS_HTTP_STATUS_REDIRECTION(299));
    XCTAssertFalse(IS_HTTP_STATUS_REDIRECTION(400));
}

#pragma mark - IS_HTTP_STATUS_CLIENT_ERROR tests

-( void )test_IS_HTTP_STATUS_CLIENT_ERROR_returns_if_status_code_is_success
{
    XCTAssertTrue(IS_HTTP_STATUS_CLIENT_ERROR(400));
    XCTAssertTrue(IS_HTTP_STATUS_CLIENT_ERROR(450));
    XCTAssertTrue(IS_HTTP_STATUS_CLIENT_ERROR(499));
    
    XCTAssertFalse(IS_HTTP_STATUS_CLIENT_ERROR(399));
    XCTAssertFalse(IS_HTTP_STATUS_CLIENT_ERROR(500));
}

#pragma mark - IS_HTTP_STATUS_SERVER_ERROR tests

-( void )test_IS_HTTP_STATUS_SERVER_ERROR_returns_if_status_code_is_success
{
    XCTAssertTrue(IS_HTTP_STATUS_SERVER_ERROR(500));
    XCTAssertTrue(IS_HTTP_STATUS_SERVER_ERROR(550));
    XCTAssertTrue(IS_HTTP_STATUS_SERVER_ERROR(599));
    
    XCTAssertFalse(IS_HTTP_STATUS_SERVER_ERROR(499));
    XCTAssertFalse(IS_HTTP_STATUS_SERVER_ERROR(600));
}

@end
