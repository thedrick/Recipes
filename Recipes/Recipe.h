//
//  Recipe.h
//  Recipes
//
//  Created by Tyler Hedrick on 2/11/14.
//  Copyright (c) 2014 Tyler Hedrick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Direction, Ingredient;

@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *ingredients;
@property (nonatomic, retain) NSSet *directions;
@end

@interface Recipe (CoreDataGeneratedAccessors)

- (void)addIngredientsObject:(Ingredient *)value;
- (void)removeIngredientsObject:(Ingredient *)value;
- (void)addIngredients:(NSSet *)values;
- (void)removeIngredients:(NSSet *)values;

- (void)addDirectionsObject:(Direction *)value;
- (void)removeDirectionsObject:(Direction *)value;
- (void)addDirections:(NSSet *)values;
- (void)removeDirections:(NSSet *)values;

@end
