//
//  CatalogItems.m
//  Offline_Shopping
//
//  Created by Pradeep Narendra on 7/28/15.
//  Copyright (c) 2015 Pradeep Narendra. All rights reserved.
//

#import "CatalogItems.h"


@implementation CatalogItems

@dynamic itemAddedToCart;
@dynamic itemDescription;
@dynamic itemImage;
@dynamic itemName;

+ (CatalogItems *)initWithContext:(NSManagedObjectContext *)context {
    CatalogItems *item = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([CatalogItems class]) inManagedObjectContext:context];
    return item;
}

@end
