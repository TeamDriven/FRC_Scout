//
//  Match.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 1/19/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Team;

@interface Match : NSManagedObject

@property (nonatomic, retain) NSNumber * autoHighHotScore;
@property (nonatomic, retain) NSNumber * autoHighNotScore;
@property (nonatomic, retain) NSNumber * autoHighMissScore;
@property (nonatomic, retain) NSNumber * autoLowHotScore;
@property (nonatomic, retain) NSString * matchNum;
@property (nonatomic, retain) NSString * matchType;
@property (nonatomic, retain) NSNumber * penaltyLarge;
@property (nonatomic, retain) NSNumber * penaltySmall;
@property (nonatomic, retain) NSString * recordingTeam;
@property (nonatomic, retain) NSString * red1Pos;
@property (nonatomic, retain) NSString * scoutInitials;
@property (nonatomic, retain) NSNumber * teleopHighMiss;
@property (nonatomic, retain) NSNumber * teleopLowMake;
@property (nonatomic, retain) NSNumber * teleopLowMiss;
@property (nonatomic, retain) NSNumber * uniqeID;
@property (nonatomic, retain) NSNumber * teleopHighMake;
@property (nonatomic, retain) NSNumber * mobilityBonus;
@property (nonatomic, retain) NSNumber * autoLowMissScore;
@property (nonatomic, retain) NSNumber * autoLowNotScore;
@property (nonatomic, retain) NSNumber * teleopOver;
@property (nonatomic, retain) NSNumber * teleopCatch;
@property (nonatomic, retain) NSNumber * teleopPassed;
@property (nonatomic, retain) NSNumber * teleopReceived;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) Team *teamNum;

@end
