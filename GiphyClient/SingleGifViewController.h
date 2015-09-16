//
//  SingleGifViewController.h
//  GiphyClient
//
//  Created by Jared Halpern on 9/11/15.
//  Copyright (c) 2015 byteMason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleGifView.h"
#import <MessageUI/MessageUI.h>

@interface SingleGifViewController : UIViewController <SingleGifViewDelegate, MFMessageComposeViewControllerDelegate>
- (instancetype)initWithDict:(NSDictionary *)imageDict;
@end
