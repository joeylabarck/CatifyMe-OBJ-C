//
//  CatConnectionLayer.h
//  CatifyMe-OBJ-C
//
//  Created by Joey LaBarck on 1/24/15.
//  Copyright (c) 2015 LaBarck. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@protocol CatDelegate <NSObject>
@required
- (void)receivedNewCat:(UIImage *)catImage withSourceURL:(NSString *)sourceURL;
@end

@interface CatConnectionLayer : NSObject <NSURLConnectionDataDelegate>
{
    NSString *urlString;
    NSString *sourceURLString;
    NSString *idString;
}
@property (weak, nonatomic) id <CatDelegate> delegate;

// This method will return an NSDictionary object containing an image(UIImage) and a source url(NSString)
- (void)getNewCat;

@end
