//
//  Team.h
//  FIRST Scouting App
//
//  Created by Louie Bertoncin on 12/27/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Match, Regional;

@interface Team : NSManagedObject

@property (nonatomic, retain) Regional *regionalIn;
@property (nonatomic, retain) NSSet *matches;
@end

@interface Team (CoreDataGeneratedAccessors)

- (void)addMatchesObject:(Match *)value;
- (void)removeMatchesObject:(Match *)value;
- (void)addMatches:(NSSet *)values;
- (void)removeMatches:(NSSet *)values;

@end
