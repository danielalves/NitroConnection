//
//  NSDictionary+QueryString.m
//  NitroConnection
//
//  Created by Daniel L. Alves on 06/08/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import "NSDictionary+QueryString.h"

// NitroConnection
#import "NSString+URLUtils.h"

#pragma mark - Implementation

@implementation NSDictionary( QueryString )

-( NSString * )toQueryString
{
    NSMutableArray *params = [NSMutableArray arrayWithCapacity: self.count];
    
    for( id key in self.allKeys )
    {
        NSString *keyStr = [key description];
        NSString *valueStr = [self[key] description];
        
        [params addObject: [NSString stringWithFormat: @"%@=%@",
                                                       [keyStr urlEncodeUsingEncoding: NSUTF8StringEncoding],
                                                       [valueStr urlEncodeUsingEncoding: NSUTF8StringEncoding]]];
    }
    
    return [params componentsJoinedByString: @"&"];
}

@end
