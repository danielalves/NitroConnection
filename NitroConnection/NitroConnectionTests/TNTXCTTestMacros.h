//
//  TNTXCTTestMacros.h
//  NitroConnectionTests
//
//  Created by Daniel L. Alves on 7/8/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#ifndef TNT_XCTTEST_MACROS_H
#define TNT_XCTTEST_MACROS_H

#define XCTFailIfParameterNil(parameter) if( parameter == nil ){ XCTFail(@"Invalid parameter: %s must not be nil", #parameter); }

#define XCTAssertRequestHttpMethod( request, httpMethod ) XCTAssertEqualObjects( request.HTTPMethod, [NSString stringFromHttpMethod: httpMethod] )

#define XCTAssertRequestQueryString( request, queryStringParams )                                                            \
{                                                                                                                            \
    BOOL ret = [temp.lastRequest.URL.absoluteString hasSuffix: [NSString stringWithFormat: @"?%@", [params toQueryString]]]; \
    XCTAssertTrue( ret );                                                                                                    \
}

#define XCTAssertRequestHeaders( request, headers )                  \
{                                                                    \
    NSDictionary *allHeaders = request.allHTTPHeaderFields;          \
    for( NSString *key in headers )                                  \
    {                                                                \
        XCTAssertNotNil( allHeaders[ key ] );                        \
        XCTAssertEqualObjects( allHeaders[ key ], headers[ key ] );  \
    }                                                                \
}

#define XCTAssertRequestBody( request, params )                                 \
{                                                                               \
    NSString *formattedParams = [params toQueryString];                         \
    NSData *data = [formattedParams dataUsingEncoding: NSUTF8StringEncoding];   \
    XCTAssertTrue( [temp.lastRequest.HTTPBody isEqualToData: data] );           \
}

#endif
