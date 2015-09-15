//
//  TrendingViewController.m
//  GiphyClient
//
//  Created by Jared Halpern on 9/11/15.
//  Copyright (c) 2015 byteMason. All rights reserved.
//

#import "TrendingViewController.h"
#import "GifDisplayViewController.h"

@interface TrendingViewController ()
@end

@implementation TrendingViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [SVProgressHUD show];
  self.loadingGifs = YES;
  __weak TrendingViewController *welf = self;
  
  [[APIManager sharedManager] getTrendingGifsWithOffset:self.offset andCompletion:^(NSArray *data, NSInteger offset) {
    welf.dataArray = [[welf.dataArray arrayByAddingObjectsFromArray:data] mutableCopy];
    welf.offset = offset;
    [welf.collectionView reloadData];
    self.loadingGifs = NO;
    [SVProgressHUD dismiss];
  }];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = YES;
}

@end
