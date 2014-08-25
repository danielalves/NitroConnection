//
//  TNTTestCase.h
//  NitroConnectionTests
//
//  Created by Daniel L. Alves on 7/8/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import <XCTest/XCTest.h>

/**
 *  Based on CBAsyncTestCase
 *  @see https://gist.github.com/cbess/5843930
 *  @see https://github.com/cbess/CBAsyncTestCase
 */
@interface TNTTestCase : XCTestCase

-( void )waitForAsyncCode:( void(^)( void ))asyncCode;
-( void )finishedAsyncOperation;

@end
