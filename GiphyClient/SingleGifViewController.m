//
//  SingleGifViewController.m
//  GiphyClient
//
//  Created by Jared Halpern on 9/11/15.
//  Copyright (c) 2015 byteMason. All rights reserved.
//

#import "SingleGifViewController.h"
#import "SingleGifView.h"
#import <SVProgressHUD.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

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
  [SVProgressHUD show];
  [self shareViaSMS];
}

- (void)copyToClipboardButtonPressed
{
  [SVProgressHUD show];
  [self copyToClipboard];
}

- (void)saveToPhotosButtonPressed
{
  [SVProgressHUD show];
  [self saveToPhotos];
}

#pragma mark - Private

- (void)downloadOriginalImageDataInBackgroundWithCompletion:(void (^)(void))completion
{
  __weak SingleGifViewController *welf = self;
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    NSURL *imageURL = [NSURL URLWithString:welf.imageDict[@"images"][@"original"][@"url"]];
    NSURLSession *defaultSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:imageURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      
      if (error) {
        NSLog(@"%s - %@", __PRETTY_FUNCTION__, error.description);
        
      } else {
        welf.imageData = data;
        
        if (completion) {
          completion();
        }
      }
    }];
    [dataTask resume];
  });
  
}

- (void)saveToPhotos
{
  ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
  
  if (!self.imageData) {
    __weak SingleGifViewController *welf = self;
    
    [self downloadOriginalImageDataInBackgroundWithCompletion:^{
      
      [library writeImageDataToSavedPhotosAlbum:welf.imageData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        NSLog(@"%s", __PRETTY_FUNCTION__);
      }];
      
      dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
      });
    }];
    
  } else {
    [library writeImageDataToSavedPhotosAlbum:self.imageData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
      NSLog(@"%s", __PRETTY_FUNCTION__);
    }];
    [SVProgressHUD dismiss];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
  }
}

- (void)copyToClipboard
{
  UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
  CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)@"gif", NULL);
  
  if (!self.imageData) {
    __weak SingleGifViewController *welf = self;
    
    [self downloadOriginalImageDataInBackgroundWithCompletion:^{
      [pasteboard setData:welf.imageData forPasteboardType:(__bridge NSString *)uti];
      [SVProgressHUD dismiss];
      if (uti){
        CFRelease(uti);
      }
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Copied!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
      [alert show];
    }];
  } else {
    [pasteboard setData:self.imageData forPasteboardType:(__bridge NSString *)uti];
    [SVProgressHUD dismiss];
    if (uti){
      CFRelease(uti);
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Copied!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
  }
}

- (void)shareViaSMS
{
  if (![MFMessageComposeViewController canSendText]) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot send text!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [SVProgressHUD dismiss];
    return;
  }
  
  MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
  messageController.messageComposeDelegate = self;
  
  if (!self.imageData) {    
    __weak SingleGifViewController *welf = self;
    
    [self downloadOriginalImageDataInBackgroundWithCompletion:^{
      [messageController addAttachmentData:welf.imageData
                            typeIdentifier:(NSString *)kUTTypeGIF
                                  filename:@"image.gif"];
      
      dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self presentViewController:messageController animated:YES completion:nil];
      });
    }];
  } else {
    [messageController addAttachmentData:self.imageData
                          typeIdentifier:(NSString *)kUTTypeGIF
                                filename:@"image.gif"];
    [SVProgressHUD dismiss];
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
