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

#pragma mark - urlEncodeUsingEncoding: tests

-( void )test_urlEncodeUsingEncoding_encodes_spaces
{
    XCTAssertEqualObjects( [@"mega man" urlEncodeUsingEncoding: NSUTF8StringEncoding], @"mega%20man" );
}

-( void )test_urlEncodeUsingEncoding_encodes_asterisks
{
    XCTAssertEqualObjects( [@"cut*man" urlEncodeUsingEncoding: NSUTF8StringEncoding], @"cut%2Aman" );
}

-( void )test_urlEncodeUsingEncoding_encodes_exclamation_marks
{
    XCTAssertEqualObjects( [@"elec!man" urlEncodeUsingEncoding: NSUTF8StringEncoding], @"elec%21man" );
}

-( void )test_urlEncodeUsingEncoding_encodes_question_marks
{
    XCTAssertEqualObjects( [@"guts?man" urlEncodeUsingEncoding: NSUTF8StringEncoding], @"guts%3Fman" );
}

-( void )test_urlEncodeUsingEncoding_encodes_percent_signs
{
    XCTAssertEqualObjects( [@"bomb%man" urlEncodeUsingEncoding: NSUTF8StringEncoding], @"bomb%25man" );
}

-( void )test_urlEncodeUsingEncoding_encodes_dollar_signs
{
    XCTAssertEqualObjects( [@"ice$man" urlEncodeUsingEncoding: NSUTF8StringEncoding], @"ice%24man" );
}

-( void )test_urlEncodeUsingEncoding_encodes_number_signs
{
    XCTAssertEqualObjects( [@"fire#man" urlEncodeUsingEncoding: NSUTF8StringEncoding], @"fire%23man" );
}

-( void )test_urlEncodeUsingEncoding_encodes_at_signs
{
    XCTAssertEqualObjects( [@"bubble@man" urlEncodeUsingEncoding: NSUTF8StringEncoding], @"bubble%40man" );
}

-( void )test_urlEncodeUsingEncoding_encodes_ampersands
{
    XCTAssertEqualObjects( [@"quick&man" urlEncodeUsingEncoding: NSUTF8StringEncoding], @"quick%26man" );
}

-( void )test_urlEncodeUsingEncoding_encodes_plus_signs
{
    XCTAssertEqualObjects( [@"air+man" urlEncodeUsingEncoding: NSUTF8StringEncoding], @"air%2Bman" );
}

-( void )test_urlEncodeUsingEncoding_encodes_equal_signs
{
    XCTAssertEqualObjects( [@"metal=man" urlEncodeUsingEncoding: NSUTF8StringEncoding], @"metal%3Dman" );
}

-( void )test_urlEncodeUsingEncoding_encodes_colons
{
    XCTAssertEqualObjects( [@"wood:man" urlEncodeUsingEncoding: NSUTF8StringEncoding], @"wood%3Aman" );
}

-( void )test_urlEncodeUsingEncoding_encodes_semi_colons
{
    XCTAssertEqualObjects( [@"heat;man" urlEncodeUsingEncoding: NSUTF8StringEncoding], @"heat%3Bman" );
}

-( void )test_urlEncodeUsingEncoding_encodes_commas
{
    XCTAssertEqualObjects( [@"crash,man" urlEncodeUsingEncoding: NSUTF8StringEncoding], @"crash%2Cman" );
}

-( void )test_urlEncodeUsingEncoding_encodes_open_square_brackets
{
    XCTAssertEqualObjects( [@"flash[man" urlEncodeUsingEncoding: NSUTF8StringEncoding], @"flash%5Bman" );
}

-( void )test_urlEncodeUsingEncoding_encodes_close_square_brackets
{
    XCTAssertEqualObjects( [@"snake]man" urlEncodeUsingEncoding: NSUTF8StringEncoding], @"snake%5Dman" );
}

