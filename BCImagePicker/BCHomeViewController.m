//
//  BCHomeViewController.m
//  BCImagePicker
//
//  Created by Chris O'Neil on 12/8/14.
//  Copyright (c) 2014 Chris O'Neil. All rights reserved.
//

#import "BCHomeViewController.h"
#import "MosaicLayout.h"
#import "BCImageManager.h"
#import "BCImageCollectionViewCell.h"
#import "BCSearchHistoryManager.h"
#import "BCSearchHistoryViewController.h"

static const NSInteger kNumberOfColumns = 3;
static NSString * const kImageCellReuseIdentifier = @"BCImageCollectionViewCellIdentifier";

@interface BCHomeViewController() <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, MosaicLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation BCHomeViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Image Picker", nil);
    UIBarButtonItem *historyButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"History", nil) style:UIBarButtonItemStylePlain target:self action:@selector(historyButtonTapped:)];
    self.navigationItem.rightBarButtonItem = historyButton;

    // TODO: Get TopLayoutGuide working here
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 64.0, self.view.frame.size.width, 44.0)];
    self.searchBar.placeholder = NSLocalizedString(@"Search Google Images", nil);
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];

    MosaicLayout *mosaicLayout = [[MosaicLayout alloc] init];
    mosaicLayout.delegate = self;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.searchBar.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.searchBar.frame)) collectionViewLayout:mosaicLayout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.collectionView registerClass:[BCImageCollectionViewCell class] forCellWithReuseIdentifier:kImageCellReuseIdentifier];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.collectionView];
}

- (void)search:(NSString *)query {
    [[BCSearchHistoryManager sharedManager] addSearch:query];

    __weak BCHomeViewController *weakSelf = self;
    [[BCImageManager sharedManager] loadImagesWithQuery:query completion:^(NSArray *results, NSError *error) {
        [weakSelf.collectionView reloadData];
    }];
}

- (void)historyButtonTapped:(id)sender {
    BCSearchHistoryViewController *searchHistoryViewController = [[BCSearchHistoryViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:searchHistoryViewController animated:YES];
}

- (CGFloat)columnWidth {
    return self.view.frame.size.width / kNumberOfColumns;
}

- (CGFloat)columnHeight {
    return self.view.frame.size.height / 4.0;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [BCImageManager sharedManager].results.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BCImageCollectionViewCell *cell = (BCImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kImageCellReuseIdentifier forIndexPath:indexPath];

    cell.backgroundColor = [UIColor greenColor];
    cell.imageResult = [BCImageManager sharedManager].results[indexPath.item];

    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    BCImageResult *imageResult = [BCImageManager sharedManager].results[indexPath.item];
    return CGSizeMake(imageResult.thumbnailWidth, imageResult.thumbnailHeight);
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

// Performing a Search
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self search:searchBar.text];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = [BCImageManager sharedManager].query;
    [searchBar resignFirstResponder];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    // When we have scrolled to the bottom of the images we should request a set
    // of new images.  This gives us the "infinite scroll" effect.
    CGFloat bottom = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottom >= scrollView.contentSize.height) {

        BCImageManager *imageManager = [BCImageManager sharedManager];
        if (imageManager.state != BCImageManagerStateLoading && imageManager.state != BCImageManagerStateReachedEnd) {
            [imageManager loadNextImages:^(NSArray *results, NSError *error) {
                [self.collectionView reloadData];
            }];
        }
    }
}

#pragma mark - MosaicLayoutDelegate
- (float)collectionView:(UICollectionView *)collectionView relativeHeightForItemAtIndexPath:(NSIndexPath *)indexPath {
    BCImageResult *result = [BCImageManager sharedManager].results[indexPath.row];
    return result.thumbnailHeight / result.thumbnailWidth;
}

- (BOOL)collectionView:(UICollectionView *)collectionView isDoubleColumnAtIndexPath:(NSIndexPath *)indexPath {
    BCImageResult *result = [BCImageManager sharedManager].results[indexPath.row];
    return result.thumbnailWidth / 2.0 > result.thumbnailHeight;
}

- (NSUInteger)numberOfColumnsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

@end
