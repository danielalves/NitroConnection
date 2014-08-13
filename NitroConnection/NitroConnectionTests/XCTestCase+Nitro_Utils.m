//
//  XCTestCase+Nitro_Utils.m
//  NitroConnectionTests
//
//  Created by Daniel L. Alves on 7/8/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import "XCTestCase+Nitro_Utils.h"

// NitroMisc
#import "TNTXCTTestMacros.h"

#pragma mark - Implementation

@implementation XCTestCase( Nitro_Utils )

-( void )runAsyncCode:( void(^)( void ) )asyncCodeBlock andWaitForCondition:( BOOL(^)( void ) )condition
{
    [self runAsyncCode: asyncCodeBlock andWaitForCondition: condition maxTries: 5];
}

-( void )runAsyncCode:( void(^)( void ) )asyncCodeBlock andWaitForCondition:( BOOL(^)( void ) )condition maxTries:( NSInteger )maxTries
{
    XCTFailIfParameterNil( asyncCodeBlock );
    XCTFailIfParameterNil( condition );
    
    NSOperationQueue *helperOperationQueue = [NSOperationQueue new];
    helperOperationQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
    helperOperationQueue.name = [NSString stringWithFormat: @"XCTestCaseAsynCodeHelperQueue_%p", self];
    
    // Fire the async code from a queue other than the main queue, so we can
    // get its response on the former. This way we can wait for the async code
    // on the main queue, which is where the tests run
    [helperOperationQueue addOperationWithBlock: ^{
        asyncCodeBlock();
    }];
    
    // Wait a little longer in case we broke the loop because
    // counter reached its max value
    [helperOperationQueue waitUntilAllOperationsAreFinished];
    
    // Wait for the async code to run
    NSInteger counter = 0;
    while( !condition() )
    {
        [NSThread sleepForTimeInterval: 0.5];
        if( counter++ > maxTries )
            break;
    }
    
    // Wait a little longer in case we broke the loop because
    // counter reached its max value
    [helperOperationQueue waitUntilAllOperationsAreFinished];
}

@end
