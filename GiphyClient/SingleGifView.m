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
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *buttonContainerView;
@property (nonatomic, strong) UIImageView *singleGifImageView;
@property (nonatomic, strong) UILabel *captionLabel; // @"caption"
@property (nonatomic, strong) UILabel *rating; // @"rating"
@property (nonatomic, strong) UIButton *shareSMSButton;
@property (nonatomic, strong) UIButton *clipboardButton;
@end

@implementation SingleGifView

- (instancetype)initWithDict:(NSDictionary *)dict
{
  if (self = [super init]) {
    self.clipsToBounds = YES;
    self.backgroundColor = kColorYellow;
    
    _containerView = [[UIView alloc] init];
    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    _containerView.backgroundColor = [UIColor clearColor];
    _containerView.clipsToBounds = YES;
    
    _buttonContainerView = [[UIView alloc] init];
    _buttonContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    _buttonContainerView.backgroundColor = [UIColor clearColor];
    _buttonContainerView.clipsToBounds = YES;
    
    _singleGifImageView = [[UIImageView alloc] init];
    _singleGifImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSURL *imageURL = dict[@"images"][@"fixed_height"][@"url"];
    __weak SingleGifView *welf = self;
    [_singleGifImageView sd_setImageWithURL:imageURL
                           placeholderImage:[UIImage imageNamed:@"nyan.png"]
                                    options:SDWebImageProgressiveDownload
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    if (error) {
                                      NSLog(@"%s - %@", __PRETTY_FUNCTION__, error);
                                    }
                                    welf.singleGifImage = image;
                                  }];
    
    [_containerView addSubview:_singleGifImageView];
        
    _shareSMSButton = [[UIButton alloc] init];
    _shareSMSButton.titleLabel.font = kFontRegular;
    _shareSMSButton.titleLabel.textColor = kColorDarkBlue;
    [_shareSMSButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_shareSMSButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_shareSMSButton setTitle:@"Share via SMS" forState:UIControlStateNormal];
    _shareSMSButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_shareSMSButton addTarget:self action:@selector(didPressShareSMSButton:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonContainerView addSubview:_shareSMSButton];
    
    _clipboardButton = [[UIButton alloc] init];
    _clipboardButton.titleLabel.font = kFontRegular;
    _clipboardButton.titleLabel.textColor = kColorDarkBlue;
    [_clipboardButton setTitle:@"Copy to Clipboard" forState:UIControlStateNormal];
    _clipboardButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_clipboardButton addTarget:self action:@selector(didPressCopyToClipboardButton:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonContainerView addSubview:_clipboardButton];
    
    [_containerView addSubview:_buttonContainerView];
    [self addSubview:_containerView];
    
    [self setupConstraints];
  }
  return self;
}

- (void)setupConstraints
{
  // All-encompassing containerView
  
  NSMutableArray *containerConstraints = [@[] mutableCopy];
  
  [containerConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(22.5)-[_singleGifImageView]-(20)-[_buttonContainerView]|"
                                                                                    options:NSLayoutFormatAlignAllCenterX
                                                                                    metrics:nil
                                                                                      views:NSDictionaryOfVariableBindings(_singleGifImageView, _buttonContainerView)]];
  
  [containerConstraints addObject:[NSLayoutConstraint constraintWithItem:_singleGifImageView
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.containerView
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0
                                                                constant:0.0]];
  
  [containerConstraints addObject:[NSLayoutConstraint constraintWithItem:_buttonContainerView
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.containerView
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0
                                                                constant:0.0]];
  
  [containerConstraints addObject:[NSLayoutConstraint constraintWithItem:_buttonContainerView
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.containerView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0
                                                                constant:0.0]];
  
  [containerConstraints addObject:[NSLayoutConstraint constraintWithItem:_buttonContainerView
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                                constant:30.0]];
  
  [_containerView addConstraints:containerConstraints];
  
  // Buttons, inside their own buttonContainer, inside the larger containerView
  
  NSMutableArray *buttonContainerConstraints = [@[] mutableCopy];
  
  [buttonContainerConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_shareSMSButton(120)]-(>=22)-[_clipboardButton(150)]|"
                                                                                          options:0
                                                                                          metrics:nil
                                                                                            views:NSDictionaryOfVariableBindings(_shareSMSButton, _clipboardButton)]];
  
  [buttonContainerConstraints addObject:[NSLayoutConstraint constraintWithItem:_shareSMSButton
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_buttonContainerView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:0.0]];
  
  [buttonContainerConstraints addObject:[NSLayoutConstraint constraintWithItem:_clipboardButton
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_buttonContainerView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:0.0]];
  
  [_buttonContainerView addConstraints:buttonContainerConstraints];
  
  // the larger containerView
  
  NSMutableArray *constraints = [@[] mutableCopy];
  [constraints addObject:[NSLayoutConstraint constraintWithItem:_containerView
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1.0
                                                       constant:0.0]];
  
  [constraints addObject:[NSLayoutConstraint constraintWithItem:_containerView
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeWidth
                                                     multiplier:1.0
                                                       constant:0.0]];
  
  [constraints addObject:[NSLayoutConstraint constraintWithItem:_containerView
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1.0
                                                       constant:0.0]];
  [self addConstraints:constraints];
}

#pragma mark - Button Methods

- (void)didPressShareSMSButton:(id)sender
{
  [self.delegate shareSMSButtonPressed];
}

- (void)didPressCopyToClipboardButton:(id)sender
{
  [self.delegate copyToClipboardButtonPressed];
}

@end







