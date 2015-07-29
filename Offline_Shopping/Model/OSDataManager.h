//
//  OSDataManager.h
//  Offline_Shopping
//
//  Created by Pradeep Narendra on 7/28/15.
//  Copyright (c) 2015 Pradeep Narendra. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @discussion
 
 ## Version information
 
 __Version__: 1.0
 
 __Found__:
 
 __Last update__:
 
 __Developer__:
 
 */

@interface OSDataManager : NSObject

@property (strong, nonatomic) NSMutableArray *cartItemsArray;

@property (strong, nonatomic) NSMutableArray *actualItemsArray;

/*!
 @abstract
 
 @discussion
 
 @return
 
 @since 1.0+
 */
+(OSDataManager*)sharedInstance;


@end
