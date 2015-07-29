//
//  OSCoreDataManager.m
//  Offline_Shopping
//
//  Created by Pradeep Narendra on 7/28/15.
//  Copyright (c) 2015 Pradeep Narendra. All rights reserved.
//

#import "OSCoreDataManager.h"
#import "CatalogItems.h"

static NSString *const kitemName = @"itemName";
static NSString *const kitemImage = @"itemImage";
static NSString *const kitemDescription = @"itemDescription";
static NSString *const kitemAddedToCart = @"itemAddedToCart";

static NSString *const kCatalogItemsEntity = @"CatalogItems";

@implementation OSCoreDataManager

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

static OSCoreDataManager *modelInstance = nil;

+ (OSCoreDataManager *)sharedInstance {
    @synchronized(self) {
        if(modelInstance == nil) {
            modelInstance = [[super allocWithZone:NULL] init];
        }
    }
    return modelInstance;
}


+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedInstance];
}


- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "sample.Offline_Shopping" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Offline_Shopping" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@(YES),
                              NSInferMappingModelAutomaticallyOption:@(YES)};
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Offline_Shopping.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (BOOL)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
            return NO;
        }
    }
    return YES;
}

- (void)syncCatalogItem:(OSItem *)item {
    
    NSManagedObject *object = nil;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kCatalogItemsEntity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"itemName = %@", item.itemName]];
    [fetchRequest setFetchLimit:1];
    NSArray *objects = [context executeFetchRequest:fetchRequest error:nil];

    if (!objects.count) {
        object = [NSEntityDescription insertNewObjectForEntityForName:kCatalogItemsEntity
                                               inManagedObjectContext:self.managedObjectContext];
        [object setValue:item.itemName forKey:kitemName];
        [object setValue:item.itemDescription forKey:kitemDescription];
        [object setValue:[NSNumber numberWithBool:item.isItemAddedToCart] forKey:kitemAddedToCart];
        [object setValue:UIImagePNGRepresentation(item.image) forKey:kitemImage];
    } else {
        
        object = (NSManagedObject *)[objects objectAtIndex:0];
        [object setValue:[NSNumber numberWithBool:item.isItemAddedToCart] forKey:kitemAddedToCart];
        
    }
    [self saveContext];
}

- (NSMutableArray *)fetchObjects {
    NSMutableArray *itemsArray = nil;
    
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([CatalogItems class])];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    if (fetchedObjects.count) {
        itemsArray = [[NSMutableArray alloc] init];
        
        for (CatalogItems *object in fetchedObjects) {
            OSItem *item = [[OSItem alloc] init];
            item.itemName = object.itemName;
            item.itemDescription = object.itemDescription;
            item.isItemAddedToCart = [object.itemAddedToCart boolValue];
            UIImage *image = [UIImage imageWithData:object.itemImage];
            item.image = image;
            [itemsArray addObject:item];
        }
    }
    return itemsArray;
}

/**
 * deletes the given entity object.
 */
- (BOOL)purgeEntity:(NSString *)entity {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription	*entries = [NSEntityDescription entityForName:entity
                                               inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entries];
    NSError	*error = nil;
    NSArray	*objects = [self.managedObjectContext executeFetchRequest:fetchRequest
                                                                error:&error];
    for(NSManagedObject *object in objects){
        [self.managedObjectContext deleteObject:object];
        if(![self.managedObjectContext save:&error]) {
            return NO;
        }
    }
    return YES;
}

@end
