//
//  OSItemTableCell.h
//  Offline_Shopping
//
//  Created by Pradeep Narendra on 7/27/15.
//  Copyright (c) 2015 Pradeep Narendra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSItemTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *addToCartButton;

@end
