//
//  MRBMasterViewController.m
//  Recipes
//
//  Created by Tyler Hedrick on 2/11/14.
//  Copyright (c) 2014 Tyler Hedrick. All rights reserved.
//

#import "MRBMasterViewController.h"
#import "MRBDetailViewController.h"
#import "MRBNewRecipeViewController.h"
#import "Recipe.h"
#import "Ingredient.h"
#import "Direction.h"

@interface MRBMasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MRBMasterViewController

- (void)awakeFromNib
{
  self.clearsSelectionOnViewWillAppear = NO;
  self.preferredContentSize = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  self.navigationItem.leftBarButtonItem = self.editButtonItem;

  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
  self.navigationItem.rightBarButtonItem = addButton;
  self.detailViewController = (MRBDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
  MRBNewRecipeViewController *newRecipeViewController = [[MRBNewRecipeViewController alloc] init];
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:newRecipeViewController];
  navController.modalPresentationStyle = UIModalPresentationPageSheet;
  navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  
  [self presentViewController:navController animated:YES completion:nil];
}

- (void)cancelNewRecipe
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addNewRecipe
{
  NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
  NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
  Recipe *newRecipe = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
  
  NSString *recipeFile = [[NSBundle mainBundle] pathForResource:@"recipes" ofType:@"json"];
  NSData *recipeData = [NSData dataWithContentsOfFile:recipeFile];
  NSError *jsonError = nil;
  NSDictionary *recipe = [NSJSONSerialization JSONObjectWithData:recipeData
                                                         options:NSJSONReadingAllowFragments
                                                           error:&jsonError];
  
  // If appropriate, configure the new managed object.
  // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
  newRecipe.timeStamp = [NSDate date];
  newRecipe.title = [recipe objectForKey:@"title"];
  
  NSArray *ingredientArray = [recipe objectForKey:@"ingredients"];
  NSMutableSet *ingredientsToAdd = [NSMutableSet set];
  for (NSDictionary *ingredientDict in ingredientArray) {
    Ingredient *newIngredient = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient"
                                                              inManagedObjectContext:newRecipe.managedObjectContext];
    newIngredient.amount = [[ingredientDict objectForKey:@"amount"] floatValue];
    newIngredient.measurement = [ingredientDict objectForKey:@"measurement"];
    newIngredient.name = [ingredientDict objectForKey:@"name"];
    [ingredientsToAdd addObject:newIngredient];
  }
  [newRecipe addIngredients:ingredientsToAdd];
  
  NSArray *directionArray = [recipe objectForKey:@"directions"];
  NSMutableSet *directionsToAdd = [NSMutableSet set];
  for (NSDictionary *directionDict in directionArray) {
    Direction *newDirection = [NSEntityDescription insertNewObjectForEntityForName:@"Direction"
                                                            inManagedObjectContext:newRecipe.managedObjectContext];
    newDirection.stepOrder = [[directionDict objectForKey:@"stepOrder"] integerValue];
    newDirection.directionValue = [directionDict objectForKey:@"directionValue"];
    [directionsToAdd addObject:newDirection];
  }
  [newRecipe addDirections:[directionsToAdd copy]];
  
  // Save the context.
  NSError *error = nil;
  if (![context save:&error]) {
       // Replace this implementation with code to handle the error appropriately.
       // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
  return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    self.detailViewController.detailItem = object;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[object valueForKey:@"title"] description];
}

@end
