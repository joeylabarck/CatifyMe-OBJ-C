//
//  CatConnectionLayer.m
//  CatifyMe-OBJ-C
//
//  Created by Joey LaBarck on 1/24/15.
//  Copyright (c) 2015 LaBarck. All rights reserved.
//

#import "CatConnectionLayer.h"
#import "CatConstants.h"

@interface CatConnectionLayer ()
@property NSOperationQueue *downloadQueue;
@end

@implementation CatConnectionLayer

- (instancetype)init {
    self = [super init];
    if (self) {
        _downloadQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)getNewCat {
    [self startConnection];
}

// This method starts the NSURLConnection, invokes delegate methods conforming to NSURLConnectionDataDelegate Protocol
- (void)startConnection {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kCatifyMeURLString]];
    request.HTTPMethod = @"POST";
    [NSURLConnection sendAsynchronousRequest:request queue:_downloadQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (![NSThread isMainThread]) {
            NSDictionary *responseDictionary = [[NSDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
            [self parseJSONDictionary:responseDictionary];
        }
    }];
}

// Grabs Image url and source url from the dictionary
- (void)parseJSONDictionary:(NSDictionary *)json {
    if (![NSThread isMainThread]) {
        NSDictionary *imageDescriptor = [NSDictionary new];
        imageDescriptor = [[[json objectForKey:kDataKey] objectForKey:kImagesKey] objectForKey:kImageKey];
        idString = [imageDescriptor objectForKey:kIDKey];
        urlString = [imageDescriptor objectForKey:kURLKey];
        sourceURLString = [imageDescriptor objectForKey:kSourceURLKey];
    
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
    
        [self.delegate receivedNewCat:image withSourceURL:urlString];
    }
}

@end
