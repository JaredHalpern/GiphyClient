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

  // Given
  self.offset = 0;

  __weak TrendingViewControllerTest *welf = self;

  
  // When
  [[APIManager sharedManager] getTrendingGifsWithOffset:welf.offset andCompletion:^(NSArray *data, NSInteger offset) {
    welf.dataArray = [[welf.dataArray arrayByAddingObjectsFromArray:data] mutableCopy];
    welf.offset = offset;

    // Then
    XCTAssertTrue(welf.dataArray.count > 0, @"data array count should be greater than zero");
    XCTAssertTrue(welf.offset >=0, @"offset must be >= 0");
  }];



  // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
