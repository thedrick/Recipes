//
//  MRBNewRecipeViewController.h
//  Recipes
//
//  Created by Tyler Hedrick on 2/11/14.
//  Copyright (c) 2014 Tyler Hedrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRBSingleSelectionView.h"

@interface MRBNewRecipeViewController : UIViewController <MRBSingleSelectionViewDataSource, MRBSingleSelectionViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *ingredientTable;
@property (weak, nonatomic) IBOutlet UITableView *directionTable;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImageView;
@property (weak, nonatomic) IBOutlet UITextField *recipeTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *prepTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *cookTimeTextField;

- (IBAction)addIngredient:(id)sender;
- (IBAction)addDirection:(id)sender;

@end