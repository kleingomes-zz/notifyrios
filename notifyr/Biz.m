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

#pragma mark - Properties

- (NSArray *)companies
{
    if (!_companies)
    {
        _companies = [[Repository sharedRepository] getCompanies];
    }
    return _companies;
}

- (NSArray *)eventTypes
{
    if (!_eventTypes)
    {
        NSMutableArray *eventTypesArray = [[NSMutableArray alloc] init];
        [eventTypesArray addObject:[[EventType alloc] initWithEventTypeId:@1 name:@"Release Date"]];
        [eventTypesArray addObject:[[EventType alloc] initWithEventTypeId:@2 name:@"Quarterly Results"]];
        [eventTypesArray addObject:[[EventType alloc] initWithEventTypeId:@3 name:@"Conference"]];
        [eventTypesArray addObject:[[EventType alloc] initWithEventTypeId:@4 name:@"News"]];
        _eventTypes = [NSArray arrayWithArray:eventTypesArray];
    }
    return _eventTypes;
}


#pragma mark - Get Object Methods

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

- (Product *)getProductById:(NSNumber *)productId
{
    if (productId == nil)
    {
        return nil;
    }
    for (Product *product in self.products)
    {
        if ([product.productId isEqualToValue:productId])
        {
            return product;
        }
    }
    return nil;
}

- (EventType *)getEventTypeById:(NSNumber *)eventTypeId
{
    if (eventTypeId == nil)
    {
        return nil;
    }
    for (EventType *eventType in self.eventTypes)
    {
        if ([eventType.eventTypeId isEqualToValue:eventTypeId])
        {
            return eventType;
        }
    }
    return nil;
}


#pragma mark - Main Methods

- (void)getInterests
{
    NotifyrApiClient *apiClient = [[NotifyrApiClient alloc] init];
    [apiClient getCompaniesWithCompletionHandler:^(NSError *error) {
        [apiClient getProductsWithCompletionHandler:^(NSError *error) {
            [apiClient getInterests];
        }];
    }];
}



- (void)initObserver
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    
    [center addObserverForName:CompaniesUpdateNotification
                        object:nil
                         queue:mainQueue
                    usingBlock:^(NSNotification *notification) {
                         NSArray *companies = notification.userInfo[@"companies"];
                                                             
                         NSLog(@"Got %lu companies", (unsigned long)[companies count]);
                                                             
                         self.companies = companies;
                     }];
    
    [center addObserverForName:ProductsUpdateNotification
                        object:nil
                         queue:mainQueue
                    usingBlock:^(NSNotification *notification) {
                        NSArray *products = notification.userInfo[@"products"];
                        
                        NSLog(@"Got %lu products", (unsigned long)[products count]);
                        
                        self.products = products;
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
