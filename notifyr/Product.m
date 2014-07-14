//
//  Product.m
//  notifyr
//
//  Created by Nelson Narciso on 2014-07-14.
//  Copyright (c) 2014 Nelson Narciso. All rights reserved.
//

#import "Product.h"
#import "Utils.h"

@implementation Product

+ (Product *)makeProductFromDictionary:(NSDictionary *)dictionary
{
    Product *product = [[Product alloc] init];
    product.productId = [Utils getNumberFromDictionary:dictionary name:@"Id"];
    product.name = dictionary[@"Name"];
    return product;
}

@end
