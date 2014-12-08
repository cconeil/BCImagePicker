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

static const NSInteger kNumberOfColumns = 3;
static NSString * const kImageCellReuseIdentifier = @"BCImageCollectionViewCellIdentifier";

@interface BCHomeViewController() <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation BCHomeViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    // TODO: Get TopLayoutGuide working here
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 64.0, self.view.frame.size.width, 44.0)];
    self.searchBar.placeholder = NSLocalizedString(@"Search Google Images", nil);
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.searchBar.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.searchBar.frame)) collectionViewLayout:flowLayout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.collectionView registerClass:[BCImageCollectionViewCell class] forCellWithReuseIdentifier:kImageCellReuseIdentifier];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.collectionView];
}

- (void)search {

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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    __weak BCHomeViewController *weakSelf = self;
    [[BCImageManager sharedManager] loadImagesWithQuery:searchBar.text completion:^(NSArray *results, NSError *error) {
        [weakSelf.collectionView reloadData];
    }];

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
    return 40.0;
}

- (BOOL)collectionView:(UICollectionView *)collectionView isDoubleColumnAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSUInteger)numberOfColumnsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

@end
