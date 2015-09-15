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
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;
@end

@implementation GifDisplayViewController

#pragma mark - View Lifecycle

- (instancetype)init
{
  if (self = [super init]) {
    _dataArray = [[NSMutableArray alloc] init];
//    _offset = 0;
    _loadingGifs = NO;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  _offset = 0;
  self.view.clipsToBounds = NO;
  
  UIColor *backgroundColor = [UIColor colorWithRed:145./256. green:223./256. blue:221./256. alpha:1.0]; // light blue
  UIColor *foregroundColor = [UIColor colorWithRed:79./256. green:136./256. blue:134./256. alpha:1.0]; // yellow
  [SVProgressHUD setBackgroundColor:backgroundColor];
  [SVProgressHUD setForegroundColor:foregroundColor];
  _collectionViewLayout= [[UICollectionViewFlowLayout alloc] init];
//  _collectionViewLayout.minimumLineSpacing = 10.0;
  _collectionViewLayout.minimumInteritemSpacing = 0.0;
  _collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
  
  _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_collectionViewLayout];
  _collectionView.backgroundColor = [UIColor clearColor];
  _collectionView.showsHorizontalScrollIndicator = NO;
  _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
  _collectionView.delegate = self;
  _collectionView.dataSource = self;
  _collectionView.scrollEnabled = YES;
  _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
  _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
  [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellReuseId];
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
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
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
  
  [self.constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_collectionView]-|"
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
  [self.view layoutIfNeeded];
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
    [self.searchVC.view removeFromSuperview];
    [self.searchVC removeFromParentViewController];
    [self.view layoutIfNeeded];
//    self.searchVC = nil;
  }];
}

- (void)showSearchGifViewController
{
    self.searchVC = [[SearchGifViewController alloc] init];
    self.searchVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:self.searchVC];
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
    
    // Animate and slide in Search VC
    
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
  
  self.searchVC.loadingGifs = YES;
  
  // could move this to SearchGifViewController
  __weak GifDisplayViewController *welf = self;
  
  [[APIManager sharedManager] searchTerms:self.searchBar.text withOffset:(self.offset) andCompletion:^(NSArray *data, NSString *searchTerms, NSInteger offset) {
    [welf.searchVC setSearchTerms:searchTerms];    
    welf.searchVC.offset = offset;
    welf.searchVC.dataArray = [data mutableCopy]; // don't want to append here since we're doing a new search
    [self.searchVC.collectionView reloadData];
    [SVProgressHUD dismiss];
    self.searchVC.loadingGifs = NO;
    [self.searchBar resignFirstResponder];    
  }];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
  [self dismissSearchGifViewController];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  [SVProgressHUD show];
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
  //  cell.translatesAutoresizingMaskIntoConstraints = NO;
//  cell.backgroundColor = [UIColor blueColor];
  cell.clipsToBounds = YES;
  
  NSURL *imageURL = [self.dataArray objectAtIndex:indexPath.row][@"images"][@"fixed_height_downsampled"][@"url"];
  UIImageView *imageView = [[UIImageView alloc] init];
  imageView.translatesAutoresizingMaskIntoConstraints = NO;
  
  [imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"nyan.png"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    
  }];
  
  [cell.contentView addSubview:imageView];
  
  //  [cell addConstraint:[NSLayoutConstraint constraintWithItem:imageView
  //                                                   attribute:NSLayoutAttributeCenterX
  //                                                   relatedBy:NSLayoutRelationEqual
  //                                                      toItem:cell
  //                                                   attribute:NSLayoutAttributeCenterX
  //                                                  multiplier:1.0
  //                                                    constant:0.0]];
  //
  //  [cell addConstraint:[NSLayoutConstraint constraintWithItem:imageView
  //                                                   attribute:NSLayoutAttributeCenterY
  //                                                   relatedBy:NSLayoutRelationEqual
  //                                                      toItem:cell
  //                                                   attribute:NSLayoutAttributeCenterY
  //                                                  multiplier:1.0
  //                                                    constant:0.0]];
  
  [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(imageView)]];
  
  [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[imageView]-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(imageView)]];
  
//  NSLog(@"cell size: %f, %f", cell.frame.size.width, cell.frame.size.height);
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  NSAssert(indexPath, @"need index path");
  NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[self.dataArray objectAtIndex:indexPath.row]];
  
  SingleGifViewController *singleGifVC = [[SingleGifViewController alloc] initWithDict:dataDict];
  [self.navigationController pushViewController:singleGifVC animated:YES];
  self.navigationController.navigationBarHidden = NO;
}

#pragma mark - UICollectionViewFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//  CGSize result = [[UIScreen mainScreen] bounds].size;
//  CGFloat scale = [UIScreen mainScreen].scale;
//  result = CGSizeMake(result.width * scale, result.height * scale);
//  CGFloat cellWidth =  [[UIScreen mainScreen] bounds].size.width - 20;
//  CGFloat cellHeight = [[UIScreen mainScreen] bounds].size.height - 120;
//  NSLog(@"screen size: %f, %f", result.width, result.height);
  
  NSDictionary *dict =  [self.dataArray objectAtIndex:indexPath.row][@"images"][@"fixed_height_downsampled"];
//  NSInteger width =  [[dict objectForKey:@"width"] integerValue];
  NSInteger height = [[dict objectForKey:@"height"] integerValue];
//  NSLog(@"returning: %li, %li", width, height);
  return CGSizeMake(300, height);
//  return CGSizeMake(100, 100);
}

@end
