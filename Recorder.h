//
//  Recorder.h
//  FIRST Scouting App
//
//  Created by Louie Bertoncin on 12/28/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Regional;

@interface Recorder : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *regionals;
@end

@interface Recorder (CoreDataGeneratedAccessors)

- (void)addRegionalsObject:(Regional *)value;
- (void)removeRegionalsObject:(Regional *)value;
- (void)addRegionals:(NSSet *)values;
- (void)removeRegionals:(NSSet *)values;

@end
