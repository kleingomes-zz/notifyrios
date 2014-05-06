//
//  Company.h
//  notifyr
//
//  Created by Nelson Narciso on 2014-05-04.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Company : NSObject

@property (nonatomic) NSNumber *companyId;
@property (nonatomic, strong) NSString *name;

+ (Company *)makeCompanyFromDictionary:(NSDictionary *)dictionary;

@end
