//
//  APIManagerTest.m
//  GiphyClient
//
//  Created by Jared Halpern on 9/29/15.
//  Copyright © 2015 byteMason. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "APIManager.h"


@interface APIManagerTest : XCTestCase

@end

@implementation APIManagerTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark - Singleton specific

- (APIManager *)createUniqueInstance
{
  return [[APIManager alloc] init];
}

- (APIManager *)getSharedInstance
{
  return [APIManager sharedManager];
}

#pragma mark - Instantiation Tests

- (void)testSingletonSharedInstanceCreated
{
  XCTAssertNotNil([self getSharedInstance], @"Unable to create shared instance of APIManager Singleton");
}

- (void)testSingletonUniqueInstanceCreated
{
  XCTAssertNotNil([self createUniqueInstance], @"Unable to create unique instance of APIManager Singleton");
}

- (void)testSingletonReturnsSameSharedInstanceTwice
{
  APIManager *thisInstance = [self getSharedInstance];
  XCTAssertEqual(thisInstance, [self getSharedInstance], @"APIManager failed to return the same, shared, instance of Singleton");
}

- (void)testSingletonSharedInstanceSeparateFromUniqueInstance
{
  APIManager *thisInstance = [self getSharedInstance];
  XCTAssertNotEqual(thisInstance, [self createUniqueInstance], @"APIManager returned the same, shared, instance of Singleton when should have been unique");
}

- (void)testSingletonReturnsSeparateUniqueInstances
{
  APIManager *thisInstance = [self createUniqueInstance];
  XCTAssertNotEqual(thisInstance, [self createUniqueInstance], @"APIManager returned the same instance of Singleton when should have returned two uniques");
}


@end
