//
//  MRBMasterViewController.h
//  Recipes
//
//  Created by Tyler Hedrick on 2/11/14.
//  Copyright (c) 2014 Tyler Hedrick. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRBDetailViewController;

#import <CoreData/CoreData.h>

@interface MRBMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) MRBDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
