//
//  NSOperationQueue+Utils.h
//  NitroConnection
//
//  Created by Daniel L. Alves on 15/9/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOperationQueue( Utils_NitroConnection )

-( void )waitUntilOperationFinished:( NSOperation * )operation;
-( void )waitUntilBlockFinished:( void (^)( void ))operationBlock;

@end
