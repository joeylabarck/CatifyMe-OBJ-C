//
//  ViewController.m
//  CatifyMe-OBJ-C
//
//  Created by Joey LaBarck on 1/22/15.
//  Copyright (c) 2015 LaBarck. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self configureURLDisplay];
    [_activityMonitor setHidesWhenStopped:YES];
    [self setViewForFetching];
    [self refresh:nil];
    [self configureGestureRecognizer];
    [self configureDisplay];
    [self configureImageDisplay];
}

#pragma mark - User Interface

- (void)configureImageDisplay {
    _imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _imageView.layer.shadowOffset = CGSizeZero;
    _imageView.layer.shadowOpacity = 0.7;
    _imageView.layer.shadowRadius = 10.0;
    
}

- (void)configureDisplay {
    _navBar.delegate = self;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)configureURLDisplay {
    //[_urlDisplay setShadowColor:[UIColor colorWithWhite:0.5 alpha:0.3]];
    [_urlDisplay.layer setShadowRadius:3.0];
    [_urlDisplay.layer setShadowColor:[UIColor blackColor].CGColor];
    [_urlDisplay.layer setShadowOffset:CGSizeZero];
    [_urlDisplay.layer setShadowOpacity:0.3];
}

- (void)setViewForFetching {
    //Empty the current image and label
    _imageView.image = nil;
    _urlDisplay.text = nil;
    _progressLabel.text = @"Catifying...";
    
    //Activity Monitor
    [_activityMonitor startAnimating];
}

#pragma mark - Gesture Recognizers

- (void)configureGestureRecognizer {
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refresh:)];
    [_tapRecognizer setNumberOfTapsRequired:1];
    [_tapRecognizer setNumberOfTouchesRequired:1];
    _tapRecognizer.delegate = self;
    _imageView.userInteractionEnabled = YES;
    [_imageView addGestureRecognizer:_tapRecognizer];
    
    _longTapRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(save:)];
    //[_longTapRecognizer setNumberOfTapsRequired:1];
    //[_longTapRecognizer setNumberOfTouchesRequired:1];
    [_longTapRecognizer setMinimumPressDuration:0.5];
    _longTapRecognizer.delegate = self;
    [_imageView addGestureRecognizer:_longTapRecognizer];
    
}

#pragma mark - Gesture Handling

- (void)refresh:(UITapGestureRecognizer *)tap {
    [_tapRecognizer setEnabled:NO];
    [self setViewForFetching];
    //CatConnectionLayer *connectionLayer = [CatConnectionLayer new];
    //connectionLayer.delegate = self;
    //[connectionLayer getNewCat];
    SwiftConnectionLayer *swiftConnectionLayer = [SwiftConnectionLayer new];
    [swiftConnectionLayer getNewCat];
    swiftConnectionLayer.delegate = self;
}

- (void)save:(UILongPressGestureRecognizer *)lpg {
    if (lpg.state == UIGestureRecognizerStateBegan)
    {
    // Show an alertview
    UIAlertController *saveImageAlertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save Image" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSOperationQueue *newQueue = [[NSOperationQueue alloc] init];
        [newQueue addOperationWithBlock:^{
            UIImageWriteToSavedPhotosAlbum(_imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"Share Image" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if ([MFMessageComposeViewController canSendText] && [MFMessageComposeViewController canSendAttachments]) {
            //Create Message
            MFMessageComposeViewController *messageController = [MFMessageComposeViewController new];
            messageController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            messageController.messageComposeDelegate = self;
            messageController.body = @"Check out this cat I found on CatifyMe!";
            BOOL isAttached = [messageController addAttachmentData:UIImageJPEGRepresentation(_imageView.image, 1) typeIdentifier:@"image/jpeg" filename:@"Cat.png"];
            if (isAttached)
                NSLog(@"Attached!");
            [self presentViewController:messageController animated:YES completion:nil];
            
        }
    }];
    UIAlertAction *copyLinkAction = [UIAlertAction actionWithTitle:@"Copy Link" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _urlDisplay.text;
    }];
        
    [saveImageAlertController addAction:shareAction];
    [saveImageAlertController addAction:saveAction];
    [saveImageAlertController addAction:copyLinkAction];
    [saveImageAlertController addAction:cancelAction];
    [self showViewController:saveImageAlertController sender:nil];
    }
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
}

#pragma mark - UINavigationBarDelegate

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

#pragma mark - CatDelegate Method

- (void)receivedNewCat:(UIImage *)catImage withSourceURL:(NSString *)sourceURL {
    NSOperationQueue *UIQueue = [NSOperationQueue mainQueue];
    [UIQueue addOperationWithBlock:^{
        _imageView.image = catImage;
        _urlDisplay.text = sourceURL;
        _progressLabel.text = nil;
        [_activityMonitor stopAnimating];
        [_tapRecognizer setEnabled:YES];
    }];
}

- (void)receivedNewCatWithSourceURL:(UIImage * __nonnull)image sourceURL:(NSString * __nonnull)sourceURL {
    NSOperationQueue *UIQueue = [NSOperationQueue mainQueue];
    [UIQueue addOperationWithBlock:^{
        _imageView.image = image;
        _urlDisplay.text = sourceURL;
        _progressLabel.text = nil;
        [_activityMonitor stopAnimating];
        [_tapRecognizer setEnabled:YES];
    }];
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
