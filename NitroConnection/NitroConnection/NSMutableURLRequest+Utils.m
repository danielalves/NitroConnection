//
//  NSMutableURLRequest+Utils.m
//  NitroConnection
//
//  Created by Daniel L. Alves on 4/9/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import "NSMutableURLRequest+Utils.h"

#pragma mark - Implementation

@implementation NSMutableURLRequest( Utils_NitroConnection )

+( instancetype )requestWithRequest:( NSURLRequest * )request
{
    NSMutableURLRequest *temp = [self requestWithURL: request.URL
                                         cachePolicy: request.cachePolicy
                                     timeoutInterval: request.timeoutInterval];

    [temp setMainDocumentURL: request.mainDocumentURL];
    [temp setNetworkServiceType: request.networkServiceType];
    [temp setAllowsCellularAccess: request.allowsCellularAccess];
    [temp setAllHTTPHeaderFields: request.allHTTPHeaderFields];
    [temp setHTTPBody: request.HTTPBody];
    [temp setHTTPBodyStream: request.HTTPBodyStream];
    [temp setHTTPMethod: request.HTTPMethod];
    [temp setHTTPShouldHandleCookies: request.HTTPShouldHandleCookies];
    [temp setHTTPShouldUsePipelining: request.HTTPShouldUsePipelining];
    
    return temp;
}

@end
