NitroConnection
===============
[![Version](http://cocoapod-badges.herokuapp.com/v/NitroConnection/badge.png)](http://cocoadocs.org/docsets/NitroConnection)
[![Platform](http://cocoapod-badges.herokuapp.com/p/NitroConnection/badge.png)](http://cocoadocs.org/docsets/NitroConnection)
[![TravisCI](https://travis-ci.org/danielalves/NitroConnection.svg?branch=master)](https://travis-ci.org/danielalves/NitroConnection)

**NitroConnection** is a very fast, simple and lightweight HTTP connection wrapper for iOS as an alternative to AFNetworking.

**NitroConnection** focus on performance and on the fact that the programmer should not pay for something he/she is not using. That is, your code should not loose performance or cause unneeded internet traffic because a connection was kept alive, running in background, while it should have already been canceled. Nevertheless, **NitroConnection** strives to achieve ease of use and to offer common functionality, like fire and forget requests.

Without further ado:

```objc
[TNTHttpConnection get: @"https://octodex.github.com/images/plumber.jpg"
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

- OAuth 2 (without refresh tokens).
- Thread safety.
- `GET`, `HEAD`, `DELETE`, `POST`, `PUT` and `PATCH` HTTP methods.
- Easy query string, body params and headers configuration.
- Global, per connection and per request cache policy and timeout interval configuration.
- Its callbacks come in two flavors: via delegate and via blocks.
- A single **NitroConnection** can be used to make any number of requests.
- Simple retry! Just call... `retry`!
- Offers a way to set a request as managed or unmanaged, giving you more control on what is happening behind the scenes. More about that below.

Managed Requests
----------------

Managed requests make their connections live outside the scope in which they were created. Therefore the user should know that, if he/she does not cancel them, they will run until failure or success, keeping their connection in memory during the process. This is the default behavior on all syntatic sugar methods:

```objc
// This request will run until it fails, succeeds or is canceled
[TNTHttpConnection post: @"mysite.com/api/news/mark-as-read" 
             withParams: @{ @"news-id": @1872 }
               delegate: nil];
```

Of course, if there's a possibility you may want to cancel a managed request before its completion, you just need to keep a reference to it:

```objc
@interface SomeClass
{
    TNTHttpConnection *apiConnection;
}
@end

@implementation SomeClass

-( void )dealloc
{
    // This is needed to save resources and/or we don't care
    // if the request is canceled 
    [apiConnection cancel];
}

-( void )markNewsAsRead
{
    // This request will run until it fails, succeeds or is canceled
    apiConnection = [TNTHttpConnection post: @"mysite.com/api/news/analytics" 
                                 withParams: @{ @"news-id": @1872 }
                                   delegate: nil];
}

@end
```

Or, what's even better, you could use unmanaged requests.

Unmanaged Requests
------------------

As opposed to managed requests, unmanaged requests do not hold their connections alive, so those connections are released as soon as the scope in which they were created is left. That is, there is no need for the user to call `cancelRequest` on a connection running an unmanaged request prior to its deallocation. Therefore the user **MUST** keep a strong reference to the connection to keep it alive:

```objc
//
// WARNING: This will not work as intended
//
@implementation NitroConnectionMisuseClass

-( void )loadMoreVideos
{
    // DON'T DO THIS! This connection may never complete its request since
    // it will be released at the end of the scope
    [TNTHttpConnection unmanagedGet: @"mysite.com/api/videos/load-more-like-this" 
                         withParams: @{ @"video-id": @900 }
                           delegate: self];
}

@end

//
// THE RIGHT WAY: This is the right way to do it
//
@interface DevWithGreatFutureClass< TNTHttpConnectionDelegate >
{
    TNTHttpConnection *apiConnection;
}
@end

@implementation DevWithGreatFutureClass

// Differently from managed requests, we need no dealloc implementation here

-( void )loadMoreVideos
{
    apiConnection = [TNTHttpConnection unmanagedPost: @"mysite.com/api/videos/load-more-like-this"
                                          withParams: @{ @"video-id": @900 }
                                            delegate: self];
}

@end
```

Managed vs Unmanaged Requests
-----------------------------

So, what kind of request should you use? Well, as everything in life, it depends. The rule of thumb is:

- **Managed**: Very good for fire and forget requests. For example: ping a recommendation or analytics API.
- **Unmanaged**: Fits requests that have a strong relationship to its interface context. For example: in a search result screen, as the user scrolls up, more results are fetched. When the user leaves the screen, connections should be canceled. After all, search results are not needed anymore.

That being said, you could stick with managed requests only, as long as you don't forget to call `cancelRequest` on every connection that is not needed anymore. In addition to that, if you are going to fire more than one request per connection and if those have mixed types, you should always call `cancelRequest` when the connection is not needed anymore, because there is no sense in tracking what was the kind of the last request you fired.

Going down one level
--------------------

**NitroConnection** offers a lot of syntatic sugar methods for your code to look better, and you are really advised to use them. But, if you want to go down one level, or if you want to fire more than one request with the same `TNTHttpConnection` object, it is possible:

```objc
TNTHttpConnection *conn = [TNTHttpConnection new];
conn.timeoutInterval = 5.0;
conn.cachePolicy = NSURLRequestReloadIgnoringCacheData;

// A way of firing an unmanaged request
// We are not passing parameters just for the sake of simplicity
[conn startRequestWithMethod: TNTHttpMethodGet
                         url: @"google.com"
                      params: nil
                     headers: nil
                     managed: NO
                  onDidStart: /* A block */
                   onSuccess: /* A block */
                     onError: /* A block */];
                           
// Another way of firing a request, this time a managed one
conn.delegate = /* an object */;
NSURLRequest *request = /* request creation */;
[conn startRequest: request managed: YES];
```

As we said before, what changes the behavior of a connection is its current request. If you don't want to get confused, don't mix request types in the same connection object or always call `cancelRequest` when the connection is not needed anymore.

OAuth 2
-------

**NitroConnection** supports [OAuth 2](http://en.wikipedia.org/wiki/OAuth) without refresh tokens. This feature is designed to work transparently. Let's look at its flow, but keep in mind that the only step that gives you some work is step 1:

1. You set authentication items before making any request (just after an application starts 
   is a good choice):

   ```objc
   [TNTHttpConnection authenticateServicesMatching: regex
                            usingRequestWithMethod: TNTHttpMethodPost
                                          tokenUrl: @"https://accounts.myservice.com/token"
                                       queryString: nil
                                              body: nil
                                           headers: nil
                                    keychainItemId: @"com.myservice.accounts"
                           keychainItemAccessGroup: nil /* If you want to share this token with other apps, set this parameter */
                               onInformCredentials: ^NSString *( NSURLRequest *originalRequest ) {
                                    
                                   // Let's say your server expects a base64
                                   NSString* credentials = [NSString stringWithFormat: @"%@:%@", username, password];
                                   NSData* data = [credentials dataUsingEncoding: NSUTF8StringEncoding];
                                   NSData* base64Data = [data base64EncodedDataWithOptions: 0];
                                   return [[NSString alloc] initWithData: base64Data encoding: NSUTF8StringEncoding];
                                    
                               } onParseTokenFromResponse: ^NSString *( NSURLRequest *originalRequest, NSHTTPURLResponse *authenticationResponse, NSData *data ) {

                                   @try
                                   {
                                       NSString *token = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                       return token;
                                   }
                                   @catch( NSException *exception )
                                   {
                                       // Log error
                                       // ...
                                        
                                       return nil;
                                   }
                                    
                               } onAuthenticationError: ^BOOL( NSURLRequest *originalRequest, NSHTTPURLResponse *authenticationResponse, NSError *error ) {

                                   // Log error
                                   // ...

                                   BOOL retry = false;
                                   return retry;
                               }];
   ```

  Quite a long method call, I know, but you will start to like its simplicity over time.

2. After that, every request that fails with a **401 HTTP error code** and that matches an 
   authentication item will be put on hold while the authentication token is being obtained.

3. The authentication token request will be fired. This header will be included with others
   you may or may not have set:

   ```objc
   @{ @"Authorization": @"Basic <credentials>" }
   ```

4. While the token is being obtained, if other request that matches the same authentication item is fired (in fact, any other number of requests), it will be also be put on hold.

5. If the authentication token request ...

  1. Succeeds, `retryRequest` will be called on every connection that was put on hold and     
     that is still alive. But, now, the authentication token will be sent in the
     **Authorization HTTP Header** like so:

     ```objc
     @{ @"Authorization" : @"Bearer <token>" }
     ```
     
  2. Fails, you will have the chance to retry the authentication token request or to give 
     up. If you...
  
      1. Give up, all on hold connections that are still alive will have their delegate 
         error callbacks/ error blocks called, the same way they would if there was no
         authentication process in place.

      2. Want to retry, you will be back at step 3.

6. When a token expires, you will be back at step 2.

As you can see, besides setting authentication items, there is nothing more you have to do. You just use **NitroConnection** as before =D

**NitroConnection automatically handles HTTPS authentication challenges for you**: authentication token urls and all urls that are matched by authentication item regexes will be trusted.

For more information about **OAuth 2** and **HTTP Basic Authentication**, see:
- http://tools.ietf.org/html/rfc6749
- http://en.wikipedia.org/wiki/OAuth
- http://en.wikipedia.org/wiki/Basic_access_authentication
    
Requirements
------------

iOS 6.0 or higher, ARC only

Installation
------------

**NitroConnection** is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'NitroConnection'
```

Author
------

- [Daniel L. Alves](http://github.com/danielalves) ([@alveslopesdan](https://twitter.com/alveslopesdan))

License
-------

**NitroConnection** is available under the MIT license. See the LICENSE file for more info.
