//
//  OSDataManager.m
//  Offline_Shopping
//
//  Created by Pradeep Narendra on 7/28/15.
//  Copyright (c) 2015 Pradeep Narendra. All rights reserved.
//

#import "OSDataManager.h"

@implementation OSDataManager

+(OSDataManager*)sharedInstance{
    static OSDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super allocWithZone:NULL] init];
        sharedInstance.cartItemsArray = [[NSMutableArray alloc] init];
        sharedInstance.actualItemsArray = [[NSMutableArray alloc] init];
    });
    return sharedInstance;
}


@end
