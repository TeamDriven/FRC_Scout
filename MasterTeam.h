//
//  MasterTeam.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/8/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Team;

@interface MasterTeam : NSManagedObject

@property (nonatomic, retain) NSSet *teamsWithin;
@end

@interface MasterTeam (CoreDataGeneratedAccessors)

- (void)addTeamsWithinObject:(Team *)value;
- (void)removeTeamsWithinObject:(Team *)value;
- (void)addTeamsWithin:(NSSet *)values;
- (void)removeTeamsWithin:(NSSet *)values;

@end
