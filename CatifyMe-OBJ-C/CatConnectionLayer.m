//
//  CatConnectionLayer.m
//  CatifyMe-OBJ-C
//
//  Created by Joey LaBarck on 1/24/15.
//  Copyright (c) 2015 LaBarck. All rights reserved.
//

#import "CatConnectionLayer.h"
#import "CatConstants.h"

@implementation CatConnectionLayer

- (void)getNewCat {
    
    //Start Connection to the API, and receive picture and source url
    [self startConnection];
}

// This method starts the NSURLConnection, invokes delegate methods conforming to NSURLConnectionDataDelegate Protocol
- (void)startConnection {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kCatifyMeURLString]];
    request.HTTPMethod = @"POST";
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    if (connection) {
        [connection start];
    }
}

// Grabs Image url and source url from the dictionary
- (void)parseJSONDictionary:(NSDictionary *)json
{
    NSDictionary *imageDescriptor = [NSDictionary new];
    imageDescriptor = [[[json objectForKey:kDataKey] objectForKey:kImagesKey] objectForKey:kImageKey];
    idString = [imageDescriptor objectForKey:kIDKey];
    urlString = [imageDescriptor objectForKey:kURLKey];
    sourceURLString = [imageDescriptor objectForKey:kSourceURLKey];
    
    //NSLog(@"Image Descriptor:\nID: %@\nSource URL: %@\nURL: %@", idString,sourceURLString,urlString);
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
    
    [self.delegate receivedNewCat:image withSourceURL:urlString];
    
}

#pragma mark - NSURLConnectionDataDelegate Methods

// This delegate method, informs the receiver that data has been received, and in turns converts the NSData object to a JSON Serialized NSDictionary object
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //NSLog(@"Data: %@", data);
    NSDictionary *responseDictionary = [NSDictionary new];
    responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    [self parseJSONDictionary:responseDictionary];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"Response: %@", response);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //NSLog(@"Error: %@", error);
}

@end
