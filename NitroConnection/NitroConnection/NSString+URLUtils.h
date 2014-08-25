//
//  NSString+URLUtils.h
//  NitroConnection
//
//  Created by Daniel L. Alves on 05/08/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString( NitroConnection_URLUtils )

/**
 *  Returns an escaped url string. The list of characters that will be escaped follows:
 *  '!', '*', ''', '\', '"', '{', '}', '(', ')', ';', ':', '@', '&', '=', 
 *  '+', '$', ',', '/', '?', '#', '[', ']', '%', ' '
 *
 *  @param encoding The encoding of the resulting string
 *
 *  @return An url escaped string
 */
-( NSString* )urlEscapeUsingEncoding:( NSStringEncoding )encoding;

/**
 *  Returns an unescaped url string. The list of characters that will be unescaped follows:
 *  '!', '*', ''', '\', '"', '{', '}', '(', ')', ';', ':', '@', '&', '=',
 *  '+', '$', ',', '/', '?', '#', '[', ']', '%', ' '
 *
 *  @param encoding The encoding of the resulting string
 *
 *  @return An url unescaped string
 */
-( NSString* )urlUnescapeUsingEncoding:( NSStringEncoding )encoding;

@end
