//
//  SingleGifViewController.h
//  GiphyClient
//
//  Created by Jared Halpern on 9/11/15.
//  Copyright (c) 2015 byteMason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleGifView.h"

@interface SingleGifViewController : UIViewController <SingleGifViewDelegate>
- (instancetype)initWithDict:(NSDictionary *)imageDict;
@end
