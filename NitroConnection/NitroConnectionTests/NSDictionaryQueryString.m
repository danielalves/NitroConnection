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
    
    // NSDictionary is not ordered, that's why the query string may be in a different order from the dictionary initialization
    leonidas[ @"profession" ] = @"AH-UH! AH-UH! AH-UH!";

    NSArray *possibilities = @[ @"name=Leonidas&profession=AH-UH%21%20AH-UH%21%20AH-UH%21",
                                @"profession=AH-UH%21%20AH-UH%21%20AH-UH%21&name=Leonidas" ];
    
    XCTAssertTrue( [possibilities containsObject: leonidas.toQueryString] );
    
    
    // NSDictionary is not ordered, that's why the query string may be in a different order from the dictionary initialization
    leonidas[@"favorite movie"] = @"300";
    
    possibilities = @[ @"favorite%20movie=300&name=Leonidas&profession=AH-UH%21%20AH-UH%21%20AH-UH%21",
                       @"favorite%20movie=300&profession=AH-UH%21%20AH-UH%21%20AH-UH%21&name=Leonidas",
                       @"name=Leonidas&profession=AH-UH%21%20AH-UH%21%20AH-UH%21&favorite%20movie=300",
                       @"name=Leonidas&favorite%20movie=300&profession=AH-UH%21%20AH-UH%21%20AH-UH%21",
                       @"profession=AH-UH%21%20AH-UH%21%20AH-UH%21&name=Leonidas&favorite%20movie=300",
                       @"profession=AH-UH%21%20AH-UH%21%20AH-UH%21&favorite%20movie=300&name=Leonidas" ];
    
    XCTAssertTrue( [possibilities containsObject: leonidas.toQueryString] );
}

-( void )test_toQueryString_works_with_non_string_keys
{
    NSDictionary *numbers = @{ @1: @"Ring",
                               @3: @"Musketeers",
                               @5: @"Fingers Death Punch" };
    
    // NSDictionary is not ordered, that's why the query string may be in a different order from the dictionary initialization
    NSArray *possibilities = @[ @"5=Fingers%20Death%20Punch&3=Musketeers&1=Ring",
                                @"5=Fingers%20Death%20Punch&1=Ring&3=Musketeers",
                                @"3=Musketeers&5=Fingers%20Death%20Punch&1=Ring",
                                @"3=Musketeers&1=Ring&5=Fingers%20Death%20Punch",
                                @"1=Ring&3=Musketeers&5=Fingers%20Death%20Punch",
                                @"1=Ring&5=Fingers%20Death%20Punch&3=Musketeers" ];
    
    XCTAssertTrue( [possibilities containsObject: numbers.toQueryString] );
}

-( void )test_toQueryString_returns_empty_strings_on_empty_dictionaries
{
    XCTAssertEqualObjects( @{}.toQueryString, @"" );
}

@end