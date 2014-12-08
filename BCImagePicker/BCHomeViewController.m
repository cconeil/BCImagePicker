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

@interface BCHomeViewController() <UICollectionViewDataSource, UICollectionViewDelegate, MosaicLayoutDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation BCHomeViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    MosaicLayout *mosaicLayout = [[MosaicLayout alloc] init];
    mosaicLayout.delegate = self;


    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    


    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];

    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.collectionView registerClass:[BCImageCollectionViewCell class] forCellWithReuseIdentifier:kImageCellReuseIdentifier];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.collectionView];

    __weak BCHomeViewController *weakSelf = self;
    [[BCImageManager sharedManager] loadImagesWithQuery:@"monkey" completion:^(NSArray *results, NSError *error) {
        [weakSelf.collectionView reloadData];
    }];
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
