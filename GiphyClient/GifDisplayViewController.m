//
//  GifDisplayViewController.m
//  GiphyClient
//
//  Created by Jared Halpern on 9/11/15.
//  Copyright (c) 2015 byteMason. All rights reserved.
//

#import "GifDisplayViewController.h"
#import "SearchGifViewController.h"

@interface GifDisplayViewController ()
@property (nonatomic, strong) SearchGifViewController *searchVC;
@property (nonatomic, strong) NSLayoutConstraint *searchVCTopConstraint;
@property (nonatomic, strong) NSLayoutConstraint *searchVCHeightConstraint;

@end

@implementation GifDisplayViewController

#pragma mark - View Lifecycle

- (instancetype)init
{
  if (self = [super init]) {
    _dataArray = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.clipsToBounds = NO;
  
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  layout.minimumLineSpacing = 10.0;
  layout.minimumInteritemSpacing = 0.0;
  layout.scrollDirection = UICollectionViewScrollDirectionVertical;
  
  _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
  _collectionView.backgroundColor = [UIColor clearColor];
  _collectionView.showsHorizontalScrollIndicator = NO;
  _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
  _collectionView.delegate = self;
  _collectionView.dataSource = self;
  _collectionView.scrollEnabled = YES;
  //  [_collectionView setContentInset:UIEdgeInsetsMake(0, 10, 0, 10)];
  _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
  [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellReuseId];
  [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerCellReuseId];
  [self.view addSubview:_collectionView];
  
  _searchBar = [[UISearchBar alloc] init];
  _searchBar.barTintColor = kColorLightBlue;
  _searchBar.translatesAutoresizingMaskIntoConstraints = NO;
  _searchBar.delegate = self;
  _searchBar.searchBarStyle = UISearchBarStyleProminent;
  _searchBar.placeholder = NSLocalizedString(@"Search all the things", nil);
  _searchBar.clearsContextBeforeDrawing = YES;
  [_searchBar setShowsCancelButton:YES animated:YES];
  _searchBar.showsBookmarkButton = NO;
  _searchBar.translucent = NO;
  [self.view addSubview:_searchBar];
  
  [self setupConstraints];
  
}

- (void)setupConstraints
{
  self.constraints = [@[] mutableCopy];
  
  // collectionView
  [self.constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(22)-[_searchBar][_collectionView]|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:NSDictionaryOfVariableBindings(_searchBar,_collectionView)]];
  
  [self.constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collectionView]|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:NSDictionaryOfVariableBindings(_collectionView)]];
  // searchBar
  [self.constraints addObject:[NSLayoutConstraint constraintWithItem:_searchBar
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeWidth
                                                          multiplier:1.0
                                                            constant:0.0]];
  [self.view addConstraints:self.constraints];
}

- (void)dismissSearchGifViewController
{
  self.searchBar.text = nil;
  [self.searchBar resignFirstResponder];
  
  [UIView animateWithDuration:kTimeSearchVCSlide animations:^{
    [self.view removeConstraint:self.searchVCTopConstraint];
    [self.view removeConstraint:self.searchVCHeightConstraint];
    
    self.searchVCTopConstraint = [NSLayoutConstraint constraintWithItem:self.searchVC.view
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:0.0];
    
    [self.view addConstraint:self.searchVCTopConstraint];
    [self.view layoutIfNeeded];
    
  } completion:^(BOOL finished) {
    [self.searchVC willMoveToParentViewController:nil];
    [self.searchVC removeFromParentViewController];
    self.searchVC = nil;
  }];
}

- (void)showSearchGifViewController
{
  if (!self.searchVC) {
    self.searchVC = [[SearchGifViewController alloc] init];
    self.searchVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:self.searchVC];
    [self.searchVC didMoveToParentViewController:self];
    [self.view addSubview:self.searchVC.view];
    
    // Set up constraints
    NSMutableArray *constraints = [@[] mutableCopy];
    self.searchVCHeightConstraint = [NSLayoutConstraint constraintWithItem:self.searchVC.view
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeHeight
                                                                multiplier:1.0
                                                                  constant:-kNavBarHeight];
    
    self.searchVCTopConstraint = [NSLayoutConstraint constraintWithItem:self.searchVC.view
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:0.0];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.searchVC.view
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1.0
                                                         constant:0.0]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.searchVC.view
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1.0
                                                         constant:0.0]];
    
    [self.view addConstraint:self.searchVCHeightConstraint];
    [self.view addConstraint:self.searchVCTopConstraint];
    [self.view addConstraints:constraints];
    
    [self.view layoutIfNeeded];
    
    // Animate and slide in
    
    [UIView animateWithDuration:kTimeSearchVCSlide animations:^{
      [self.view removeConstraint:self.searchVCTopConstraint];
      
      self.searchVCTopConstraint = [NSLayoutConstraint constraintWithItem:self.searchVC.view
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0
                                                                 constant:kNavBarHeight];
      
      [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchVC.view
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0
                                                             constant:0.0]];
      
      [self.view addConstraint:self.searchVCTopConstraint];
      [self.view layoutIfNeeded];
      
    } completion:^(BOOL finished) {
      [self.searchVC didMoveToParentViewController:self];
    }];
  }
  
  __weak GifDisplayViewController *welf = self;
  [[APIManager sharedManager] searchTerms:self.searchBar.text withCompletion:^(NSArray *data) {
    welf.searchVC.dataArray = [data mutableCopy];
    [welf.searchVC.collectionView reloadData];
  }];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
  [self dismissSearchGifViewController];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  [self showSearchGifViewController];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 1.0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseId forIndexPath:indexPath];
  cell.backgroundColor = [UIColor blueColor];
  //  cell.clipsToBounds = YES;
  
  NSURL *imageURL = [self.dataArray objectAtIndex:indexPath.row][@"images"][@"fixed_height_downsampled"][@"url"];
  UIImageView *imageView = [[UIImageView alloc] init];
  [imageView sd_setImageWithURL:imageURL placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    
  }];
  
  imageView.translatesAutoresizingMaskIntoConstraints = NO;
  [cell addSubview:imageView];
  
  
  [cell addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                   attribute:NSLayoutAttributeCenterX
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:cell
                                                   attribute:NSLayoutAttributeCenterX
                                                  multiplier:1.0
                                                    constant:0.0]];
  
  [cell addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                   attribute:NSLayoutAttributeCenterY
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:cell
                                                   attribute:NSLayoutAttributeCenterY
                                                  multiplier:1.0
                                                    constant:0.0]];
  
  //  [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|"
  //                                                               options:0
  //                                                               metrics:nil
  //                                                                 views:NSDictionaryOfVariableBindings(imageView)]];
  
  [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[imageView]-(>=0)-|"
                                                               options:0
                                                               metrics:nil
                                                                 views:NSDictionaryOfVariableBindings(imageView)]];
  return cell;
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
  NSDictionary *dict =  [self.dataArray objectAtIndex:indexPath.row][@"images"][@"fixed_height_downsampled"];
  NSInteger width =  [[dict objectForKey:@"width"] integerValue];
  NSInteger height = [[dict objectForKey:@"height"] integerValue];
  return CGSizeMake(width, height);
}

@end
