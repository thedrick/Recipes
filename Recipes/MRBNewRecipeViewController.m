//
//  MRBNewRecipeViewController.m
//  Recipes
//
//  Created by Tyler Hedrick on 2/11/14.
//  Copyright (c) 2014 Tyler Hedrick. All rights reserved.
//

#import "MRBNewRecipeViewController.h"

static NSString * const ingredientCellIdentifier = @"ingredientCell";

@interface MRBNewRecipeViewController () <UIPopoverControllerDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NSArray *measurementValues;
@property (nonatomic) MRBSingleSelectionViewController *measurementSelectionViewController;
@property (nonatomic, strong) UIPopoverController *singleSelectionPopoverController;
@property (nonatomic) NSMutableArray *ingredientList;
@end

@implementation MRBNewRecipeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"MRBNewRecipeViewController" bundle:nil];
    if (self) {
      
    }
    return self;
}

- (id)init
{
  return [self initWithNibName:@"MRBNewRecipeViewController" bundle:nil];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.measurementValues = @[@"tsp.", @"tbsp.", @"cups", @"none"];
  self.measurementSelectionViewController = [[MRBSingleSelectionViewController alloc] init];
  self.measurementSelectionViewController.delegate = self;
  self.measurementSelectionViewController.dataSource = self;
  
  self.ingredientList = [NSMutableArray array];
  self.ingredientTable.delegate = self;
  self.ingredientTable.dataSource = self;
  [self.ingredientTable registerClass:[UITableViewCell class]
               forCellReuseIdentifier:ingredientCellIdentifier];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                        target:self
                                                                                        action:@selector(cancelRecipe)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                         target:self
                                                                                         action:@selector(saveRecipe)];
  
}

- (void)cancelRecipe
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveRecipe
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)addIngredient:(id)sender
//{
//  if (self.singleSelectionPopoverController == nil) {
//    self.singleSelectionPopoverController = [[UIPopoverController alloc] initWithContentViewController:self.measurementSelectionViewController];
//  }
//  self.singleSelectionPopoverController.delegate = self;
//  UIButton *buttonSender = (UIButton *)sender;
//  CGPoint buttonPoint = CGPointMake(CGRectGetMidX(buttonSender.frame),
//                                    CGRectGetMidY(buttonSender.frame));
//  [self.singleSelectionPopoverController setPopoverContentSize:CGSizeMake(self.measurementSelectionViewController.tableView.frame.size.width, self.measurementSelectionViewController.tableView.frame.size.height)];
//  [self.singleSelectionPopoverController presentPopoverFromRect:CGRectMake(buttonPoint.x - 120,
//                                                                           buttonPoint.y,
//                                                                           240,
//                                                                           20)
//                                                         inView:self.view
//                                       permittedArrowDirections:UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown
//                                                       animated:YES];
//  
//}

- (IBAction)addIngredient:(id)sender
{
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add Ingredient"
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Add", nil];
  alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
  [alertView show];
}

- (IBAction)addDirection:(id)sender
{
  
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == alertView.cancelButtonIndex) {
    return;
  }
  UITextField *textField = [alertView textFieldAtIndex:0];
  NSString *value = textField.text;
  value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if ([value isEqualToString:@""]) {
    return;
  }
  [self.ingredientList addObject:value];
  [self.ingredientTable reloadData];
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
  
}

#pragma mark - 
#pragma mark MRBSingleSelectionViewDataSource

- (NSString *)singleSelectionView:(MRBSingleSelectionViewController *)selectionView optionForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([selectionView isEqual:self.measurementSelectionViewController]) {
    return [self.measurementValues objectAtIndex:indexPath.row];
  }
  return nil;
}

- (NSInteger)numberOfOptionsForSingleSelectionView:(MRBSingleSelectionViewController *)selectionView
{
  if ([selectionView isEqual:self.measurementSelectionViewController]) {
    return self.measurementValues.count;
  }
  return 0;
}

#pragma mark -
#pragma mark MRBSingleSelectionViewDelegate

- (void)singleSelectionView:(MRBSingleSelectionViewController *)selectionView didSelectIndex:(NSIndexPath *)indexPath
{
  [self.singleSelectionPopoverController dismissPopoverAnimated:YES];
}

- (void)singleSelectionViewDidCancel:(MRBSingleSelectionViewController *)selectionView
{
  [self.singleSelectionPopoverController dismissPopoverAnimated:YES];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark -
#pragma mark UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 40.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if ([tableView isEqual:self.ingredientTable]) {
    return self.ingredientList.count;
  }
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ingredientCellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:ingredientCellIdentifier];
  }
  cell.textLabel.text = [self.ingredientList objectAtIndex:indexPath.row];
  return cell;
}

@end
