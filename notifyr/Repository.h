//
//  Repository.h
//  notifyr
//
//  Created by Nelson Narciso on 2014-05-12.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Repository : NSObject

+ (Repository *)sharedRepository;

- (NSArray *)getInterests;

- (NSArray *)getCompanies;


@end
