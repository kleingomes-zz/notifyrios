//
//  AppDelegate.h
//  notifyr
//
//  Created by Nelson Narciso on 2014-04-19.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Article *startingArticle;

@end
