//
//  GifDisplayViewController.h
//  GiphyClient
//
//  Created by Jared Halpern on 9/11/15.
//  Copyright (c) 2015 byteMason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "APIManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SingleGifViewController.h"

static NSString *cellReuseId = @"reuseId";
static NSString *headerCellReuseId = @"headerCellReuseId";

@interface GifDisplayViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *constraints;
@property (strong, nonatomic) UISearchBar *searchBar;
@end