-( void )test_urlEncodeUsingEncoding_encodes_open_parentheses_brackets
{
    XCTAssertEqualObjects( [@"hard(man" urlEncodeUsingEncoding: NSUTF8StringEncoding], @"hard%28man" );
}

-( void )test_urlEncodeUsingEncoding_encodes_close_parentheses_brackets
{
    XCTAssertEqualObjects( [@"needle)man" urlEncodeUsingEncoding: NSUTF8StringEncoding], @"needle%29man" );
}

-( void )test_urlEncodeUsingEncoding_encodes_open_curly_brackets
{
    XCTAssertEqualObjects( [@"magnet{man" urlEncodeUsingEncoding: NSUTF8StringEncoding], @"magnet%7Bman" );
}

-( void )test_urlEncodeUsingEncoding_encodes_close_curly_brackets
{
    XCTAssertEqualObjects( [@"shadow}man" urlEncodeUsingEncoding: NSUTF8StringEncoding], @"shadow%7Dman" );
}

-( void )test_urlEncodeUsingEncoding_encodes_slashes
{
    XCTAssertEqualObjects( [@"gemini/man" urlEncodeUsingEncoding: NSUTF8StringEncoding], @"gemini%2Fman" );
}

-( void )test_urlEncodeUsingEncoding_encodes_backslashes
{
    XCTAssertEqualObjects( [@"spark\\man" urlEncodeUsingEncoding: NSUTF8StringEncoding], @"spark%5Cman" );
}

-( void )test_urlEncodeUsingEncoding_encodes_single_quotes
{
    XCTAssertEqualObjects( [@"top'man" urlEncodeUsingEncoding: NSUTF8StringEncoding], @"top%27man" );
}

-( void )test_urlEncodeUsingEncoding_encodes_double_quotes
{
    XCTAssertEqualObjects( [@"dr\"willy" urlEncodeUsingEncoding: NSUTF8StringEncoding], @"dr%22willy" );
}

#pragma mark - urlUnencodeUsingEncoding: tests

-( void )test_urlUnencodeUsingEncoding_unencodes_spaces
{
    XCTAssertEqualObjects( [@"mega%20man" urlUnencodeUsingEncoding: NSUTF8StringEncoding], @"mega man" );
}

-( void )test_urlUnencodeUsingEncoding_unencodes_asterisks
{
    XCTAssertEqualObjects( [@"cut%2Aman" urlUnencodeUsingEncoding: NSUTF8StringEncoding], @"cut*man" );
}

-( void )test_urlUnencodeUsingEncoding_unencodes_exclamation_marks
{
    XCTAssertEqualObjects( [@"elec%21man" urlUnencodeUsingEncoding: NSUTF8StringEncoding], @"elec!man" );
}

-( void )test_urlUnencodeUsingEncoding_unencodes_question_marks
{
    XCTAssertEqualObjects( [@"guts%3Fman" urlUnencodeUsingEncoding: NSUTF8StringEncoding], @"guts?man" );
}

-( void )test_urlUnencodeUsingEncoding_unencodes_percent_signs
{
    XCTAssertEqualObjects( [@"bomb%25man" urlUnencodeUsingEncoding: NSUTF8StringEncoding], @"bomb%man" );
}

-( void )test_urlUnencodeUsingEncoding_unencodes_dollar_signs
{
    XCTAssertEqualObjects( [@"ice%24man" urlUnencodeUsingEncoding: NSUTF8StringEncoding], @"ice$man" );
}

-( void )test_urlUnencodeUsingEncoding_unencodes_number_signs
{
    XCTAssertEqualObjects( [@"fire%23man" urlUnencodeUsingEncoding: NSUTF8StringEncoding], @"fire#man" );
}

-( void )test_urlUnencodeUsingEncoding_unencodes_at_signs
{
    XCTAssertEqualObjects( [@"bubble%40man" urlUnencodeUsingEncoding: NSUTF8StringEncoding], @"bubble@man" );
}

