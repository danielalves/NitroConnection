//
//  TNTHttpMethodsTests.m
//  NitroConnectionTests
//
//  Created by Daniel L. Alves on 30/07/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import <XCTest/XCTest.h>

// NitroConnection
#import "TNTHttpMethods.h"

@interface TNTHttpMethodsTests : XCTestCase

@end

@implementation TNTHttpMethodsTests

#pragma mark - stringFromHttpMethod: tests

-( void )test_stringFromHttpMethod_converts_HttpMethod_to_string
{
    XCTAssertEqualObjects( [NSString stringFromHttpMethod: TNTHttpMethodGet], @"GET" );
    XCTAssertEqualObjects( [NSString stringFromHttpMethod: TNTHttpMethodHead], @"HEAD" );
    XCTAssertEqualObjects( [NSString stringFromHttpMethod: TNTHttpMethodDelete], @"DELETE" );
    XCTAssertEqualObjects( [NSString stringFromHttpMethod: TNTHttpMethodPost], @"POST" );
    XCTAssertEqualObjects( [NSString stringFromHttpMethod: TNTHttpMethodPut], @"PUT" );
    XCTAssertEqualObjects( [NSString stringFromHttpMethod: TNTHttpMethodPatch], @"PATCH" );
}

@end
