//
//  Team+Category.h
//  FIRST Scouting App
//
//  Created by Louie Bertoncin on 12/29/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import "Team.h"

@interface Team (Category)

+(Team *)createTeamWithName:(NSString *)name inRegional:(Regional *)rgnl withManagedObjectContext:(NSManagedObjectContext *)context;

-(float)autoHighHotAvg;
-(float)autoHighMissAvg;
-(float)autoHighNotAvg;
-(float)autoHighMakesAvg;
-(float)autoHighAttemptsAvg;
-(float)autoHighHotPercentage;
-(float)autoHighAccuracyPercentage;
-(float)autoLowHotAvg;
-(float)autoLowMissAvg;
-(float)autoLowNotAvg;
-(float)autoLowMakesAvg;
-(float)autoLowAttemptsAvg;
-(float)autoLowHotPercentage;
-(float)autoLowAccuracyPercentage;
-(float)autoAccuracyPercentage;
-(float)mobilityBonusPercentage;
-(float)autonomousAvg;

-(float)teleopHighMakeAvg;
-(float)teleopHighMissAvg;
-(float)teleopHighAttemptsAvg;
-(float)teleopHighAccuracyPercentage;
-(float)teleopLowMakeAvg;
-(float)teleopLowMissAvg;
-(float)teleopLowAttemptsAvg;
-(float)teleopLowAccuracyPercentage;
-(float)teleopAccuracyPercentage;
-(float)teleopCatchAvg;
-(float)teleopOverAvg;
-(float)teleopPassedAvg;
-(float)teleopReceivedAvg;
-(float)teleopPassReceiveRatio;
-(float)teleopAvg;

-(float)smallPenaltyAvg;
-(float)largePenaltyAvg;
-(float)penaltyTotalAvg;

-(float)offensiveZonePercentage;
-(float)neutralZonePercentage;
-(float)defensiveZonePercentage;

@end
