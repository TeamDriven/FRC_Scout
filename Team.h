//
//  Team.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/8/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MasterTeam, Match, Regional;

@interface Team : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *matches;
@property (nonatomic, retain) Regional *regionalIn;
@property (nonatomic, retain) MasterTeam *master;
@end

@interface Team (CoreDataGeneratedAccessors)

- (void)addMatchesObject:(Match *)value;
- (void)removeMatchesObject:(Match *)value;
- (void)addMatches:(NSSet *)values;
- (void)removeMatches:(NSSet *)values;

@end
