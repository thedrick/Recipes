//
//  Ingredient.h
//  Recipes
//
//  Created by Tyler Hedrick on 2/11/14.
//  Copyright (c) 2014 Tyler Hedrick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Recipe;

@interface Ingredient : NSManagedObject

@property (nonatomic) float amount;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * measurement;
@property (nonatomic, retain) Recipe *recipe;

@end
