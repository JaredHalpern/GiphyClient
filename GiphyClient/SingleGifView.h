//
//  SingleGifView.h
//  GiphyClient
//
//  Created by Jared Halpern on 9/12/15.
//  Copyright (c) 2015 byteMason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleGifView : UIView
@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) UIImageView *gifImageView;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
