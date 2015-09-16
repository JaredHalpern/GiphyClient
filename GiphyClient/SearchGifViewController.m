//
//  SearchGifViewController.m
//  GiphyClient
//
//  Created by Jared Halpern on 9/13/15.
//  Copyright (c) 2015 byteMason. All rights reserved.
//

#import "SearchGifViewController.h"
#import "SearchResultsHeaderView.h"

@interface SearchGifViewController ()
@property (nonatomic, strong) NSString *searchTerms;
@end

@implementation SearchGifViewController

#pragma mark - View Lifecycle

- (instancetype)init
{
  if (self = [super init]) {
    _searchTerms = @"";    
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.collectionView registerClass:[SearchResultsHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerCellReuseId];
  [self setupConstraints];
}

- (void)setupSearchBar
{
   // don't use the searchbar in this subclass
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
  return CGSizeMake([[UIScreen mainScreen] bounds].size.width, 40);
}


#pragma mark - UICollectionViewDataSource

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
  SearchResultsHeaderView *reusableView = nil;
  
  if (kind == UICollectionElementKindSectionHeader){
    SearchResultsHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerCellReuseId forIndexPath:indexPath];
    [self updateSectionHeader:headerView];
    reusableView = headerView;
  }
  return reusableView;
}

- (void)updateSectionHeader:(SearchResultsHeaderView *)header
{
  NSString *text = [NSString stringWithFormat:@"Results for: %@", self.searchTerms];
  [header setResultsLabelText:text];
  [self.view setNeedsLayout];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  CGFloat offsetY = scrollView.contentOffset.y;
  CGFloat contentHeight = scrollView.contentSize.height;
  
  if (offsetY > contentHeight - scrollView.frame.size.height){
    
    if (!self.loadingGifs) {
      
      [SVProgressHUD show];
      self.loadingGifs = YES;
      
      __weak SearchGifViewController *welf = self;
      NSLog(@"searchTerms: %@", self.searchTerms);
      [[APIManager sharedManager] searchTerms:self.searchTerms withOffset:(self.offset + kWindowSize) andCompletion:^(NSArray *data, NSString *searchTerms, NSInteger offset) {
        
        welf.offset = offset;
        
        NSMutableArray *indicesToAppend = [@[] mutableCopy];
        for (NSInteger i = 0; i < data.count; i++) {
          [indicesToAppend addObject:[NSIndexPath indexPathForItem:(welf.dataArray.count + i) inSection:0]];
        }
        NSLog(@"%s - added %li images", __PRETTY_FUNCTION__, indicesToAppend.count);
        welf.dataArray = [[welf.dataArray arrayByAddingObjectsFromArray:data] mutableCopy];
        
        [welf.collectionView performBatchUpdates:^{
          [welf.collectionView insertItemsAtIndexPaths:indicesToAppend];
        } completion:^(BOOL finished) {
          self.loadingGifs = NO;
          [SVProgressHUD dismiss];
          NSLog(@"%s done loading", __PRETTY_FUNCTION__);
        }];
      }];
    }
  }
}

#pragma mark -

- (void)setSearchTerms:(NSString *)searchTerms
{
  _searchTerms = searchTerms;
  [self.collectionView reloadData]; // overreaching but see if this works
}

@end






