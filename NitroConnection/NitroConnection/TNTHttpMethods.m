//
//  TNTHttpMethods.m
//  NitroConnection
//
//  Created by Daniel L. Alves on 30/07/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import "TNTHttpMethods.h"

#pragma mark - Implementation

@implementation NSString( TNTHttpMethod )

+( NSString * )stringFromHttpMethod:( TNTHttpMethod )method
{
    switch( method )
    {
        case TNTHttpMethodGet:
            return @"GET";
        case TNTHttpMethodPost:
            return @"POST";
        case TNTHttpMethodDelete:
            return @"DELETE";
        case TNTHttpMethodPut:
            return @"PUT";
        case TNTHttpMethodPatch:
            return @"PATCH";
        case TNTHttpMethodHead:
            return @"HEAD";
        default:
            return nil;
    }
}

@end