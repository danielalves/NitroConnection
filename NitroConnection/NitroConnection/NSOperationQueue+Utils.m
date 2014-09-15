//
//  NSOperationQueue+Utils.m
//  NitroConnection
//
//  Created by Daniel L. Alves on 15/9/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import "NSOperationQueue+Utils.h"

#pragma mark - Implementation

@implementation NSOperationQueue( Utils_NitroConnection )

-( void )waitUntilOperationFinished:( NSOperation * )operation
{
    [self addOperations: @[ operation ] waitUntilFinished: YES];
}

-( void )waitUntilBlockFinished:( void (^)( void ))operationBlock
{
    [self waitUntilOperationFinished: [NSBlockOperation blockOperationWithBlock: operationBlock]];
}

@end
