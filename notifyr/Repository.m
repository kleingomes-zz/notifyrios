//
//  Repository.m
//  notifyr
//
//  Created by Nelson Narciso on 2014-05-12.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "Repository.h"

@implementation Repository

- (NSArray *)getCompanies
{
    NSMutableArray *companies = [[NSMutableArray alloc] init];
    return companies;
}

+ (Repository *)sharedRepository
{
    static Repository *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Repository alloc] init];
    });
    return sharedInstance;
}

@end
