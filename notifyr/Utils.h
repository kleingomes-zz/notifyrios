//
//  Utils.h
//  notifyr
//
//  Created by Nelson Narciso on 2014-05-04.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (NSNumber *)getNumberFromDictionary:(NSDictionary *)dictionary name:(NSString *)name;

+ (NSString *)getStringFromDictionary:(NSDictionary *)dictionary name:(NSString *)name;

@end