-( void )test_urlUnencodeUsingEncoding_unencodes_ampersands
{
    XCTAssertEqualObjects( [@"quick%26man" urlUnencodeUsingEncoding: NSUTF8StringEncoding], @"quick&man" );
}

-( void )test_urlUnencodeUsingEncoding_unencodes_plus_signs
{
    XCTAssertEqualObjects( [@"air%2Bman" urlUnencodeUsingEncoding: NSUTF8StringEncoding], @"air+man" );
}

-( void )test_urlUnencodeUsingEncoding_unencodes_equal_signs
{
    XCTAssertEqualObjects( [@"metal%3Dman" urlUnencodeUsingEncoding: NSUTF8StringEncoding], @"metal=man" );
}

-( void )test_urlUnencodeUsingEncoding_unencodes_colons
{
    XCTAssertEqualObjects( [@"wood%3Aman" urlUnencodeUsingEncoding: NSUTF8StringEncoding], @"wood:man" );
}

-( void )test_urlUnencodeUsingEncoding_unencodes_semi_colons
{
    XCTAssertEqualObjects( [@"heat%3Bman" urlUnencodeUsingEncoding: NSUTF8StringEncoding], @"heat;man" );
}

-( void )test_urlUnencodeUsingEncoding_unencodes_commas
{
    XCTAssertEqualObjects( [@"crash%2Cman" urlUnencodeUsingEncoding: NSUTF8StringEncoding], @"crash,man" );
}

-( void )test_urlUnencodeUsingEncoding_unencodes_open_square_brackets
{
    XCTAssertEqualObjects( [@"flash%5Bman" urlUnencodeUsingEncoding: NSUTF8StringEncoding], @"flash[man" );
}

-( void )test_urlUnencodeUsingEncoding_unencodes_close_square_brackets
{
    XCTAssertEqualObjects( [@"snake%5Dman" urlUnencodeUsingEncoding: NSUTF8StringEncoding], @"snake]man" );
}

-( void )test_urlUnencodeUsingEncoding_unencodes_open_parentheses_brackets
{
    XCTAssertEqualObjects( [@"hard%28man" urlUnencodeUsingEncoding: NSUTF8StringEncoding], @"hard(man" );
}

-( void )test_urlUnencodeUsingEncoding_unencodes_close_parentheses_brackets
{
    XCTAssertEqualObjects( [@"needle%29man" urlUnencodeUsingEncoding: NSUTF8StringEncoding], @"needle)man" );
}

-( void )test_urlUnencodeUsingEncoding_unencodes_open_curly_brackets
{
    XCTAssertEqualObjects( [@"magnet%7Bman" urlUnencodeUsingEncoding: NSUTF8StringEncoding], @"magnet{man" );
}

-( void )test_urlUnencodeUsingEncoding_unencodes_close_curly_brackets
{
    XCTAssertEqualObjects( [@"shadow%7Dman" urlUnencodeUsingEncoding: NSUTF8StringEncoding], @"shadow}man" );
}

-( void )test_urlUnencodeUsingEncoding_unencodes_slashes
{
    XCTAssertEqualObjects( [@"gemini%2Fman" urlUnencodeUsingEncoding: NSUTF8StringEncoding], @"gemini/man" );
}

-( void )test_urlUnencodeUsingEncoding_unencodes_backslashes
{
    XCTAssertEqualObjects( [@"spark%5Cman" urlUnencodeUsingEncoding: NSUTF8StringEncoding], @"spark\\man" );
}

-( void )test_urlUnencodeUsingEncoding_unencodes_single_quotes
{
    XCTAssertEqualObjects( [@"top%27man" urlUnencodeUsingEncoding: NSUTF8StringEncoding], @"top'man" );
}

-( void )test_urlUnencodeUsingEncoding_unencodes_double_quotes
{
    XCTAssertEqualObjects( [@"dr%22willy" urlUnencodeUsingEncoding: NSUTF8StringEncoding], @"dr\"willy" );
}

@end
