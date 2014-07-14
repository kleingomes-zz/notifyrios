//
//  EventType.h
//  notifyr
//
//  Created by Nelson Narciso on 2014-07-13.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventType : NSObject

@property (nonatomic) NSNumber *eventTypeId;
@property (nonatomic) NSString *name;

- (id)initWithEventTypeId:(NSNumber *)eventTypeId name:(NSString *)name;

@end
