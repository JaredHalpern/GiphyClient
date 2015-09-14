//
//  Constants.h
//  GiphyClient
//
//  Created by Jared Halpern on 9/11/15.
//  Copyright (c) 2015 byteMason. All rights reserved.
//

#ifndef GiphyClient_Constants_h
#define GiphyClient_Constants_h

#pragma mark - Keys and URLs

#define kAPIHostURL             @"http://api.giphy.com"
#define kGiphyPublicKey         @"dc6zaTOxFJmzC"

#pragma mark - API Endpoints

#define kEndpointSearch         @"/v1/gifs/search"
#define kEndpointTrending       @"/v1/gifs/trending"

#pragma mark - Colors

#define kColorYellow            [UIColor colorWithRed:247./256. green:200./256. blue:44./256. alpha:1.0];
#define kColorLightBlue         [UIColor colorWithRed:145./256. green:223./256. blue:221./256. alpha:1.0];
#define kColorDarkBlue          [UIColor colorWithRed:79./256. green:136./256. blue:134./256. alpha:1.0];

#pragma mark - Timing

#define kTimeSearchVCSlide      0.25

#pragma mark - Dimensions

#define kNavBarHeight           64.0

#pragma mark - Fonts

#define kFontRegular          [UIFont fontWithName:@"Arial" size:16.0]

#endif
