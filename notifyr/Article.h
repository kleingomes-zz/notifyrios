//
//  Article.h
//  notifyr
//
//  Created by Nelson Narciso on 2014-07-14.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface Article : NSObject

@property (nonatomic) NSNumber *articleId;
@property (nonatomic) Item *interest;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *articleDescription;
@property (nonatomic) NSString *author;
@property (nonatomic) NSString *source;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *timeAgo;
@property (nonatomic) NSNumber *score;
@property (nonatomic) NSString *iUrl;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSDate *publishDate;


+ (Article *)makeArticleFromDictionary:(NSDictionary *)dictionary;

@end
