//
//  Article.h
//  notifyr
//
//  Created by Nelson Narciso on 2014-07-14.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Interest.h"

@interface Article : NSObject

@property (nonatomic) NSNumber *articleId;
@property (nonatomic) Interest *interest;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *description;
@property (nonatomic) NSString *author;
@property (nonatomic) NSString *source;
@property (nonatomic) NSString *url;
@property (nonatomic) NSNumber *score;
@property (nonatomic) NSString *iUrl;
@property (nonatomic, strong) UIImage *image;


+ (Article *)makeArticleFromDictionary:(NSDictionary *)dictionary;

@end
