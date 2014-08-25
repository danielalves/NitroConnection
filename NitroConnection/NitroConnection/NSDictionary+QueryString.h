//
//  NSDictionary+QueryString.h
//  NitroConnection
//
//  Created by Daniel L. Alves on 06/08/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary( NitroConnection_QueryString )

/**
 *  Returns a query string representing the key-values of the dictionary, with
 *  all keys and values escaped.
 *
 *  @return A query string representing the key-values of the dictionary or an empty
 *          string if the dictionary is also empty
 */
-( NSString * )toQueryString;

@end
