//
//  SearchGifViewControllerTest.m
//  GiphyClient
//
//  Created by Jared Halpern on 9/29/15.
//  Copyright © 2015 byteMason. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "APIManager.h"
#import "SearchGifViewController.h"

@interface SearchGifViewControllerTest : XCTestCase
@property (nonatomic, strong) NSString *searchTerms;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger offset;
@end

@implementation SearchGifViewControllerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSearchGifs {
  
  // Given
  self.offset = 0;
  
  __weak SearchGifViewControllerTest *welf = self;

  // When
  [[APIManager sharedManager] searchTerms:@"cat" withOffset:self.offset andCompletion:^(NSArray *data, NSString *searchTerms, NSInteger offset) {
    welf.searchTerms = searchTerms;
    welf.offset = offset;
    welf.dataArray = [data mutableCopy]; // replace, since we're simulating a fresh search / not appending
    
    // Then
    XCTAssertTrue(welf.dataArray.count > 0, @"data array count should be greater than zero");
    XCTAssertTrue(welf.searchTerms, @"search terms should not be blank");
    XCTAssertTrue(welf.offset >=0, @"offset must be >= 0");
  }];
}

@end
