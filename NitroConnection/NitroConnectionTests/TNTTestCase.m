//
//  TNTTestCase.m
//  NitroConnectionTests
//
//  Created by Daniel L. Alves on 7/8/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import "TNTTestCase.h"

// NitroMisc
#import "TNTXCTTestMacros.h"

#pragma mark - Class Extension

@interface TNTTestCase()
{
    dispatch_semaphore_t _networkSemaphore;
    BOOL _didTimeout;
}
@end

#pragma mark - Implementation

@implementation TNTTestCase

-( void )waitForAsyncCode:( void(^)( void ))asyncCode
{
    XCTFailIfParameterNil( asyncCode );
    
    [self beginAsyncOperation];
    
    asyncCode();
    
    [self assertAsyncOperationTimeout];
}

-( void )beginAsyncOperation
{
    _didTimeout = NO;
    _networkSemaphore = dispatch_semaphore_create(0);
}

-( void )finishedAsyncOperation
{
    _didTimeout = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeoutAsyncOperation) object:nil];
    dispatch_semaphore_signal(_networkSemaphore);
}

-( BOOL )waitForAsyncOperationOrTimeoutWithDefaultInterval
{
    return [self waitForAsyncOperationOrTimeoutWithInterval: 6];
}

-( BOOL )waitForAsyncOperationOrTimeoutWithInterval:(NSTimeInterval)interval
{
    [self performSelector:@selector(timeoutAsyncOperation) withObject:nil afterDelay:interval];
    // wait for the semaphore to be signaled (triggered)
    while (dispatch_semaphore_wait(_networkSemaphore, DISPATCH_TIME_NOW))
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:3]];
    }
    return _didTimeout;
}

-( void )timeoutAsyncOperation
{
    _didTimeout = YES;
    dispatch_semaphore_signal(_networkSemaphore);
}

-( void )assertAsyncOperationTimeout
{
    XCTAssertFalse([self waitForAsyncOperationOrTimeoutWithDefaultInterval], @"timed out");
}

@end
