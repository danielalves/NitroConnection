//
//  NSDictionaryQueryString.m
//  NitroConnectionTests
//
//  Created by Daniel L. Alves on 13/8/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import <XCTest/XCTest.h>

// NitroConnection
#import "NSDictionary+QueryString.h"

@interface NSDictionaryQueryString : XCTestCase

@end

@implementation NSDictionaryQueryString

#pragma mark - toQueryString tests

-( void )test_toQueryString_returns_well_formatted_query_string
{
    NSMutableDictionary *leonidas = [NSMutableDictionary dictionaryWithDictionary: @{ @"name": @"Leonidas" }];
    XCTAssertEqualObjects( leonidas.toQueryString, @"name=Leonidas" );
    
    leonidas[ @"profession" ] = @"AH-UH! AH-UH! AH-UH!";
    XCTAssertEqualObjects( leonidas.toQueryString, @"name=Leonidas&profession=AH-UH%21%20AH-UH%21%20AH-UH%21" );
    
    // NSDictionary is not ordered, that's why the query string may be in a different order from the dictionary initialization
    leonidas[@"favorite movie"] = @"300";
    XCTAssertEqualObjects( leonidas.toQueryString, @"favorite%20movie=300&name=Leonidas&profession=AH-UH%21%20AH-UH%21%20AH-UH%21" );
}

-( void )test_toQueryString_works_with_non_string_keys
{
    NSDictionary *numbers = @{ @1: @"Ring",
                               @2: @"Faces",
                               @3: @"Musketeers",
                               @4: @"Four Swords Adventures",
                               @5: @"Fingers Death Punch" };
    
    // NSDictionary is not ordered, that's why the query string may be in a different order from the dictionary initialization
    XCTAssertEqualObjects( numbers.toQueryString, @"4=Four%20Swords%20Adventures&5=Fingers%20Death%20Punch&3=Musketeers&1=Ring&2=Faces" );
}

-( void )test_toQueryString_returns_empty_strings_on_empty_dictionaries
{
    XCTAssertEqualObjects( @{}.toQueryString, @"" );
}

@end