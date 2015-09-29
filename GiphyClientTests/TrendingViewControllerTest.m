//
//  TrendingViewControllerTest.m
//  GiphyClient
//
//  Created by Jared Halpern on 9/29/15.
//  Copyright © 2015 byteMason. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "APIManager.h"

@interface TrendingViewControllerTest : XCTestCase
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger offset;
@end

@implementation TrendingViewControllerTest

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testGetTrendingGifs {

  __weak TrendingViewControllerTest *welf = self;

  [[APIManager sharedManager] getTrendingGifsWithOffset:welf.offset andCompletion:^(NSArray *data, NSInteger offset) {
    welf.dataArray = [[welf.dataArray arrayByAddingObjectsFromArray:data] mutableCopy];
    welf.offset = offset;

    XCTAssertTrue(welf.dataArray.count > 0, @"data array count should be greater than zero");
  }];



  // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
