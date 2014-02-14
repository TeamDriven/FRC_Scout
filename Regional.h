//
//  Regional.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/13/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Team;

@interface Regional : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSOrderedSet *firstPickList;
@property (nonatomic, retain) NSOrderedSet *secondPickList;
@property (nonatomic, retain) NSSet *teams;
@end

@interface Regional (CoreDataGeneratedAccessors)

- (void)insertObject:(Team *)value inFirstPickListAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFirstPickListAtIndex:(NSUInteger)idx;
- (void)insertFirstPickList:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFirstPickListAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFirstPickListAtIndex:(NSUInteger)idx withObject:(Team *)value;
- (void)replaceFirstPickListAtIndexes:(NSIndexSet *)indexes withFirstPickList:(NSArray *)values;
- (void)addFirstPickListObject:(Team *)value;
- (void)removeFirstPickListObject:(Team *)value;
- (void)addFirstPickList:(NSOrderedSet *)values;
- (void)removeFirstPickList:(NSOrderedSet *)values;

- (void)insertObject:(Team *)value inSecondPickListAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSecondPickListAtIndex:(NSUInteger)idx;
- (void)insertSecondPickList:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSecondPickListAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSecondPickListAtIndex:(NSUInteger)idx withObject:(Team *)value;
- (void)replaceSecondPickListAtIndexes:(NSIndexSet *)indexes withSecondPickList:(NSArray *)values;
- (void)addSecondPickListObject:(Team *)value;
- (void)removeSecondPickListObject:(Team *)value;
- (void)addSecondPickList:(NSOrderedSet *)values;
- (void)removeSecondPickList:(NSOrderedSet *)values;

- (void)addTeamsObject:(Team *)value;
- (void)removeTeamsObject:(Team *)value;
- (void)addTeams:(NSSet *)values;
- (void)removeTeams:(NSSet *)values;

@end
