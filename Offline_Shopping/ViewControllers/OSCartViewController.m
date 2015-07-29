//
//  OSCartViewController.m
//  Offline_Shopping
//
//  Created by Pradeep Narendra on 7/27/15.
//  Copyright (c) 2015 Pradeep Narendra. All rights reserved.
//

#import "OSCartViewController.h"
#import "OSItemTableCell.h"
#import "OSDataManager.h"
#import "OSItem.h"

static NSString *const kCatalogCellIdentifier = @"Cell";

@interface OSCartViewController ()

@property (weak, nonatomic) IBOutlet UITableView *cartTableView;
@end

@implementation OSCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[OSDataManager sharedInstance] cartItemsArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    OSItemTableCell *itemCell =
    [tableView dequeueReusableCellWithIdentifier:kCatalogCellIdentifier];
    itemCell.selectionStyle = UITableViewCellSelectionStyleNone;
    itemCell.addToCartButton.hidden = YES;
    
    OSItem *item = (OSItem *)[[[OSDataManager sharedInstance] cartItemsArray] objectAtIndex:indexPath.row];
    itemCell.titleLabel.text = item.itemName;
    itemCell.detailLabel.text = item.itemDescription;
    itemCell.itemImageView.image = item.image;
    return itemCell;
}
#pragma mark -

#pragma mark - UITableViewDelegate
#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark -


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
