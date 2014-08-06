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

#define TNT_DECLARE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( name, httpMethod )\
\
+( instancetype )name:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;\
+( instancetype )name:( NSString * )url withParams:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;\
+( instancetype )name:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;\
\
+( instancetype )name:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;\
+( instancetype )name:( NSString * )url withParams:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;\
+( instancetype )name:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;

@interface TNTHttpConnection( SyntaticSugar )

TNT_DECLARE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( get, TNTHttpMethodGet )
TNT_DECLARE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( head, TNTHttpMethodHead )
TNT_DECLARE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( delete, TNTHttpMethodDelete )

TNT_DECLARE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( post, TNTHttpMethodPost )
TNT_DECLARE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( put, TNTHttpMethodPut )
TNT_DECLARE_SYNTATIC_SUGAR_METHODS_FOR_HTTP_METHOD( patch, TNTHttpMethodPatch )

@end
