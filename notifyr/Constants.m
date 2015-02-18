//
//  Constants.m
//  notifyr
//
//  Created by Nelson Narciso on 2014-05-18.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "Constants.h"

@implementation Constants

NSString *const InterestsUpdateNotification = @"InterestsUpdateNotification";
NSString *const DeleteInterestNotification = @"DeleteInterestNotification";

NSString *const CompaniesUpdateNotification = @"CompaniesUpdateNotification";
NSString *const ProductsUpdateNotification = @"ProductsUpdateNotification";
NSString *const ArticlesUpdateNotification = @"ArticlesUpdateNotification";

NSString *const kInterestsSortOrderScore = @"Score";
NSString *const kInterestsSortOrderPublishDate = @"PublishDate";

NSString *const favouritesNotFoundTopText = @"Nothing Here.";
NSString *const favouritesNotFoundBottomText = @"You can add favourites by swiping left on an article that you like.";
@end
