//
//  TNTHttpMethods.h
//  NitroConnection
//
//  Created by Daniel L. Alves on 30/07/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#ifndef NITRO_CONNECTION_HTTP_METHODS_H
#define NITRO_CONNECTION_HTTP_METHODS_H

#import <Foundation/Foundation.h>

/**
 *  Supported HTTP methods
 */
typedef NS_ENUM( NSUInteger, TNTHttpMethod )
{
    /**
     *  HTTP GET
     */
    TNTHttpMethodGet,
    /**
     *  HTTP HEAD
     */
    TNTHttpMethodHead,
    /**
     *  HTTP DELETE
     */
    TNTHttpMethodDelete,
    /**
     *  HTTP POST
     */
    TNTHttpMethodPost,
    /**
     *  HTTP PUT
     */
    TNTHttpMethodPut,
    /**
     *  HTTP PATCH
     */
    TNTHttpMethodPatch
};

@interface NSString( TNTHttpMethod )

/**
 *  Returns the string representation of a HTTP method.
 *
 *  @param method The HTTP method which will be converted to a string
 *
 *  @return The string representation of a HTTP method
 */
+( NSString * )stringFromHttpMethod:( TNTHttpMethod )method;

@end

#endif
