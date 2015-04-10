//
//  ViewController.h
//  CatifyMe-OBJ-C
//
//  Created by Joey LaBarck on 1/22/15.
//  Copyright (c) 2015 LaBarck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatConnectionLayer.h"
#import "CatifyMe_OBJ_C-Swift.h"

@import MessageUI;

@interface ViewController : UIViewController <CatDelegate, UIGestureRecognizerDelegate, UINavigationBarDelegate, MFMessageComposeViewControllerDelegate, SwiftConnectionDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *urlDisplay;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityMonitor;
@property (nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic) UILongPressGestureRecognizer *longTapRecognizer;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;


@end

