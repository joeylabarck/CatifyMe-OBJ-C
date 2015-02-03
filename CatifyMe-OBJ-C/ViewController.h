//
//  ViewController.h
//  CatifyMe-OBJ-C
//
//  Created by Joey LaBarck on 1/22/15.
//  Copyright (c) 2015 LaBarck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatConnectionLayer.h"

@interface ViewController : UIViewController <CatDelegate, UIGestureRecognizerDelegate, UINavigationBarDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *urlDisplay;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityMonitor;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) UILongPressGestureRecognizer *longTapRecognizer;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;


@end

