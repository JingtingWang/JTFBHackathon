//
//  JTFBYelpServices.m
//  JTFBHachathon
//
//  Created by Jingting Wang on 3/29/14.
//  Copyright (c) 2014 JT. All rights reserved.
//

#import "JTFBYelpServices.h"
#import <NXOAuth2Client/NXOAuth2.h>

@interface JTFBYelpServices()
{
    NSMutableData *_responseData;
}
@end

@implementation JTFBYelpServices
#pragma mark-- Internal Constants
static NSString* const kProtocolPrefix = @"http://";
static NSString* const kBaseDomain = @"api.yelp.com";
// --- HTTP header values ---
static NSString* const kHeaderContentTypeField = @"Content-Type";
static NSString* const kHeaderContentTypeDefaultValue = @"application/json";
// --- Request Path ---
static NSString* const kSearchPath = @"v2/search";
// --- Request Parameters ---
static NSString *const kTermValueTemplate = @"term=%@";         // for search terms
static NSString *const kLimitValueTemplate = @"limit=%@";       // limits search to this number
static NSString *const kLongituteValueTemplate = @"long=%@";    // longitude
static NSString *const kLatitudeValueTemplate = @"lat=%@";      // latitude
static NSString *const kLRadiusValueTemplate = @"radius=%@";    // radius of search
// --- JSON Response Keys ---
static NSString *const kBusinessesKey = @"businesses";             // gets list of businesses
static NSString *const kNameKey = @"name";                         // name of business
static NSString *const kURLKey = @"url";                           // url of business
static NSString *const kAddress1Key = @"address1";                 // address line 1
static NSString *const kAddress2Key = @"address2";                 // address line 2

static NSString *const kMessageKey = @"message";                   // message
static NSString *const kCodeKey = @"code";
static NSString *const kTextKey = @"text";
// --- Consumer Key & Secret ---
static NSString *const kConsumerKey = @"eJ49gQi5fkHAM2rMa73FUQ";
static NSString *const kConsumerSecret = @"AnrwSOVoxcB5K1wV5GfLjMK-WHw";
// --- Token Key & Secret ---
static NSString *const kTokenKey = @"-T-PbDqZIiCuenTd50V0DIN6wwH2GgQS";
static NSString *const kTokenSecret = @"bQcTm7dglbFlKgW--KoK_RmlDiw";


- (void)searchRestaurants:(NSString *)name
{
    NSURL *URL = [NSURL URLWithString:@"http://api.yelp.com/v2/search?term=restaurants&location=new%20york"];
//    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:kConsumerKey secret:kConsumerSecret];
//    OAToken *token = [[OAToken alloc] initWithKey:kTokenKey secret:kTokenSecret];
//    
//    id<OASignatureProviding, NSObject> provider = [[OAHMAC_SHA1SignatureProvider alloc] init];
//    NSString *realm = nil;
//    
//    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:URL
//                                                                   consumer:consumer
//                                                                      token:token
//                                                                      realm:realm
//                                                          signatureProvider:provider];
//    [request prepare];
//    
    _responseData = [[NSMutableData alloc] init];
    
//    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    ///id JSON = [_responseData yajl_JSON];
    
}
@end
