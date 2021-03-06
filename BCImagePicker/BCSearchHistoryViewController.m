//
//  BCSearchHistoryViewController.m
//  BCImagePicker
//
//  Created by Chris O'Neil on 12/8/14.
//  Copyright (c) 2014 Chris O'Neil. All rights reserved.
//

#import "BCSearchHistoryViewController.h"
#import "BCSearchHistoryManager.h"

static NSString * const kHistoryCellIdentifier = @"BCHistoryCell";

@interface BCSearchHistoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BCSearchHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"History", nil);
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];

    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [BCSearchHistoryManager sharedManager].searches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHistoryCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHistoryCellIdentifier];
    }

    BCSearchHistoryManager *searchHistoryManager = [BCSearchHistoryManager sharedManager];
    cell.textLabel.text = searchHistoryManager.searches[searchHistoryManager.searches.count - indexPath.row - 1];

    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BCSearchHistoryManager *searchHistoryManager = [BCSearchHistoryManager sharedManager];
    NSString *query = searchHistoryManager.searches[searchHistoryManager.searches.count - indexPath.row - 1];

    if ([self.delegate respondsToSelector:@selector(searchHistoryViewController:didSelectQuery:)]) {
        [self.delegate searchHistoryViewController:self didSelectQuery:query];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
