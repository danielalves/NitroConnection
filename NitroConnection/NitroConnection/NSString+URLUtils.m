//
//  NSString+URLUtils.m
//  NitroConnection
//
//  Created by Daniel L. Alves on 05/08/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import "NSString+URLUtils.h"

#pragma mark - Implementation

@implementation NSString( NitroConnection_URLUtils )

-( NSString* )urlEscapeUsingEncoding:( NSStringEncoding )encoding
{
	return ( __bridge_transfer NSString* )CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault,
                                                                                   ( __bridge CFStringRef )self,
                                                                                   NULL,
                                                                                   ( __bridge CFStringRef )@"!*'\"{}();:@&=+$,/?#[]% ",
                                                                                   CFStringConvertNSStringEncodingToEncoding( encoding ));
}

-( NSString* )urlUnescapeUsingEncoding:( NSStringEncoding )encoding
{
	return ( __bridge_transfer NSString* )CFURLCreateStringByReplacingPercentEscapesUsingEncoding( kCFAllocatorDefault,
                                                                                                   ( __bridge CFStringRef )self,
                                                                                                   CFSTR(""),
                                                                                                   CFStringConvertNSStringEncodingToEncoding( encoding ) );
}

@end
