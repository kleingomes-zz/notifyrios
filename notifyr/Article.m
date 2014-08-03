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
    
    article.title = [Utils getStringFromDictionary:dictionary name:@"Title"];
    article.description = [Utils getStringFromDictionary:dictionary name:@"Description"];
    article.source = [Utils getStringFromDictionary:dictionary name:@"Source"];
    article.author = [Utils getStringFromDictionary:dictionary name:@"Author"];
    article.url = [Utils getStringFromDictionary:dictionary name:@"URL"];
    article.score = [Utils getNumberFromDictionary:dictionary name:@"Score"];
    article.iUrl = [Utils getStringFromDictionary:dictionary name:@"IURL"];
    
    return article;
}

@end
