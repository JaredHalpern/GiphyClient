//
//  APIManager.m
//  GiphyClient
//
//  Created by Jared Halpern on 9/11/15.
//  Copyright (c) 2015 byteMason. All rights reserved.
//

#import "Constants.h"
#import "APIManager.h"

@interface APIManager ()
@property (nonatomic, strong) AFHTTPRequestOperationManager *requestOperationManager;
@end

@implementation APIManager

+ (APIManager *)sharedManager
{
  static APIManager *_sharedManager;
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    _sharedManager = [[APIManager alloc] init];
  });
  
  return _sharedManager;
}

- (instancetype)init
{
  if (self = [super init]) {
    AFHTTPRequestOperationManager *operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kAPIHostURL]];
    operationManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestOperationManager = operationManager;
  }
  return self;
}

- (void)searchTerms:(NSString *)terms withCompletion:(void (^)(NSArray *data, NSString *searchTerms))completion
{
  NSDictionary *parameters = @{@"api_key" : kGiphyPublicKey, @"q" : terms};
  
  [self.requestOperationManager GET:kEndpointSearch parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSArray *data = [responseObject objectForKey:@"data"];
//    NSLog(@"%s - data: %@", __PRETTY_FUNCTION__, data);
    NSLog(@"%@", operation);
    if (completion) {
      completion(data, terms);
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"%s - error: %@", __PRETTY_FUNCTION__, error.description);
    if (completion) {
      completion(nil, nil);
    }
  }];
}

- (void)getTrendingGifsWithCompletion:(void (^)(NSArray *data))completion
{
  NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:kGiphyPublicKey, @"api_key", nil];
  
  [self.requestOperationManager GET:kEndpointTrending parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
      NSArray *data = (NSArray *)[responseObject objectForKey:@"data"];
//      NSLog(@"%s - data: %@", __PRETTY_FUNCTION__, data);
      if (completion) {
        completion(data);
      }
    }
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"%s - error: %@", __PRETTY_FUNCTION__, error.description);
    if (completion) {
      completion(nil);
    }
  }];}

@end
