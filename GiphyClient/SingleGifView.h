//
//  SingleGifView.h
//  GiphyClient
//
//  Created by Jared Halpern on 9/12/15.
//  Copyright (c) 2015 byteMason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@protocol SingleGifViewDelegate <NSObject>
@required
- (void)shareSMSButtonPressed;
- (void)copyToClipboardButtonPressed;
- (void)saveToPhotosButtonPressed;
@end

@interface SingleGifView : UIView <MBProgressHUDDelegate>
@property (nonatomic, strong) UIImage *singleGifImage;
@property (nonatomic, assign) id <SingleGifViewDelegate> delegate;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
