//
//  OSProductCatalogViewController.m
//  Offline_Shopping
//
//  Created by Pradeep Narendra on 7/27/15.
//  Copyright (c) 2015 Pradeep Narendra. All rights reserved.
//

#import "OSProductCatalogViewController.h"
#import "OSCartViewController.h"
#import "OSItemTableCell.h"
#import "OSDataManager.h"
#import "OSItem.h"
#import "OSCoreDataManager.h"

static NSString *const kCatalogCellIdentifier = @"Cell";
static NSString *const kCartSegueIdentifier = @"CartSegue";

@interface OSProductCatalogViewController () {
    NSMutableArray *catalogItemsArray;
    BOOL showSyncedData;
}

@property (weak, nonatomic) IBOutlet UITableView *catalogTableView;
@property (weak, nonatomic) IBOutlet UISwitch *syncSwitch;
@property (weak, nonatomic) IBOutlet UIButton *syncButton;

@end

@implementation OSProductCatalogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self syncData:YES];
    [self initializeArray];
    catalogItemsArray = [[OSCoreDataManager sharedInstance] fetchObjects];
    for (OSItem *item in catalogItemsArray) {
        [[[OSDataManager sharedInstance] actualItemsArray] addObject:item];
    }
    showSyncedData = NO;
}

- (void)initializeArray {
    catalogItemsArray = [[NSMutableArray alloc] init];
}

- (IBAction)itemAddButtonClicked:(id)sender {
    if (!catalogItemsArray) {
        [self initializeArray];
    }
    OSItem *item = [[OSItem alloc] init];
    item.itemName = [NSString stringWithFormat:@"Item %lu", (unsigned long)catalogItemsArray.count];
    item.itemDescription = [NSString stringWithFormat:@"Item Description... %lu", (unsigned long)catalogItemsArray.count];
    item.isItemAddedToCart = FALSE;
    [[[OSDataManager sharedInstance] actualItemsArray] addObject:item];
    [self.catalogTableView reloadData];
    [self scrollTableToBottom];
    if ([self isDataSyncEnabled]) {
        [[OSCoreDataManager sharedInstance] syncCatalogItem:item];
    }
}

- (void)scrollTableToBottom {
    if (catalogItemsArray.count) {
        NSIndexPath* ipath = [NSIndexPath indexPathForRow: catalogItemsArray.count - 1 inSection: 0];
        [self.catalogTableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
    }
}

- (IBAction)switchValueChanged:(id)sender {
    if([sender isOn]){
        [self syncData:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sync Data" message:@"Data will be synced" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    } else{
        [self syncData:NO];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sync Data" message:@"Data will not be synced" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (showSyncedData) {
        catalogItemsArray = [[OSCoreDataManager sharedInstance] fetchObjects];
    }else{
        catalogItemsArray = [[OSDataManager sharedInstance] actualItemsArray];
    }
    return [catalogItemsArray count];
}

#pragma mark -
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    OSItemTableCell *itemCell =
    [tableView dequeueReusableCellWithIdentifier:kCatalogCellIdentifier];
    itemCell.selectionStyle = UITableViewCellSelectionStyleNone;
    itemCell.addToCartButton.tag = indexPath.row;
    
    [itemCell.addToCartButton addTarget:self action:@selector(addToCartButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    OSItem *item = (OSItem *)[catalogItemsArray objectAtIndex:indexPath.row];
    itemCell.titleLabel.text = item.itemName;
    itemCell.detailLabel.text = item.itemDescription;
    if (item.isItemAddedToCart) {
        [itemCell.addToCartButton setTitle:NSLocalizedString(@"Remove from Cart", nil) forState:UIControlStateNormal];
    }else{
        [itemCell.addToCartButton setTitle:NSLocalizedString(@"Add to Cart", nil) forState:UIControlStateNormal];
    }
    int imageIndex = (indexPath.row % 10);
    UIImage *itemImage = [UIImage imageNamed:[NSString stringWithFormat:@"%d", imageIndex]];
    item.image = itemImage;
    itemCell.itemImageView.image = itemImage;
    return itemCell;
}
#pragma mark -

#pragma mark - UITableViewDelegate
#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:kCartSegueIdentifier sender:self];
}
#pragma mark -


- (void)addToCartButtonClicked:(UIButton *)sender {
    NSInteger index = sender.tag;
    OSItem *item = (OSItem *)[catalogItemsArray objectAtIndex:index];

    if (item.isItemAddedToCart) {
        item.isItemAddedToCart = [NSNumber numberWithBool:FALSE];
        [[[OSDataManager sharedInstance] cartItemsArray] removeObject:item];
    }else{
        item.isItemAddedToCart = [NSNumber numberWithBool:TRUE];
        [[[OSDataManager sharedInstance] cartItemsArray] addObject:item];
    }
    if ([self isDataSyncEnabled]) {
        [[OSCoreDataManager sharedInstance] syncCatalogItem:item];
    }
    [self.catalogTableView reloadData];
}

- (IBAction)syncHistoryButtonClicked:(id)sender {
    if (!showSyncedData) {
        showSyncedData = YES;
        self.syncButton.backgroundColor = [UIColor lightGrayColor];
        [self.syncButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.syncButton setTitle:@"Back" forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem.enabled = NO;
    }else{
        showSyncedData = NO;
        self.syncButton.backgroundColor = [UIColor blackColor];
        [self.syncButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.syncButton setTitle:@"Show Synced Data" forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
    [self.catalogTableView reloadData];
}

- (void)syncData:(BOOL)syncData {
    [[NSUserDefaults standardUserDefaults] setBool:syncData forKey:@"SYNC_DATA"];
}

- (BOOL)isDataSyncEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"SYNC_DATA"];
}

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
