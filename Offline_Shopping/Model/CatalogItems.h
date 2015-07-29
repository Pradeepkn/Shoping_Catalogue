//
//  CatalogItems.h
//  Offline_Shopping
//
//  Created by Pradeep Narendra on 7/28/15.
//  Copyright (c) 2015 Pradeep Narendra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CatalogItems : NSManagedObject

@property (nonatomic, retain) NSNumber * itemAddedToCart;
@property (nonatomic, retain) NSString * itemDescription;
@property (nonatomic, retain) NSData * itemImage;
@property (nonatomic, retain) NSString * itemName;


/*
 * Initialize context.
 * @param context
 * return CatalogItems
 */

+ (CatalogItems *)initWithContext:(NSManagedObjectContext *)context;

@end
