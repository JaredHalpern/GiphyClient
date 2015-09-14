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
  
  __weak TrendingViewController *welf = self;
  
  [[APIManager sharedManager] getTrendingGifsWithCompletion:^(NSArray *data) {
    welf.dataArray = [[welf.dataArray arrayByAddingObjectsFromArray:data] mutableCopy];
    [welf.collectionView reloadData];
  }];  
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = YES;  
}

@end
