//
//  BCSearchHistoryViewController.h
//  BCImagePicker
//
//  Created by Chris O'Neil on 12/8/14.
//  Copyright (c) 2014 Chris O'Neil. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BCSearchHistoryViewControllerDelegate;

@interface BCSearchHistoryViewController : UIViewController
@property (nonatomic, weak) id<BCSearchHistoryViewControllerDelegate> delegate;
@end

@protocol BCSearchHistoryViewControllerDelegate <NSObject>
@optional
- (void)searchHistoryViewController:(BCSearchHistoryViewController *)viewController didSelectQuery:(NSString *)query;

@end