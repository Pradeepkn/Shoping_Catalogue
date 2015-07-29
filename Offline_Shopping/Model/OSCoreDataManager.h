//
//  OSCoreDataManager.h
//  Offline_Shopping
//
//  Created by Pradeep Narendra on 7/28/15.
//  Copyright (c) 2015 Pradeep Narendra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "OSItem.h"

@interface OSCoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/*
 * creates shared instances and invokes model.
 * @param none
 * return CHPModel
 */
+ (OSCoreDataManager *)sharedInstance;

/*
 * returns application document path according to system os version
 * @param none
 * return document directory path
 */
- (NSURL *)applicationDocumentsDirectory;

/*
 * Helper functions to save model
 * @param none
 * return YES if success
 */
- (BOOL)saveContext;

/*
 * Sync Catalog Item
 * @param item
 * return none
 */
- (void)syncCatalogItem:(OSItem *)item;

/*
 * Fetch Objects
 * @param none
 * return NSMutableArray
 */
- (NSMutableArray *)fetchObjects;

/**
 * deletes the given entity object.
 */
- (BOOL)purgeEntity:(NSString *)entity;

@end
