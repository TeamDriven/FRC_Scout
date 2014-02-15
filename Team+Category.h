//
//  Team+Category.h
//  FIRST Scouting App
//
//  Created by Louie Bertoncin on 12/29/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import "Team.h"
#import "Regional.h"
#import "MasterTeam.h"
#import "Match.h"

@interface Team (Category)

+(Team *)createTeamWithName:(NSString *)name inRegional:(Regional *)rgnl withManagedObjectContext:(NSManagedObjectContext *)context;

-(float)autoHighHotAvgCalculated;

-(float)autoHighMissAvgCalculated;

-(float)autoHighNotAvgCalculated;

-(float)autoHighMakesAvgCalculated;

-(float)autoHighAttemptsAvgCalculated;

-(float)autoHighHotPercentageCalculated;

-(float)autoHighAccuracyPercentageCalculated;

-(float)autoLowHotAvgCalculated;

-(float)autoLowMissAvgCalculated;

-(float)autoLowNotAvgCalculated;

-(float)autoLowMakesAvgCalculated;

-(float)autoLowAttemptsAvgCalculated;

-(float)autoLowHotPercentageCalculated;

-(float)autoLowAccuracyPercentageCalculated;

-(float)autoAccuracyPercentageCalculated;

-(float)mobilityBonusPercentageCalculated;

-(float)autonomousAvgCalculated;



-(float)teleopHighMakeAvgCalculated;

-(float)teleopHighMissAvgCalculated;

-(float)teleopHighAttemptsAvgCalculated;

-(float)teleopHighAccuracyPercentageCalculated;

-(float)teleopLowMakeAvgCalculated;

-(float)teleopLowMissAvgCalculated;

-(float)teleopLowAttemptsAvgCalculated;

-(float)teleopLowAccuracyPercentageCalculated;

-(float)teleopAccuracyPercentageCalculated;

-(float)teleopCatchAvgCalculated;

-(float)teleopOverAvgCalculated;

-(float)teleopPassedAvgCalculated;

-(float)teleopReceivedAvgCalculated;

-(float)teleopPassReceiveRatioCalculated;

-(float)teleopAvgCalculated;



-(float)smallPenaltyAvgCalculated;

-(float)largePenaltyAvgCalculated;

-(float)penaltyTotalAvgCalculated;



-(float)offensiveZonePercentageCalculated;

-(float)neutralZonePercentageCalculated;

-(float)defensiveZonePercentageCalculated;


-(void)updateTeamAveragesForTeam:(Team *)team;

@end





















