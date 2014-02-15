//
//  Team.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/15/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MasterTeam, Match, Regional;

@interface Team : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * autoHighHotAvg;
@property (nonatomic, retain) NSNumber * autoHighMissAvg;
@property (nonatomic, retain) NSNumber * autoHighNotAvg;
@property (nonatomic, retain) NSNumber * autoHighMakesAvg;
@property (nonatomic, retain) NSNumber * autoHighAttemptsAvg;
@property (nonatomic, retain) NSNumber * autoHighHotPercentage;
@property (nonatomic, retain) NSNumber * autoHighAccuracyPercentage;
@property (nonatomic, retain) NSNumber * autoLowHotAvg;
@property (nonatomic, retain) NSNumber * autoLowMissAvg;
@property (nonatomic, retain) NSNumber * autoLowNotAvg;
@property (nonatomic, retain) NSNumber * autoLowMakesAvg;
@property (nonatomic, retain) NSNumber * autoLowAttemptsAvg;
@property (nonatomic, retain) NSNumber * autoLowHotPercentage;
@property (nonatomic, retain) NSNumber * autoLowAccuracyPercentage;
@property (nonatomic, retain) NSNumber * autoAccuracyPercentage;
@property (nonatomic, retain) NSNumber * autonomousAvg;
@property (nonatomic, retain) NSNumber * teleopHighMakeAvg;
@property (nonatomic, retain) NSNumber * teleopHighMissAvg;
@property (nonatomic, retain) NSNumber * teleopHighAttemptsAvg;
@property (nonatomic, retain) NSNumber * teleopHighAccuracyPercentage;
@property (nonatomic, retain) NSNumber * teleopLowMakeAvg;
@property (nonatomic, retain) NSNumber * teleopLowMissAvg;
@property (nonatomic, retain) NSNumber * teleopLowAttemptsAvg;
@property (nonatomic, retain) NSNumber * teleopLowAccuracyPercentage;
@property (nonatomic, retain) NSNumber * teleopAccuracyPercentage;
@property (nonatomic, retain) NSNumber * teleopCatchAvg;
@property (nonatomic, retain) NSNumber * teleopOverAvg;
@property (nonatomic, retain) NSNumber * teleopPassedAvg;
@property (nonatomic, retain) NSNumber * teleopReceivedAvg;
@property (nonatomic, retain) NSNumber * teleopPassReceiveRatio;
@property (nonatomic, retain) NSNumber * teleopAvg;
@property (nonatomic, retain) NSNumber * smallPenaltyAvg;
@property (nonatomic, retain) NSNumber * largePenaltyAvg;
@property (nonatomic, retain) NSNumber * penaltyTotalAvg;
@property (nonatomic, retain) NSNumber * offensiveZonePercentage;
@property (nonatomic, retain) NSNumber * neutralZonePercentage;
@property (nonatomic, retain) NSNumber * defensiveZonePercentage;
@property (nonatomic, retain) NSNumber * mobilityBonusPercentage;
@property (nonatomic, retain) Regional *firstPickListRegional;
@property (nonatomic, retain) MasterTeam *master;
@property (nonatomic, retain) NSSet *matches;
@property (nonatomic, retain) Regional *regionalIn;
@property (nonatomic, retain) Regional *secondPickListRegional;
@end

@interface Team (CoreDataGeneratedAccessors)

- (void)addMatchesObject:(Match *)value;
- (void)removeMatchesObject:(Match *)value;
- (void)addMatches:(NSSet *)values;
- (void)removeMatches:(NSSet *)values;

@end
