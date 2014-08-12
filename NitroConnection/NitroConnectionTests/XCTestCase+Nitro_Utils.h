//
//  XCTestCase+Nitro_Utils.h
//  NitroMisc
//
//  Created by Daniel L. Alves on 7/8/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XCTestCase( Nitro_Utils )

-( void )runAsyncCode:( void(^)( void ) )asyncCodeBlock andWaitForCondition:( BOOL(^)( void ) )condition;

-( void )runAsyncCode:( void(^)( void ) )asyncCodeBlock andWaitForCondition:( BOOL(^)( void ) )condition maxTries:( NSInteger )maxTries;

@end
