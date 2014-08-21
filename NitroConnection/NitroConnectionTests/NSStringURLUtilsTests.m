//
//  NSStringURLUtilsTests.m
//  NitroConnectionTests
//
//  Created by Daniel L. Alves on 30/07/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import <XCTest/XCTest.h>

// NitroConnection
#import "NSString+URLUtils.h"

@interface NSStringURLUtilsTests : XCTestCase

@end

@implementation NSStringURLUtilsTests

#pragma mark - urlEscapeUsingEncoding: tests

-( void )test_urlEscapeUsingEncoding_encodes_spaces
{
    XCTAssertEqualObjects( [@"mega man" urlEscapeUsingEncoding: NSUTF8StringEncoding], @"mega%20man" );
}

-( void )test_urlEscapeUsingEncoding_encodes_asterisks
{
    XCTAssertEqualObjects( [@"cut*man" urlEscapeUsingEncoding: NSUTF8StringEncoding], @"cut%2Aman" );
}

-( void )test_urlEscapeUsingEncoding_encodes_exclamation_marks
{
    XCTAssertEqualObjects( [@"elec!man" urlEscapeUsingEncoding: NSUTF8StringEncoding], @"elec%21man" );
}

-( void )test_urlEscapeUsingEncoding_encodes_question_marks
{
    XCTAssertEqualObjects( [@"guts?man" urlEscapeUsingEncoding: NSUTF8StringEncoding], @"guts%3Fman" );
}

-( void )test_urlEscapeUsingEncoding_encodes_percent_signs
{
    XCTAssertEqualObjects( [@"bomb%man" urlEscapeUsingEncoding: NSUTF8StringEncoding], @"bomb%25man" );
}

-( void )test_urlEscapeUsingEncoding_encodes_dollar_signs
{
    XCTAssertEqualObjects( [@"ice$man" urlEscapeUsingEncoding: NSUTF8StringEncoding], @"ice%24man" );
}

-( void )test_urlEscapeUsingEncoding_encodes_number_signs
{
    XCTAssertEqualObjects( [@"fire#man" urlEscapeUsingEncoding: NSUTF8StringEncoding], @"fire%23man" );
}

-( void )test_urlEscapeUsingEncoding_encodes_at_signs
{
    XCTAssertEqualObjects( [@"bubble@man" urlEscapeUsingEncoding: NSUTF8StringEncoding], @"bubble%40man" );
}

-( void )test_urlEscapeUsingEncoding_encodes_ampersands
{
    XCTAssertEqualObjects( [@"quick&man" urlEscapeUsingEncoding: NSUTF8StringEncoding], @"quick%26man" );
}

-( void )test_urlEscapeUsingEncoding_encodes_plus_signs
{
    XCTAssertEqualObjects( [@"air+man" urlEscapeUsingEncoding: NSUTF8StringEncoding], @"air%2Bman" );
}

-( void )test_urlEscapeUsingEncoding_encodes_equal_signs
{
    XCTAssertEqualObjects( [@"metal=man" urlEscapeUsingEncoding: NSUTF8StringEncoding], @"metal%3Dman" );
}

-( void )test_urlEscapeUsingEncoding_encodes_colons
{
    XCTAssertEqualObjects( [@"wood:man" urlEscapeUsingEncoding: NSUTF8StringEncoding], @"wood%3Aman" );
}

-( void )test_urlEscapeUsingEncoding_encodes_semi_colons
{
    XCTAssertEqualObjects( [@"heat;man" urlEscapeUsingEncoding: NSUTF8StringEncoding], @"heat%3Bman" );
}

-( void )test_urlEscapeUsingEncoding_encodes_commas
{
    XCTAssertEqualObjects( [@"crash,man" urlEscapeUsingEncoding: NSUTF8StringEncoding], @"crash%2Cman" );
}

-( void )test_urlEscapeUsingEncoding_encodes_open_square_brackets
{
    XCTAssertEqualObjects( [@"flash[man" urlEscapeUsingEncoding: NSUTF8StringEncoding], @"flash%5Bman" );
}

