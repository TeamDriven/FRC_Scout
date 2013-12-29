//
//  Regional.h
//  FIRST Scouting App
//
//  Created by Louie Bertoncin on 12/28/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Recorder, Team;

@interface Regional : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *teams;
@property (nonatomic, retain) Recorder *whoRecorded;
@end

@interface Regional (CoreDataGeneratedAccessors)

- (void)addTeamsObject:(Team *)value;
- (void)removeTeamsObject:(Team *)value;
- (void)addTeams:(NSSet *)values;
- (void)removeTeams:(NSSet *)values;

@end