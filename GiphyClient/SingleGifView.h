//
//  SingleGifView.h
//  GiphyClient
//
//  Created by Jared Halpern on 9/12/15.
//  Copyright (c) 2015 byteMason. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SingleGifViewDelegate <NSObject>
@required
- (void)shareSMSButtonPressed;
- (void)copyToClipboardButtonPressed;
@end

@interface SingleGifView : UIView
@property (nonatomic, strong) UIImage *singleGifImage;
@property (nonatomic, assign) id <SingleGifViewDelegate> delegate;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
