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

- (instancetype)init
{
  if (self = [super init]) {
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [[APIManager sharedManager] getTrendingGifsWithCompletion:^(NSArray *data) {
    self.dataArray = [[self.dataArray arrayByAddingObjectsFromArray:data] mutableCopy]; // append, don't overwrite
    [self.collectionView reloadData];
  }];  
}

@end
