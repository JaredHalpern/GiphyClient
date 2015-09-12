//
//  SingleGifView.m
//  GiphyClient
//
//  Created by Jared Halpern on 9/12/15.
//  Copyright (c) 2015 byteMason. All rights reserved.
//

#import "SingleGifView.h"
#import "Constants.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SingleGifView ()
@property (nonatomic, strong) UIImageView *singleGifImageView;
@property (nonatomic, strong) UILabel *captionLabel;
@property (nonatomic, strong) UILabel *rating;
@property (nonatomic, strong) UILabel *trendingDateTime;
@property (nonatomic, strong) UITextFieldLabel *embedURL;
@property (nonatomic, strong) UITextFieldLabel *bitlyURL;
@property (nonatomic, strong) UITextFieldLabel *sourceURL;
@property (nonatomic, strong) UIButton *shareSMSButton;
@property (nonatomic, strong) UIButton *clipboardButton;
@property (nonatomic, strong) UIView *containerView;
@end

//#define kKeyTrendingDateTime    @"trending_datetime"
//#define kRating                 @"rating"
//#define kSourceURL              @"source"
//#define kBitlyURL               @"bitly_url"
//#define kEmbedURL               @"embed_url"
//#define kURL                    @"url"
//#define kCaption                @"caption"

@implementation SingleGifView

- (instancetype)initWithDict:(NSDictionary *)dict
{
  if (self = [super init]) {
    self.clipsToBounds = YES;
    self.backgroundColor = kColorYellow;
    
    _containerView = [[UIView alloc] init];
    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    _containerView.backgroundColor = [UIColor redColor];
    
    _singleGifImageView = [[UIImageView alloc] init];
    _singleGifImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSURL *imageURL = dict[@"images"][@"fixed_height_downsampled"][@"url"];
    [_singleGifImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"mariah.gif"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
      if (error) {
        NSLog(@"%s - %@", __PRETTY_FUNCTION__, error);
      } else {
        NSLog(@"%s - LOADED", __PRETTY_FUNCTION__);
      }
    }];
    [_containerView addSubview:_singleGifImageView];
    
    _captionLabel = [[UILabel alloc] init];
    _captionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _captionLabel.text = dict[@"caption"]?: @"No Caption"; // revisit this; empty description
    _captionLabel.textColor = [UIColor blueColor];
    [_containerView addSubview:_captionLabel];
    
    _rating = [[UILabel alloc] init];
    _rating.translatesAutoresizingMaskIntoConstraints = NO;
    _rating.text = [NSString stringWithFormat:@"Rating: %@", dict[@"rating"]];
    _rating.textColor = [UIColor blueColor];
    [_containerView addSubview:_rating];
    
    [self addSubview:_containerView];
    
    [self setupConstraints];
  }
  return self;
}

- (void)setupConstraints
{
  NSMutableArray *containerConstraints = [@[] mutableCopy];
  [containerConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_singleGifImageView][_captionLabel(20)][_rating(20)]|"
                                                                           options:NSLayoutFormatAlignAllLeft
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(_singleGifImageView, _captionLabel, _rating)]];

  [containerConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(8)-[_singleGifImageView]"
                                                                           options:NSLayoutFormatAlignAllLeft
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(_singleGifImageView)]];
  
  [containerConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(8)-[_captionLabel]"
                                                                           options:NSLayoutFormatAlignAllLeft
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(_captionLabel)]];
  
  [containerConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(8)-[_rating]"
                                                                           options:NSLayoutFormatAlignAllLeft
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(_rating)]];
  [self addConstraints:containerConstraints];
  
  NSMutableArray *constraints = [@[] mutableCopy];
//  [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[_containerView]-(>=0)-|"
  [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_containerView]"
                                                                                    options:NSLayoutFormatAlignAllCenterY
                                                                                    metrics:nil
                                                                                      views:NSDictionaryOfVariableBindings(_containerView)]];
  [self addConstraints:constraints];
}

@end
