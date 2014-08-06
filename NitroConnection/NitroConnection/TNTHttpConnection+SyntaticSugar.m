//
//  TNTHttpConnection+SyntaticSugar.m
//  NitroConnection
//
//  Created by Daniel L. Alves on 05/08/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import "TNTHttpConnection+SyntaticSugar.h"

#pragma mark - Defines

#define TNT_SYNTHESIZE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( name, httpMethod )\
\
+( instancetype )name:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock\
{\
    return [self name: url\
           withParams: nil\
              headers: nil\
           onDidStart: didStartBlock\
            onSuccess: successBlock\
              onError: errorBlock];\
}\
\
+( instancetype )name:( NSString * )url withParams:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock\
{\
    return [self name: url\
           withParams: params\
              headers: nil\
           onDidStart: didStartBlock\
            onSuccess: successBlock\
              onError: errorBlock];\
}\
\
+( instancetype )name:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock\
{\
    TNTHttpConnection *temp = [self new];\
    [temp startRequestWithMethod: httpMethod\
                             url: url\
                          params: params\
                         headers: headers\
                      onDidStart: didStartBlock\
                       onSuccess: successBlock\
                         onError: errorBlock];\
    return temp;\
}\
\
+( instancetype )name:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate\
{\
    return [self name: url withParams: nil headers: nil delegate: delegate];\
}\
\
+( instancetype )name:( NSString * )url withParams:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate\
{\
    return [self name: url withParams: params headers: nil delegate: delegate];\
}\
\
+( instancetype )name:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate\
{\
    TNTHttpConnection *temp = [self new];\
    temp.delegate = delegate;\
    [temp startRequestWithMethod: httpMethod url: url params: params headers: headers];\
    return temp;\
}

#pragma mark - Implementation

@implementation TNTHttpConnection( SyntaticSugar )

TNT_SYNTHESIZE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( get, TNTHttpMethodGet )
TNT_SYNTHESIZE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( head, TNTHttpMethodHead )
TNT_SYNTHESIZE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( delete, TNTHttpMethodDelete )

TNT_SYNTHESIZE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( post, TNTHttpMethodPost )
TNT_SYNTHESIZE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( put, TNTHttpMethodPut )
TNT_SYNTHESIZE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( patch, TNTHttpMethodPatch )

@end
