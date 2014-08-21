NitroConnection
===============

**NitroConnection** is a very fast, simple and lightweight HTTP connection wrapper for iOS as an alternative to AFNetworking.

**NitroConnection** focus on performance and on the fact that the programmer should not pay for something he/she is not using. That is, your code should not loose performance or cause unneeded internet traffic because a connection was kept alive, running in background, while it should have already been canceled. Nevertheless, **NitroConnection** strives to achieve ease of use and to offer common functionality, like fire and forget requests.

Without further ado:

```objc
[TNTHttpConnection get: @"https://octodex.github.com/plumber/"
            onDidStart: {
                // Show loading feedback
                // ....
            }
            onSuccess: ^( NSHTTPURLResponse *response, NSData *data ) {
                // Image downloaded! Do something with it
                // ...
            }
            onError: ^( NSError *error ) {
                // Damn! Let's show an error feedback =/
                // ...
            }];
```

Now let's talk about other **NitroConnection** features:

- It supports `GET`, `HEAD`, `DELETE`, `POST`, `PUT` and `PATCH` HTTP methods.
- Its callbacks come in two flavors: via delegate and via blocks.
- A single **NitroConnection** can be used to make any number of requests.
- Simple retry! Just call... `retry`!
- Offers a way to set a connection as managed or unmanaged, giving you more control on what is happening behind the scenes. More about that below.

Managed Connections
-------------------

Managed connections live outside the scope in which they were created. Therefore the user should know that, if he/she does not cancel them, they will run until the request fails or succeeds. This is the default behavior on all syntatic sugar methods:

```objc
// This request will run until it fails or succeeds
[TNTHttpConnection post: @"mysite.com/api/news/mark-as-read" 
             withParams: @{ @"news-id": @1872 }
               delegate: nil];
```

Of course, if there's a possibility you may want to cancel a request before its completion, you just need to keep a reference to it:

```objc
@interface SomeClass
{
    TNTHttpConnection *apiConnection;
}
@end

@implementation SomeClass

-( void )dealloc
{
    // This is needed to save resources
    [apiConnection cancel];
}

-( void )markNewsAsRead
{
    // This request will run until it fails or succeeds
    apiConnection = [TNTHttpConnection post: @"mysite.com/api/news/mark-as-read" 
                                 withParams: @{ @"news-id": @1872 }
                                   delegate: nil];
}

@end
```

Or, what's even better, you could use unmanaged connections.

Unmanaged Connections
---------------------

As opposed to managed connections, unmanaged connections are canceled and released as soon as they leave the scope in which they were created. That is, there is no need for the user to call `cancel` on unmanaged connections prior to their deallocations. Therefore the user must keep a strong reference to the connection:

```objc
//
// This will not work as intended
//
@implementation NitroConnectionMisuseClass
-( void )loadMoreVideos
{
    // DON'T DO THIS! This connection may never complete since
    // it will be released at the end of the scope
    [TNTHttpConnection unmanagedGet: @"mysite.com/api/videos/load-more-like-this" 
                         withParams: @{ @"video-id": @900 }
                           delegate: self];
}
@end

//
// This is the right way to do it
//
@interface DevWithGreatFutureClass< TNTHttpConnectionDelegate >
{
    TNTHttpConnection *apiConnection;
}
@end

@implementation DevWithGreatFutureClass

// Differently from managed connections, we need no dealloc implementation here

-( void )loadMoreVideos
{
    apiConnection = [TNTHttpConnection unmanagedPost: @"mysite.com/api/videos/load-more-like-this"
                                          withParams: @{ @"video-id": @900 }
                                            delegate: self];
}
@end
```

Managed vs Unmanaged Connections
--------------------------------

Going down one level
--------------------