-( void )test_urlEscapeUsingEncoding_encodes_close_square_brackets
{
    XCTAssertEqualObjects( [@"snake]man" urlEscapeUsingEncoding: NSUTF8StringEncoding], @"snake%5Dman" );
}

-( void )test_urlEscapeUsingEncoding_encodes_open_parentheses_brackets
{
    XCTAssertEqualObjects( [@"hard(man" urlEscapeUsingEncoding: NSUTF8StringEncoding], @"hard%28man" );
}

-( void )test_urlEscapeUsingEncoding_encodes_close_parentheses_brackets
{
    XCTAssertEqualObjects( [@"needle)man" urlEscapeUsingEncoding: NSUTF8StringEncoding], @"needle%29man" );
}

-( void )test_urlEscapeUsingEncoding_encodes_open_curly_brackets
{
    XCTAssertEqualObjects( [@"magnet{man" urlEscapeUsingEncoding: NSUTF8StringEncoding], @"magnet%7Bman" );
}

-( void )test_urlEscapeUsingEncoding_encodes_close_curly_brackets
{
    XCTAssertEqualObjects( [@"shadow}man" urlEscapeUsingEncoding: NSUTF8StringEncoding], @"shadow%7Dman" );
}

-( void )test_urlEscapeUsingEncoding_encodes_slashes
{
    XCTAssertEqualObjects( [@"gemini/man" urlEscapeUsingEncoding: NSUTF8StringEncoding], @"gemini%2Fman" );
}

-( void )test_urlEscapeUsingEncoding_encodes_backslashes
{
    XCTAssertEqualObjects( [@"spark\\man" urlEscapeUsingEncoding: NSUTF8StringEncoding], @"spark%5Cman" );
}

-( void )test_urlEscapeUsingEncoding_encodes_single_quotes
{
    XCTAssertEqualObjects( [@"top'man" urlEscapeUsingEncoding: NSUTF8StringEncoding], @"top%27man" );
}

-( void )test_urlEscapeUsingEncoding_encodes_double_quotes
{
    XCTAssertEqualObjects( [@"dr\"willy" urlEscapeUsingEncoding: NSUTF8StringEncoding], @"dr%22willy" );
}

#pragma mark - urlUnescapeUsingEncoding: tests

-( void )test_urlUnescapeUsingEncoding_unencodes_spaces
{
    XCTAssertEqualObjects( [@"mega%20man" urlUnescapeUsingEncoding: NSUTF8StringEncoding], @"mega man" );
}

-( void )test_urlUnescapeUsingEncoding_unencodes_asterisks
{
    XCTAssertEqualObjects( [@"cut%2Aman" urlUnescapeUsingEncoding: NSUTF8StringEncoding], @"cut*man" );
}

-( void )test_urlUnescapeUsingEncoding_unencodes_exclamation_marks
{
    XCTAssertEqualObjects( [@"elec%21man" urlUnescapeUsingEncoding: NSUTF8StringEncoding], @"elec!man" );
}

-( void )test_urlUnescapeUsingEncoding_unencodes_question_marks
{
    XCTAssertEqualObjects( [@"guts%3Fman" urlUnescapeUsingEncoding: NSUTF8StringEncoding], @"guts?man" );
}

-( void )test_urlUnescapeUsingEncoding_unencodes_percent_signs
{
    XCTAssertEqualObjects( [@"bomb%25man" urlUnescapeUsingEncoding: NSUTF8StringEncoding], @"bomb%man" );
}

-( void )test_urlUnescapeUsingEncoding_unencodes_dollar_signs
{
    XCTAssertEqualObjects( [@"ice%24man" urlUnescapeUsingEncoding: NSUTF8StringEncoding], @"ice$man" );
}

-( void )test_urlUnescapeUsingEncoding_unencodes_number_signs
{
    XCTAssertEqualObjects( [@"fire%23man" urlUnescapeUsingEncoding: NSUTF8StringEncoding], @"fire#man" );
}

-( void )test_urlUnescapeUsingEncoding_unencodes_at_signs
{
    XCTAssertEqualObjects( [@"bubble%40man" urlUnescapeUsingEncoding: NSUTF8StringEncoding], @"bubble@man" );
}

