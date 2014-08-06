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

typedef NS_ENUM( NSUInteger, TNTHttpMethod )
{
    TNTHttpMethodGet,
    TNTHttpMethodPost,
    TNTHttpMethodDelete,
    TNTHttpMethodPut,
    TNTHttpMethodPatch,
    TNTHttpMethodHead
};

@interface NSString( TNTHttpMethod )

+( NSString * )stringFromHttpMethod:( TNTHttpMethod )method;

@end

#endif
