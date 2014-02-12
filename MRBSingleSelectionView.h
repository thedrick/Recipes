//
//  MRBSingleSelectionView.h
//  Recipes
//
//  Created by Tyler Hedrick on 2/12/14.
//  Copyright (c) 2014 Tyler Hedrick. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MRBSingleSelectionViewDataSource;
@protocol MRBSingleSelectionViewDelegate;

@interface MRBSingleSelectionViewController : UITableViewController
@property (nonatomic) id<MRBSingleSelectionViewDelegate> delegate;
@property (nonatomic) id<MRBSingleSelectionViewDataSource> dataSource;
@end

@protocol MRBSingleSelectionViewDataSource <NSObject>

- (NSString *)singleSelectionView:(MRBSingleSelectionViewController *)selectionView optionForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfOptionsForSingleSelectionView:(MRBSingleSelectionViewController *)selectionView;

@end

@protocol MRBSingleSelectionViewDelegate <NSObject>

- (void)singleSelectionView:(MRBSingleSelectionViewController *)selectionView
             didSelectIndex:(NSIndexPath *)indexPath;
- (void)singleSelectionViewDidCancel:(MRBSingleSelectionViewController *)selectionView;

@end
