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
@property (nonatomic, strong) UIView       *containerView;
@property (nonatomic, strong) UIView       *buttonContainerView;
@property (nonatomic, strong) UIImageView  *singleGifImageView;
@property (nonatomic, strong) UILabel      *captionLabel; // @"caption"
@property (nonatomic, strong) UILabel      *rating; // @"rating"
@property (nonatomic, strong) UIButton     *shareSMSButton;
@property (nonatomic, strong) UIButton     *clipboardButton;
@property (nonatomic, strong) UIButton     *saveImageButton;
@property (nonatomic, strong) NSDictionary *singleGifDict;
@end

@implementation SingleGifView

- (instancetype)initWithDict:(NSDictionary *)dict
{
  if (self = [super init]) {
    self.clipsToBounds = YES;
    self.backgroundColor = kColorYellow;
    
    _singleGifDict = dict;
    
    _containerView = [[UIView alloc] init];
    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    _containerView.backgroundColor = [UIColor clearColor];
    
    _buttonContainerView = [[UIView alloc] init];
    _buttonContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    _buttonContainerView.backgroundColor = [UIColor clearColor];
    
    _singleGifImageView = [[UIImageView alloc] init];
    _singleGifImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSURL *imageURL = _singleGifDict[@"images"][@"fixed_width"][@"url"];
    
    __weak SingleGifView *welf = self;
    
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:_singleGifImageView animated:YES];
    progressHUD.mode = MBProgressHUDModeAnnularDeterminate;
    progressHUD.delegate = self;
    [progressHUD show:YES];
    progressHUD.color = kColorLightBlueAlpha;    
    
    [_singleGifImageView sd_setImageWithURL:imageURL placeholderImage:kPlaceholderImage
                                    options:SDWebImageHighPriority
                                   progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                       CGFloat recSize = [[NSNumber numberWithInteger:receivedSize] floatValue];
                                       CGFloat expSize = [[NSNumber numberWithInteger:expectedSize] floatValue];
                                       CGFloat progress = (recSize / expSize);
                                       progressHUD.progress = progress;
                                     });
                                     
                                   } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                       [progressHUD hide:YES];
                                     });
                                     
                                     if (error) {
                                       NSLog(@"%s - %@", __PRETTY_FUNCTION__, error);
                                     }
                                     
                                     welf.singleGifImage = image;
                                     
                                   }];
    
    _shareSMSButton = [[UIButton alloc] init];
    _shareSMSButton.titleLabel.font = kFontRegular;
    _shareSMSButton.titleLabel.textColor = kColorDarkBlue;
    _shareSMSButton.backgroundColor = [UIColor clearColor];
    [_shareSMSButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_shareSMSButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_shareSMSButton setTitle:@"Share via SMS" forState:UIControlStateNormal];
    _shareSMSButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_shareSMSButton addTarget:self action:@selector(didPressShareSMSButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _clipboardButton = [[UIButton alloc] init];
    _clipboardButton.titleLabel.font = kFontRegular;
    _clipboardButton.titleLabel.textColor = kColorDarkBlue;
    _clipboardButton.backgroundColor = [UIColor clearColor];
    [_clipboardButton setTitle:@"Copy to Clipboard" forState:UIControlStateNormal];
    _clipboardButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_clipboardButton addTarget:self action:@selector(didPressCopyToClipboardButton:) forControlEvents:UIControlEventTouchUpInside];

    _saveImageButton = [[UIButton alloc] init];
    _saveImageButton.titleLabel.font = kFontRegular;
    _saveImageButton.titleLabel.textColor = kColorDarkBlue;
    _saveImageButton.backgroundColor = [UIColor clearColor];
    [_saveImageButton setTitle:@"Save to Photos" forState:UIControlStateNormal];
    _saveImageButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_saveImageButton addTarget:self action:@selector(didPressSaveToPhotos:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_buttonContainerView addSubview:_shareSMSButton];
    [_buttonContainerView addSubview:_clipboardButton];
    [_buttonContainerView addSubview:_saveImageButton];
    [_containerView addSubview:_singleGifImageView];    
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
  NSDictionary *dict =  [self.singleGifDict objectForKey:@"images"][@"fixed_width"];
  NSInteger containerHeight = [[dict objectForKey:@"height"] integerValue];
  NSInteger containerWidth = [[dict objectForKey:@"width"] integerValue];
  
  containerHeight *= 1.3;
  containerWidth *= 1.3;
  
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
  
  [containerConstraints addObject:[NSLayoutConstraint constraintWithItem:_singleGifImageView
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                                constant:containerWidth]];
  
  [containerConstraints addObject:[NSLayoutConstraint constraintWithItem:_singleGifImageView
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                                constant:containerHeight]];
  
  [containerConstraints addObject:[NSLayoutConstraint constraintWithItem:_buttonContainerView
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.containerView
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0
                                                                constant:0.0]];
  
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
  
  [buttonContainerConstraints addObject:[NSLayoutConstraint constraintWithItem:_saveImageButton
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_shareSMSButton
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:10.0]];
  
  [buttonContainerConstraints addObject:[NSLayoutConstraint constraintWithItem:_saveImageButton
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0
                                                                      constant:150.0]];
  
  [buttonContainerConstraints addObject:[NSLayoutConstraint constraintWithItem:_saveImageButton
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_buttonContainerView
                                                                     attribute:NSLayoutAttributeCenterX
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
                                                       constant:20.0]];
  
  [constraints addObject:[NSLayoutConstraint constraintWithItem:_containerView
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeHeight
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
                                                      attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeCenterX
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


- (void)didPressSaveToPhotos:(id)sender
{
  [self.delegate saveToPhotosButtonPressed];
}

@end







