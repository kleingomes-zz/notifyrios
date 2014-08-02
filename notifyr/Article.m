//
//  Article.m
//  notifyr
//
//  Created by Nelson Narciso on 2014-07-14.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "Article.h"
#import "Utils.h"

@implementation Article


+ (Article *)makeArticleFromDictionary:(NSDictionary *)dictionary
{
    Article *article = [[Article alloc] init];
    article.articleId = [Utils getNumberFromDictionary:dictionary name:@"Id"];
    
    article.title = dictionary[@"Title"] != [NSNull null] ? dictionary[@"Title"] : nil;
    article.description = dictionary[@"Description"];
    article.source = dictionary[@"Source"] != [NSNull null] ? dictionary[@"Source"] : nil;
    article.author = dictionary[@"Author"] != [NSNull null] ? dictionary[@"Author"] : nil;
    article.score = [Utils getNumberFromDictionary:dictionary name:@"Score"];

    
    return article;
}

@end
