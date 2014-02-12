//
//  Direction.h
//  Recipes
//
//  Created by Tyler Hedrick on 2/11/14.
//  Copyright (c) 2014 Tyler Hedrick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Recipe;

@interface Direction : NSManagedObject

@property (nonatomic) int16_t stepOrder;
@property (nonatomic, retain) NSString * directionValue;
@property (nonatomic, retain) Recipe *recipe;

@end