-( void )test_urlUnescapeUsingEncoding_unencodes_ampersands
{
    XCTAssertEqualObjects( [@"quick%26man" urlUnescapeUsingEncoding: NSUTF8StringEncoding], @"quick&man" );
}

-( void )test_urlUnescapeUsingEncoding_unencodes_plus_signs
{
    XCTAssertEqualObjects( [@"air%2Bman" urlUnescapeUsingEncoding: NSUTF8StringEncoding], @"air+man" );
}

-( void )test_urlUnescapeUsingEncoding_unencodes_equal_signs
{
    XCTAssertEqualObjects( [@"metal%3Dman" urlUnescapeUsingEncoding: NSUTF8StringEncoding], @"metal=man" );
}

-( void )test_urlUnescapeUsingEncoding_unencodes_colons
{
    XCTAssertEqualObjects( [@"wood%3Aman" urlUnescapeUsingEncoding: NSUTF8StringEncoding], @"wood:man" );
}

-( void )test_urlUnescapeUsingEncoding_unencodes_semi_colons
{
    XCTAssertEqualObjects( [@"heat%3Bman" urlUnescapeUsingEncoding: NSUTF8StringEncoding], @"heat;man" );
}

-( void )test_urlUnescapeUsingEncoding_unencodes_commas
{
    XCTAssertEqualObjects( [@"crash%2Cman" urlUnescapeUsingEncoding: NSUTF8StringEncoding], @"crash,man" );
}

-( void )test_urlUnescapeUsingEncoding_unencodes_open_square_brackets
{
    XCTAssertEqualObjects( [@"flash%5Bman" urlUnescapeUsingEncoding: NSUTF8StringEncoding], @"flash[man" );
}

-( void )test_urlUnescapeUsingEncoding_unencodes_close_square_brackets
{
    XCTAssertEqualObjects( [@"snake%5Dman" urlUnescapeUsingEncoding: NSUTF8StringEncoding], @"snake]man" );
}

-( void )test_urlUnescapeUsingEncoding_unencodes_open_parentheses_brackets
{
    XCTAssertEqualObjects( [@"hard%28man" urlUnescapeUsingEncoding: NSUTF8StringEncoding], @"hard(man" );
}

-( void )test_urlUnescapeUsingEncoding_unencodes_close_parentheses_brackets
{
    XCTAssertEqualObjects( [@"needle%29man" urlUnescapeUsingEncoding: NSUTF8StringEncoding], @"needle)man" );
}

-( void )test_urlUnescapeUsingEncoding_unencodes_open_curly_brackets
{
    XCTAssertEqualObjects( [@"magnet%7Bman" urlUnescapeUsingEncoding: NSUTF8StringEncoding], @"magnet{man" );
}

-( void )test_urlUnescapeUsingEncoding_unencodes_close_curly_brackets
{
    XCTAssertEqualObjects( [@"shadow%7Dman" urlUnescapeUsingEncoding: NSUTF8StringEncoding], @"shadow}man" );
}

-( void )test_urlUnescapeUsingEncoding_unencodes_slashes
{
    XCTAssertEqualObjects( [@"gemini%2Fman" urlUnescapeUsingEncoding: NSUTF8StringEncoding], @"gemini/man" );
}

-( void )test_urlUnescapeUsingEncoding_unencodes_backslashes
{
    XCTAssertEqualObjects( [@"spark%5Cman" urlUnescapeUsingEncoding: NSUTF8StringEncoding], @"spark\\man" );
}

-( void )test_urlUnescapeUsingEncoding_unencodes_single_quotes
{
    XCTAssertEqualObjects( [@"top%27man" urlUnescapeUsingEncoding: NSUTF8StringEncoding], @"top'man" );
}

-( void )test_urlUnescapeUsingEncoding_unencodes_double_quotes
{
    XCTAssertEqualObjects( [@"dr%22willy" urlUnescapeUsingEncoding: NSUTF8StringEncoding], @"dr\"willy" );
}

@end
