//
//  SingleGifViewController.m
//  GiphyClient
//
//  Created by Jared Halpern on 9/11/15.
//  Copyright (c) 2015 byteMason. All rights reserved.
//

#import "SingleGifViewController.h"
#import "SingleGifView.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface SingleGifViewController ()
@property (nonatomic, strong) SingleGifView *singleGifView;
@property (nonatomic, strong) NSDictionary  *imageDict;
@property (nonatomic, strong) NSData        *imageData;
@end

@implementation SingleGifViewController

- (instancetype)initWithDict:(NSDictionary *)imageDict
{
  if (self = [super init]) {
    NSAssert(imageDict, @"Must initialize with dictionary.");
    _imageDict = imageDict;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self downloadImageDataInBackgroundWithCompletion:^{
//      NSLog(@"%s - downloaded imagedata in background", __PRETTY_FUNCTION__);
    }];
  }
  return self;
}

- (void)viewDidLoad
{
  _singleGifView = [[SingleGifView alloc] initWithDict:_imageDict];
  self.singleGifView.delegate = self;
  [self setView:_singleGifView];
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
  switch (result) {
      
    case MessageComposeResultCancelled:
      break;
      
    case MessageComposeResultFailed:
    {
      UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to send SMS." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
      [warningAlert show];
      break;
    }
      
    case MessageComposeResultSent:
    default:
      break;
  }
  
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SingleGifViewDelegate

- (void)shareSMSButtonPressed
{
  [self shareViaSMS];
}

- (void)copyToClipboardButtonPressed
{
  [self copyToClipboard];
}

#pragma mark - Private

- (void)downloadImageDataInBackgroundWithCompletion:(void (^)(void))completion
{
  __weak SingleGifViewController *welf = self;
  
  // Download raw data in background for faster performance if/when sharing/copying
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    NSURL *imageURL = [NSURL URLWithString:welf.imageDict[@"images"][@"fixed_height"][@"url"]];
    NSURLSession *defaultSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:imageURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      
      if (error) {
        NSLog(@"%s - %@", __PRETTY_FUNCTION__, error.description);
        
      } else {
        NSLog(@"%s - done downloading data", __PRETTY_FUNCTION__);
        
        welf.imageData = data;
        
        if (completion) {
          completion();
        }
      }
    }];
    [dataTask resume];
  });
  
}

- (void)copyToClipboard
{
  UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
  CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)@"gif", NULL);
  
  if (!self.imageData) {
    __weak SingleGifViewController *welf = self;
    
    [self downloadImageDataInBackgroundWithCompletion:^{
      [pasteboard setData:welf.imageData forPasteboardType:(__bridge NSString *)uti];
      
      if (uti){
        CFRelease(uti);
      }
    }];
  } else {
    [pasteboard setData:self.imageData forPasteboardType:(__bridge NSString *)uti];
    
    if (uti){
      CFRelease(uti);
    }
  }
}

- (void)shareViaSMS
{
  if (![MFMessageComposeViewController canSendText]) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot send text!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    return;
  }
  
  MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
  messageController.messageComposeDelegate = self;
  
  if (!self.imageData) {
    // if we dont have the imagedata for some reason.
    // this will be called rarely, but since we send the image data to a background queue initially, we shouldn't make assumptions
    // that we'll always have the data by the time the user hits the send button, especially if its a great gif and they're excited to send it.
    
    __weak SingleGifViewController *welf = self;
    
    [self downloadImageDataInBackgroundWithCompletion:^{
      [messageController addAttachmentData:welf.imageData
                            typeIdentifier:(NSString *)kUTTypeGIF
                                  filename:@"image.gif"];
      
      dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:messageController animated:YES completion:nil];
      });
    }];
  } else {
    [messageController addAttachmentData:self.imageData
                          typeIdentifier:(NSString *)kUTTypeGIF
                                filename:@"image.gif"];
    
    [self presentViewController:messageController animated:YES completion:nil];
  }
}

/*
 // New way of sharing via UIActivityViewController
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
 */
@end
