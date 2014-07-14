//
//  Product.h
//  notifyr
//
//  Created by Nelson Narciso on 2014-07-14.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic) NSNumber *productId;
@property (nonatomic) NSString *name;

+ (Product *)makeProductFromDictionary:(NSDictionary *)dictionary;

@end
