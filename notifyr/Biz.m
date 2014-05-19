//
//  Biz.m
//  notifyr
//
//  Created by Nelson Narciso on 2014-04-25.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "Biz.h"
#import "Repository.h"
#import "NotifyrApiClient.h"
#import "Constants.h"

@implementation Biz


- (NSArray *)companies
{
    if (!_companies)
    {
        _companies = [[Repository sharedRepository] getCompanies];
    }
    return _companies;
}

- (void)getReceivedNotifications
{
    NotifyrApiClient *apiClient = [[NotifyrApiClient alloc] init];
    //[apiClient getReceivedNotifications];
    //[apiClient getCompanies];
    [apiClient getNewAccessToken];
}

- (Company *)getCompanyById:(NSNumber *)companyId
{
    if (companyId == nil)
    {
        return nil;
    }
    for (Company *company in self.companies)
    {
        if ([company.companyId isEqualToValue:companyId])
        {
            return company;
        }
    }
    return nil;
}

- (void)initObserver
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    
    [center addObserverForName:ReceivedCompaniesNotification
                        object:nil
                         queue:mainQueue
                    usingBlock:^(NSNotification *notification) {
                         NSArray *companies = notification.userInfo[@"companies"];
                                                             
                         NSLog(@"Got %lu companies", (unsigned long)[companies count]);
                                                             
                         self.companies = companies;
                     }];
}

+ (Biz *)sharedBiz
{
    static Biz *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Biz alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initObserver];
    }
    return self;
}

@end
