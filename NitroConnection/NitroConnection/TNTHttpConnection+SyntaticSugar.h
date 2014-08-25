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

@interface TNTHttpConnection( SyntaticSugar )

+( instancetype )get:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )get:( NSString * )url withParams:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )get:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )get:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )get:( NSString * )url withParams:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )get:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )unmanagedGet:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )unmanagedGet:( NSString * )url withParams:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )unmanagedGet:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )unmanagedGet:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )unmanagedGet:( NSString * )url withParams:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )unmanagedGet:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;


+( instancetype )head:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )head:( NSString * )url withParams:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )head:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )head:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )head:( NSString * )url withParams:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )head:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )unmanagedHead:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )unmanagedHead:( NSString * )url withParams:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )unmanagedHead:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )unmanagedHead:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )unmanagedHead:( NSString * )url withParams:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )unmanagedHead:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;

+( instancetype )delete:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )delete:( NSString * )url withParams:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )delete:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )delete:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )delete:( NSString * )url withParams:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )delete:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )unmanagedDelete:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )unmanagedDelete:( NSString * )url withParams:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )unmanagedDelete:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )unmanagedDelete:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )unmanagedDelete:( NSString * )url withParams:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )unmanagedDelete:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;


+( instancetype )post:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )post:( NSString * )url withParams:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )post:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )post:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )post:( NSString * )url withParams:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )post:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )unmanagedPost:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )unmanagedPost:( NSString * )url withParams:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )unmanagedPost:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )unmanagedPost:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )unmanagedPost:( NSString * )url withParams:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )unmanagedPost:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;

+( instancetype )put:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )put:( NSString * )url withParams:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )put:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )put:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )put:( NSString * )url withParams:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )put:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )unmanagedPut:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )unmanagedPut:( NSString * )url withParams:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )unmanagedPut:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )unmanagedPut:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )unmanagedPut:( NSString * )url withParams:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )unmanagedPut:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;


+( instancetype )patch:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )patch:( NSString * )url withParams:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )patch:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )patch:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )patch:( NSString * )url withParams:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )patch:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )unmanagedPatch:( NSString * )url onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )unmanagedPatch:( NSString * )url withParams:( NSDictionary * )params onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )unmanagedPatch:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers onDidStart:( TNTHttpConnectionDidStartBlock )didStartBlock onSuccess:( TNTHttpConnectionSuccessBlock )successBlock onError:( TNTHttpConnectionErrorBlock )errorBlock;
+( instancetype )unmanagedPatch:( NSString * )url delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )unmanagedPatch:( NSString * )url withParams:( NSDictionary * )params delegate:( id< TNTHttpConnectionDelegate > )delegate;
+( instancetype )unmanagedPatch:( NSString * )url withParams:( NSDictionary * )params headers:( NSDictionary * )headers delegate:( id< TNTHttpConnectionDelegate > )delegate;

@end
