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
  self.singleGifView = [[SingleGifView alloc] initWithDict:self.imageDict];
  self.singleGifView.delegate = self;
  [self setView:self.singleGifView];
  

}

#pragma mark - UINavigation

- (void)popViewController
{
  [self.navigationController popViewControllerAnimated:YES];
}

@end
