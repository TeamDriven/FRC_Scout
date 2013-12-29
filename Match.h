//
//  Match.h
//  FIRST Scouting App
//
//  Created by Louie Bertoncin on 12/28/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Team;

@interface Match : NSManagedObject

@property (nonatomic, retain) NSNumber * autoHighScore;
@property (nonatomic, retain) NSNumber * autoLowScore;
@property (nonatomic, retain) NSNumber * autoMidScore;
@property (nonatomic, retain) NSNumber * endGame;
@property (nonatomic, retain) NSString * matchNum;
@property (nonatomic, retain) NSString * matchType;
@property (nonatomic, retain) NSNumber * penaltyLarge;
@property (nonatomic, retain) NSNumber * penaltySmall;
@property (nonatomic, retain) NSString * scoutInitials;
@property (nonatomic, retain) NSNumber * teleHighScore;
@property (nonatomic, retain) NSNumber * teleLowScore;
@property (nonatomic, retain) NSNumber * teleMidScore;
@property (nonatomic, retain) NSString * red1Pos;
@property (nonatomic, retain) Team *teamNum;

@end
