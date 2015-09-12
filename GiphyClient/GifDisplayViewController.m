//
//  GifDisplayViewController.m
//  GiphyClient
//
//  Created by Jared Halpern on 9/11/15.
//  Copyright (c) 2015 byteMason. All rights reserved.
//

#import "GifDisplayViewController.h"

@interface GifDisplayViewController ()

@end

static NSString *cellReuseId = @"reuse id";

@implementation GifDisplayViewController

- (instancetype)init
{
  if (self = [super init]) {
    _dataArray = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)viewDidLoad
{
  _searchBar = [[UISearchBar alloc] init];
  _searchBar.barTintColor = [UIColor whiteColor];
  _searchBar.translatesAutoresizingMaskIntoConstraints = NO;
  _searchBar.delegate = self;
  _searchBar.searchBarStyle = UISearchBarStyleProminent;
  _searchBar.placeholder = NSLocalizedString(@"Search", nil);
  _searchBar.clearsContextBeforeDrawing = YES;
  _searchBar.showsCancelButton = NO;
  _searchBar.translucent = NO;
  [self.view addSubview:_searchBar];
  
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  layout.minimumLineSpacing = 10.;
  layout.minimumInteritemSpacing = 10.;
  layout.scrollDirection = UICollectionViewScrollDirectionVertical;
  
  _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
  _collectionView.backgroundColor = [UIColor clearColor];
  _collectionView.showsHorizontalScrollIndicator = NO;
  _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
  _collectionView.delegate = self;
  _collectionView.dataSource = self;
  _collectionView.scrollEnabled = YES;
  _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
  [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellReuseId];
  [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
  [self.view addSubview:_collectionView];
  [self setupConstraints];
}

- (void)setupConstraints
{
  NSMutableArray *constraints = [@[] mutableCopy];
  [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
  [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
  [self.view addConstraints:constraints];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseId forIndexPath:indexPath];
  cell.backgroundColor = [UIColor clearColor];
  
  NSURL *imageURL = [self.dataArray objectAtIndex:indexPath.row][@"images"][@"fixed_height_downsampled"][@"url"];
  UIImageView *imageView = [[UIImageView alloc] init];
  [imageView sd_setImageWithURL:imageURL placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    
  }];
  imageView.translatesAutoresizingMaskIntoConstraints = NO;
  [cell addSubview:imageView];
  
  [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
  [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
  return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
  UICollectionReusableView *reusableView = nil;
  if (kind == UICollectionElementKindSectionHeader){
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    headerView.backgroundColor = kColorYellow;
    reusableView = headerView;
  }
  return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
  return CGSizeMake(10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[self.dataArray objectAtIndex:indexPath.row]];
  SingleGifViewController *singleGifVC = [[SingleGifViewController alloc] initWithDict:dataDict];
  [self.navigationController pushViewController:singleGifVC animated:YES];
  self.navigationController.navigationBarHidden = NO;
}

#pragma mark - UICollectionViewFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return CGSizeMake(365, 200);
}

@end
