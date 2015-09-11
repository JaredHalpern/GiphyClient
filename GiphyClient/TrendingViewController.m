//
//  TrendingViewController.m
//  GiphyClient
//
//  Created by Jared Halpern on 9/11/15.
//  Copyright (c) 2015 byteMason. All rights reserved.
//

#import "TrendingViewController.h"
#import "APIManager.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface TrendingViewController ()
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

static NSString *cellReuseId = @"reuse id";

@implementation TrendingViewController

- (instancetype)init
{
  if (self = [super init]) {
    
    _dataArray = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
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
  [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellReuseId];
  [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
  [self.view addSubview:_collectionView];
  [self setupConstraints];
  [[APIManager sharedManager] getTrendingGifsWithCompletion:^(NSArray *data) {
    self.dataArray = [data copy];
    [self.collectionView reloadData];
  }];
}

- (void)setupConstraints
{
  NSMutableArray *constraints = [@[] mutableCopy];
  [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
  [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
  [self.view addConstraints:constraints];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//  NSLog(@"%s - %lu items in collection:", __PRETTY_FUNCTION__, (unsigned long)self.dataArray.count);
  return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseId forIndexPath:indexPath];
  cell.backgroundColor = [UIColor redColor];
//  NSURL *imageURL = [self.dataArray objectAtIndex:indexPath.row][@"images"][@"fixed_height_downsampled"][@"url"];
  
  NSURL *imageURL = [NSURL URLWithString:@"https://images-cdn.fantasyflightgames.com/filer_public/b2/1a/b21a44d1-eaa2-4fd2-826f-2e9e3d4136da/l5r-logo-png-1.png"];
  UIImageView *imageView = [[UIImageView alloc] init];
  [imageView setImageWithURL:imageURL];
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
    headerView.backgroundColor = [UIColor blueColor];
    reusableView = headerView;
  }
  return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
  return CGSizeMake(10, 10);
}


#pragma mark - UICollectionViewFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return CGSizeMake(365, 200);
}


@end
