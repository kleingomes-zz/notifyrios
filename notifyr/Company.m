//
//  Company.m
//  notifyr
//
//  Created by Nelson Narciso on 2014-05-04.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "Company.h"
#import "Utils.h"

@implementation Company


+ (Company *)makeCompanyFromDictionary:(NSDictionary *)dictionary
{
    Company *company = [[Company alloc] init];
    company.companyId = [Utils getNumberFromDictionary:dictionary name:@"Id"];
    company.name = dictionary[@"Name"];
    return company;
}


@end
