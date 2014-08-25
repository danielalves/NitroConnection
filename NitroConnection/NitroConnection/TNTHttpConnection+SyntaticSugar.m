//
//  TNTHttpConnection+SyntaticSugar.m
//  NitroConnection
//
//  Created by Daniel L. Alves on 05/08/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import "TNTHttpConnection+SyntaticSugar.h"

#pragma mark - Defines

#define TNT_SYNTHESIZE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( managedName, unmanagedName, httpMethod )\
\
+( instancetype )managedName:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock\
{\
    return [self managedName: url\
                  withParams: nil\
                     headers: nil\
                  onDidStart: didStartBlock\
                   onSuccess: successBlock\
                     onError: errorBlock];\
}\
\
+( instancetype )managedName:( NSString * )url withParams:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock\
{\
    return [self managedName: url\
                  withParams: params\
                     headers: nil\
                  onDidStart: didStartBlock\
                   onSuccess: successBlock\
                     onError: errorBlock];\
}\
\
+( instancetype )managedName:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock\
{\
    TNTHttpConnection *temp = [self new];\
    [temp startRequestWithMethod: httpMethod\
                             url: url\
                          params: params\
                         headers: headers\
                         managed: YES\
                      onDidStart: didStartBlock\
                       onSuccess: successBlock\
                         onError: errorBlock];\
    return temp;\
}\
\
+( instancetype )managedName:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate\
{\
    return [self managedName: url withParams: nil headers: nil delegate: delegate];\
}\
\
+( instancetype )managedName:( NSString * )url withParams:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate\
{\
    return [self managedName: url withParams: params headers: nil delegate: delegate];\
}\
\
+( instancetype )managedName:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate\
{\
    TNTHttpConnection *temp = [self new];\
    temp.delegate = delegate;\
    [temp startRequestWithMethod: httpMethod url: url params: params headers: headers managed: YES];\
    return temp;\
}\
\
+( instancetype )unmanaged##unmanagedName:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock\
{\
    return [self unmanaged##unmanagedName: url\
                               withParams: nil\
                                  headers: nil\
                               onDidStart: didStartBlock\
                                onSuccess: successBlock\
                                  onError: errorBlock];\
}\
\
+( instancetype )unmanaged##unmanagedName:( NSString * )url withParams:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock\
{\
    return [self unmanaged##unmanagedName: url\
                               withParams: params\
                                  headers: nil\
                               onDidStart: didStartBlock\
                                onSuccess: successBlock\
                                  onError: errorBlock];\
}\
\
+( instancetype )unmanaged##unmanagedName:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock\
{\
    TNTHttpConnection *temp = [self new];\
    [temp startRequestWithMethod: httpMethod\
                             url: url\
                          params: params\
                         headers: headers\
                         managed: NO\
                      onDidStart: didStartBlock\
                       onSuccess: successBlock\
                         onError: errorBlock];\
    return temp;\
}\
\
+( instancetype )unmanaged##unmanagedName:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate\
{\
    return [self unmanaged##unmanagedName: url withParams: nil headers: nil delegate: delegate];\
}\
\
+( instancetype )unmanaged##unmanagedName:( NSString * )url withParams:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate\
{\
    return [self unmanaged##unmanagedName: url withParams: params headers: nil delegate: delegate];\
}\
\
+( instancetype )unmanaged##unmanagedName:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate\
{\
    TNTHttpConnection *temp = [self new];\
    temp.delegate = delegate;\
    [temp startRequestWithMethod: httpMethod url: url params: params headers: headers managed: NO];\
    return temp;\
}

#pragma mark - Implementation

@implementation TNTHttpConnection( SyntaticSugar )

TNT_SYNTHESIZE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( get, Get, TNTHttpMethodGet )
TNT_SYNTHESIZE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( head, Head, TNTHttpMethodHead )
TNT_SYNTHESIZE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( delete, Delete, TNTHttpMethodDelete )

TNT_SYNTHESIZE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( post, Post, TNTHttpMethodPost )
TNT_SYNTHESIZE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( put, Put, TNTHttpMethodPut )
TNT_SYNTHESIZE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( patch, Patch, TNTHttpMethodPatch )

@end
