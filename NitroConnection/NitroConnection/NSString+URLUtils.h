//
//  NSString+URLUtils.h
//  NitroConnection
//
//  Created by Daniel L. Alves on 05/08/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString( NitroConnection_URLUtils )

-( NSString* )urlEncodeUsingEncoding:( NSStringEncoding )encoding;
-( NSString* )urlUnencodeUsingEncoding:( NSStringEncoding )encoding;

@end
