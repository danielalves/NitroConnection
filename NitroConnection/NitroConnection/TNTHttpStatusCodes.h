//
//  TNTHttpStatusCodes.h
//  NitroConnection
//
//  Created by Daniel L. Alves on 05/04/12.
//  Copyright (c) 2012 Daniel L. Alves. All rights reserved.
//

#ifndef NITRO_CONNECTION_HTTP_STATUS_CODE_H
#define NITRO_CONNECTION_HTTP_STATUS_CODE_H

#import <Foundation/Foundation.h>

/**
 * HTTP status codes as defined in RFC 2616.
 *
 * To get a localized string corresponding to a specified HTTP status code,
 * use NSHTTPURLResponse class localizedStringForStatusCode: method.
 */
typedef NS_ENUM( NSInteger, TNTHttpStatusCode )
{
    // Informational 1xx
    TNTHttpStatusCodeContinue                       = 100,
    TNTHttpStatusCodeSwitchingProtocols             = 101,
    
    // Successful 2xx
	TNTHttpStatusCodeOk                             = 200,
    TNTHttpStatusCodeCreated                        = 201,
	TNTHttpStatusCodeAccepted                       = 202,
    TNTHttpStatusCodeNonAuthoritativeInformation    = 203,
    TNTHttpStatusCodeNoContent                      = 204,
    TNTHttpStatusCodeResetContent                   = 205,
    TNTHttpStatusCodePartialContent                 = 206,
	
    // Redirection 3xx
    TNTHttpStatusCodeMultipleChoices                = 300,
    TNTHttpStatusCodeMovedPermanently               = 301,
    TNTHttpStatusCodeFound                          = 302,
    TNTHttpStatusCodeSeeOther                       = 303,
    TNTHttpStatusCodeNotModified                    = 304,
    TNTHttpStatusCodeUseProxy                       = 305,
    TNTHttpStatusCodeTemporaryRedirect              = 307,
    
    // Client Error 4xx
	TNTHttpStatusCodeBadRequest                     = 400,
	TNTHttpStatusCodeUnauthorized                   = 401,
	TNTHttpStatusCodePaymentRequired                = 402,
	TNTHttpStatusCodeForbidden                      = 403,
	TNTHttpStatusCodeNotFound                       = 404,
	TNTHttpStatusCodeMethodNotAllowed               = 405,
	TNTHttpStatusCodeNotAcceptable                  = 406,
	TNTHttpStatusCodeProxyAuthenticationRequired    = 407,
	TNTHttpStatusCodeRequestTimeout                 = 408,
	TNTHttpStatusCodeConflict                       = 409,
	TNTHttpStatusCodeGone                           = 410,
	TNTHttpStatusCodeLengthRequired                 = 411,
	TNTHttpStatusCodePreconditionFailed             = 412,
	TNTHttpStatusCodeRequestEntityTooLarge          = 413,
	TNTHttpStatusCodeRequestURITooLong              = 414,
	TNTHttpStatusCodeUnsupportedMediaType           = 415,
	TNTHttpStatusCodeRequestedRangeNotSatisfiable	= 416,
    TNTHttpStatusCodeExpectationFailed              = 417,
	
	// Server Error 5xx
	TNTHttpStatusCodeInternalServerError            = 500,
	TNTHttpStatusCodeNotImplemented                 = 501,
	TNTHttpStatusCodeBadGateway                     = 502,
	TNTHttpStatusCodeServiceUnavailable             = 503,
	TNTHttpStatusCodeGatewayTimeout                 = 504,
	TNTHttpStatusCodeHTTPVersionNotSupported        = 505
};

/**
 *  Returns if a given HTTP status code represents a informational status
 */
#define IS_HTTP_STATUS_INFORMATIONAL(x)(((TNTHttpStatusCode)(x)) >= 100 && ((TNTHttpStatusCode)(x)) < 200)

/**
 *  Returns if a given HTTP status code represents a successful status
 */
#define IS_HTTP_STATUS_SUCCESS(x)(((TNTHttpStatusCode)(x)) >= 200 && ((TNTHttpStatusCode)(x)) < 300)

/**
 *  Returns if a given HTTP status code represents a redirection status
 */
#define IS_HTTP_STATUS_REDIRECTION(x)(((TNTHttpStatusCode)(x)) >= 300 && ((TNTHttpStatusCode)(x)) < 400)

/**
 *  Returns if a given HTTP status code represents a client error status
 */
#define IS_HTTP_STATUS_CLIENT_ERROR(x)(((TNTHttpStatusCode)(x)) >= 400 && ((TNTHttpStatusCode)(x)) < 500)

/**
 *  Returns if a given HTTP status code represents a server error status
 */
#define IS_HTTP_STATUS_SERVER_ERROR(x)(((TNTHttpStatusCode)(x)) >= 500 && ((TNTHttpStatusCode)(x)) < 600)

#endif
