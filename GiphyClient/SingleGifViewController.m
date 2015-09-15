//
//  SingleGifViewController.m
//  GiphyClient
//
//  Created by Jared Halpern on 9/11/15.
//  Copyright (c) 2015 byteMason. All rights reserved.
//

#import "SingleGifViewController.h"
#import "SingleGifView.h"

@interface SingleGifViewController ()
@property (nonatomic, strong) SingleGifView *singleGifView;
@property (nonatomic, strong) NSDictionary *imageDict;
@end

@implementation SingleGifViewController

- (instancetype)initWithDict:(NSDictionary *)imageDict
{
  if (self = [super init]) {
    NSAssert(imageDict, @"Must initialize with dictionary.");
    _imageDict = imageDict;
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
  return self;
}

- (void)viewDidLoad
{
  _singleGifView = [[SingleGifView alloc] initWithDict:_imageDict];
  self.singleGifView.delegate = self;
  [self setView:_singleGifView];
}

#pragma mark - SingleGifViewDelegate

- (void)shareSMSButtonPressed
{
  [self share];
}

- (void)copyToClipboardButtonPressed
{
  [self share];
}

- (void)share
{
  NSURL *imageURL = [NSURL URLWithString:self.imageDict[@"images"][@"fixed_height"][@"url"]];
  NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
  NSArray *objectsToShare = @[imageData];
  
  UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
  activityVC.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError){
    if (activityError) {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:activityError.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
      [alert show];
    } else if (completed){
      NSLog(@"%@", activityType);
      if ([activityType isEqualToString:@"com.apple.UIKit.activity.SaveToCameraRoll"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
      } else if ([activityType isEqualToString:@"com.apple.UIKit.activity.CopyToPasteboard"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Copied!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
      } else if ([activityType isEqualToString:@"com.apple.UIKit.activity.Message"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Sent!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
      }
    }
  };
  
  NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                 UIActivityTypePrint,
                                 UIActivityTypePostToFacebook,
                                 UIActivityTypePostToTwitter,
                                 UIActivityTypeAssignToContact,
                                 UIActivityTypeAddToReadingList,
                                 UIActivityTypePostToFlickr,
                                 UIActivityTypePostToWeibo,
                                 UIActivityTypeMail,
                                 UIActivityTypePostToVimeo];
  
  activityVC.excludedActivityTypes = excludeActivities;
  
  [self presentViewController:activityVC animated:YES completion:nil];
}
@end
