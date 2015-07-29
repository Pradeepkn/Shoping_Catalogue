//
//  OSItem.h
//  Offline_Shopping
//
//  Created by Pradeep Narendra on 7/27/15.
//  Copyright (c) 2015 Pradeep Narendra. All rights reserved.
//


/*!
 @discussion OSItem
 
 ## Version information
 
 __Version__: 1.0
 
 __Found__: 7/27/15
 
 __Last update__: 7/27/15
 
 __Developer__: Pradeep, Tarento Technologies Pvt Ltd.
 
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OSItem : NSObject

@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSString *itemDescription;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL isItemAddedToCart;

@end
