//
//  TNTHttpConnection+SyntaticSugar.h
//  NitroConnection
//
//  Created by Daniel L. Alves on 05/08/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import "TNTHttpConnection.h"

// NitroConnection
#import "TNTHttpMethods.h"

#define TNT_DECLARE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( managedName, unmanagedName, httpMethod )\
\
+( instancetype )managedName:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;\
+( instancetype )managedName:( NSString * )url withParams:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;\
+( instancetype )managedName:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;\
\
+( instancetype )managedName:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;\
+( instancetype )managedName:( NSString * )url withParams:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;\
+( instancetype )managedName:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;\
\
+( instancetype )unmanaged##unmanagedName:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;\
+( instancetype )unmanaged##unmanagedName:( NSString * )url withParams:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;\
+( instancetype )unmanaged##unmanagedName:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;\
\
+( instancetype )unmanaged##unmanagedName:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;\
+( instancetype )unmanaged##unmanagedName:( NSString * )url withParams:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;\
+( instancetype )unmanaged##unmanagedName:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;

@interface TNTHttpConnection( SyntaticSugar )

TNT_DECLARE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( get, Get, TNTHttpMethodGet )
TNT_DECLARE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( head, Head, TNTHttpMethodHead )
TNT_DECLARE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( delete, Delete, TNTHttpMethodDelete )

TNT_DECLARE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( post, Post, TNTHttpMethodPost )
TNT_DECLARE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( put, Put, TNTHttpMethodPut )
TNT_DECLARE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( patch, Patch, TNTHttpMethodPatch )

@end
