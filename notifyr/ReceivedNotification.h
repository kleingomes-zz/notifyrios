//
//  ReceivedNotification.h
//  Notifyr
//
//  Created by Nelson Narciso on 2014-04-18.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceivedNotification : NSObject

@property (nonatomic, strong) NSString *title;


- (id)initWithTitle:(NSString *)title;

@end
