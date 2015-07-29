//
//  OSItemTableCell.m
//  Offline_Shopping
//
//  Created by Pradeep Narendra on 7/27/15.
//  Copyright (c) 2015 Pradeep Narendra. All rights reserved.
//

#import "OSItemTableCell.h"

@implementation OSItemTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.addToCartButton.layer.shadowOffset = CGSizeMake(1, 1);
    self.addToCartButton.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    self.addToCartButton.layer.masksToBounds = NO;
    self.addToCartButton.layer.shadowOpacity = 0.80f;
    self.addToCartButton.layer.shadowRadius = 1.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
