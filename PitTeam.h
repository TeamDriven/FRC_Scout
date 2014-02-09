//
//  PitTeam.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/8/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PitTeam : NSManagedObject

@property (nonatomic, retain) NSString * autonomous;
@property (nonatomic, retain) NSString * autoStartingPosition;
@property (nonatomic, retain) NSString * bumperQuality;
@property (nonatomic, retain) NSString * catchingMechanism;
@property (nonatomic, retain) NSString * driveTrain;
@property (nonatomic, retain) NSString * floorCollector;
@property (nonatomic, retain) NSString * goalieArm;
@property (nonatomic, retain) NSString * hotGoalTracking;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * preferredGoal;
@property (nonatomic, retain) NSString * shooter;
@property (nonatomic, retain) NSString * teamName;
@property (nonatomic, retain) NSString * teamNumber;
@property (nonatomic, retain) NSNumber * uniqueID;

@end
