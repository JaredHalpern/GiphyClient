//
//  SearchGifViewController.m
//  GiphyClient
//
//  Created by Jared Halpern on 9/13/15.
//  Copyright (c) 2015 byteMason. All rights reserved.
//

#import "SearchGifViewController.h"

@implementation SearchGifViewController

- (instancetype)init
{
  if (self = [super init]) {
    
  }
  return self;
}

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self setupConstraints];
  _searchTerms = @"";
}

#pragma mark - Container View

- (void)willMoveToParentViewController:(UIViewController *)parent
{
  [super willMoveToParentViewController:parent];
  self.collectionView.backgroundColor = kColorYellow;
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
  [super didMoveToParentViewController:parent];
}

- (void)setupConstraints
{
  [self.view removeConstraints:self.constraints];
  NSMutableArray *newConstraints = [@[] mutableCopy];
  
  UICollectionView *collectionView = self.collectionView;

//  [newConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(62)-[collectionView]|"
  [newConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:NSDictionaryOfVariableBindings(collectionView)]];
  
  [newConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:NSDictionaryOfVariableBindings(collectionView)]];
  [self.view addConstraints:newConstraints];
}

#pragma mark - UICollectionViewLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
  return CGSizeMake(10, 40);
}


#pragma mark - UICollectionViewDataSource

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
  UICollectionReusableView *reusableView = nil;

  if (kind == UICollectionElementKindSectionHeader){
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerCellReuseId forIndexPath:indexPath];
    headerView.backgroundColor = kColorLightBlue;
//    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *searchResults = [[UILabel alloc] init];
//    searchResults.translatesAutoresizingMaskIntoConstraints = NO;
    searchResults.text = [NSString stringWithFormat:@"Results for: %@", self.searchTerms];
    [headerView addSubview:searchResults];
    
    NSMutableArray *constraints = [@[] mutableCopy];
    
//    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[searchResults]"
//                                                                   options:0
//                                                                   metrics:nil
//                                                                     views:NSDictionaryOfVariableBindings(searchResults)]];

//    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[searchResults]"
//                                                                   options:NSLayoutFormatAlignAllLeft
//                                                                   metrics:nil
//                                                                     views:NSDictionaryOfVariableBindings(searchResults)]];
    
//    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[headerView]"
//                                                                   options:0
//                                                                   metrics:nil
//                                                                     views:NSDictionaryOfVariableBindings(headerView)]];
//
//    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[headerView(22.0)]"
//                                                                   options:NSLayoutFormatAlignAllTop
//                                                                   metrics:nil//@{@"headerHeight" : @22.0}
//                                                                     views:NSDictionaryOfVariableBindings(headerView)]];
    [self.view addConstraints:constraints];

    reusableView = headerView;
  }
  return reusableView;
}

@end






