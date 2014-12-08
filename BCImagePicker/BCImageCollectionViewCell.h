//
//  BCImageCollectionViewCell.h
//  BCImagePicker
//
//  Created by Chris O'Neil on 12/8/14.
//  Copyright (c) 2014 Chris O'Neil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCImageResult.h"

@interface BCImageCollectionViewCell : UICollectionViewCell

// Setting this property will handle image download and setting
@property (nonatomic, strong) BCImageResult *imageResult;

@end
