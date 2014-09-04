//
//  TNTHttpConnection+SyntaticSugar.m
//  NitroConnection
//
//  Created by Daniel L. Alves on 05/08/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import "TNTHttpConnection+SyntaticSugar.h"

// NitroConnection
#import "NSDictionary+QueryString.h"

#pragma mark - Defines

#define TNT_SYNTHESIZE_PARAMS_TO_QUERY_STRING_METHODS( managedName, unmanagedName, httpMethod )\
\
+( instancetype )managedName:( NSString * )url params:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock\
{\
    return [self managedName: url\
                 queryString: params\
                        body: nil\
                     headers: nil\
                  onDidStart: didStartBlock\
                   onSuccess: successBlock\
                     onError: errorBlock];\
}\
+( instancetype )managedName:( NSString * )url params:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate\
{\
    return [self managedName: url queryString: params body: nil headers: nil delegate: delegate];\
}\
+( instancetype )unmanaged##unmanagedName:( NSString * )url params:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock\
{\
    return [self unmanaged##unmanagedName: url\
                              queryString: params\
                                     body: nil\
                                  headers: nil\
                               onDidStart: didStartBlock\
                                onSuccess: successBlock\
                                  onError: errorBlock];\
}\
\
+( instancetype )unmanaged##unmanagedName:( NSString * )url params:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate\
{\
    return [self unmanaged##unmanagedName: url queryString: params body: nil headers: nil delegate: delegate];\
}



#define TNT_SYNTHESIZE_PARAMS_TO_BODY_METHODS( managedName, unmanagedName, httpMethod )\
\
+( instancetype )managedName:( NSString * )url params:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock\
{\
    NSString *formattedParams = [params toQueryString];\
    NSData *bodyData = [formattedParams dataUsingEncoding: NSUTF8StringEncoding];\
\
    return [self managedName: url\
                 queryString: nil\
                        body: bodyData\
                     headers: nil\
                  onDidStart: didStartBlock\
                   onSuccess: successBlock\
                     onError: errorBlock];\
}\
+( instancetype )managedName:( NSString * )url params:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate\
{\
    NSString *formattedParams = [params toQueryString];\
    NSData *bodyData = [formattedParams dataUsingEncoding: NSUTF8StringEncoding];\
\
    return [self managedName: url queryString: nil body: bodyData headers: nil delegate: delegate];\
}\
+( instancetype )unmanaged##unmanagedName:( NSString * )url params:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock\
{\
    NSString *formattedParams = [params toQueryString];\
    NSData *bodyData = [formattedParams dataUsingEncoding: NSUTF8StringEncoding];\
\
    return [self unmanaged##unmanagedName: url\
                              queryString: nil\
                                     body: bodyData\
                                  headers: nil\
                               onDidStart: didStartBlock\
                                onSuccess: successBlock\
                                  onError: errorBlock];\
}\
\
+( instancetype )unmanaged##unmanagedName:( NSString * )url params:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate\
{\
    NSString *formattedParams = [params toQueryString];\
    NSData *bodyData = [formattedParams dataUsingEncoding: NSUTF8StringEncoding];\
\
    return [self unmanaged##unmanagedName: url queryString: nil body: bodyData headers: nil delegate: delegate];\
}



#define TNT_SYNTHESIZE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( managedName, unmanagedName, httpMethod )\
\
+( instancetype )managedName:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock\
{\
    return [self managedName: url\
                 queryString: nil\
                        body: nil\
                     headers: nil\
                  onDidStart: didStartBlock\
                   onSuccess: successBlock\
                     onError: errorBlock];\
}\
\
+( instancetype )managedName:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock\
{\
    return [self managedName: url\
                 queryString: queryString\
                        body: body\
                     headers: nil\
                  onDidStart: didStartBlock\
                   onSuccess: successBlock\
                     onError: errorBlock];\
}\
\
+( instancetype )managedName:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock\
{\
    TNTHttpConnection *temp = [self new];\
    [temp startRequestWithMethod: httpMethod\
                             url: url\
                     queryString: queryString\
                            body: body\
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
    return [self managedName: url queryString: nil body: nil headers: nil delegate: delegate];\
}\
\
+( instancetype )managedName:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body delegate:( id< TNTHttpConnectionDelegate > )delegate\
{\
    return [self managedName: url queryString: queryString body: body headers: nil delegate: delegate];\
}\
\
+( instancetype )managedName:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate\
{\
    TNTHttpConnection *temp = [self new];\
    temp.delegate = delegate;\
    [temp startRequestWithMethod: httpMethod url: url queryString: queryString body: body headers: headers managed: YES];\
    return temp;\
}\
\
+( instancetype )unmanaged##unmanagedName:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock\
{\
    return [self unmanaged##unmanagedName: url\
                              queryString: nil\
                                     body: nil\
                                  headers: nil\
                               onDidStart: didStartBlock\
                                onSuccess: successBlock\
                                  onError: errorBlock];\
}\
\
+( instancetype )unmanaged##unmanagedName:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock\
{\
    return [self unmanaged##unmanagedName: url\
                              queryString: queryString\
                                     body: body\
                                  headers: nil\
                               onDidStart: didStartBlock\
                                onSuccess: successBlock\
                                  onError: errorBlock];\
}\
\
+( instancetype )unmanaged##unmanagedName:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock\
{\
    TNTHttpConnection *temp = [self new];\
    [temp startRequestWithMethod: httpMethod\
                             url: url\
                     queryString: queryString\
                            body: body\
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
    return [self unmanaged##unmanagedName: url queryString: nil body: nil headers: nil delegate: delegate];\
}\
\
+( instancetype )unmanaged##unmanagedName:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body delegate:( id< TNTHttpConnectionDelegate > )delegate\
{\
    return [self unmanaged##unmanagedName: url queryString: queryString body: body headers: nil delegate: delegate];\
}\
\
+( instancetype )unmanaged##unmanagedName:( NSString * )url queryString:( NSDictionary * )queryString body:( NSData * )body headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate\
{\
    TNTHttpConnection *temp = [self new];\
    temp.delegate = delegate;\
    [temp startRequestWithMethod: httpMethod url: url queryString: queryString body: body headers: headers managed: NO];\
    return temp;\
}

#pragma mark - Implementation

@implementation TNTHttpConnection( SyntaticSugar )

TNT_SYNTHESIZE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( get, Get, TNTHttpMethodGet )
TNT_SYNTHESIZE_PARAMS_TO_QUERY_STRING_METHODS( get, Get, TNTHttpMethodGet )

TNT_SYNTHESIZE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( head, Head, TNTHttpMethodHead )
TNT_SYNTHESIZE_PARAMS_TO_QUERY_STRING_METHODS( head, Head, TNTHttpMethodHead )

TNT_SYNTHESIZE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( delete, Delete, TNTHttpMethodDelete )
TNT_SYNTHESIZE_PARAMS_TO_QUERY_STRING_METHODS( delete, Delete, TNTHttpMethodDelete )

TNT_SYNTHESIZE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( post, Post, TNTHttpMethodPost )
TNT_SYNTHESIZE_PARAMS_TO_BODY_METHODS( post, Post, TNTHttpMethodPost )

TNT_SYNTHESIZE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( put, Put, TNTHttpMethodPut )
TNT_SYNTHESIZE_PARAMS_TO_BODY_METHODS( put, Put, TNTHttpMethodPut )

TNT_SYNTHESIZE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( patch, Patch, TNTHttpMethodPatch )
TNT_SYNTHESIZE_PARAMS_TO_BODY_METHODS( patch, Patch, TNTHttpMethodPatch )

@end
