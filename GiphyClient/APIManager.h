//
//  APIManager.h
//  GiphyClient
//
//  Created by Jared Halpern on 9/11/15.
//  Copyright (c) 2015 byteMason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

@interface APIManager : NSObject
+ (APIManager *)sharedManager;
- (void)searchTerms:(NSString *)terms withCompletion:(void (^)(NSArray *data))completion;
- (void)getTrendingGifsWithCompletion:(void (^)(NSArray *data))completion;
@end