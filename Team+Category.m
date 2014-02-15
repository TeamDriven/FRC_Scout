//
//  Team+Category.m
//  FIRST Scouting App
//
//  Created by Louie Bertoncin on 12/29/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import "Team+Category.h"

@implementation Team (Category)

+(Team *)createTeamWithName:(NSString *)name inRegional:(Regional *)rgnl withManagedObjectContext:(NSManagedObjectContext *)context{
    Team *team = nil;
    
    NSFetchRequest *teamRequest = [NSFetchRequest fetchRequestWithEntityName:@"Team"];
    NSPredicate *teamPredicate = [NSPredicate predicateWithFormat:@"(name = %@) AND (regionalIn.name = %@)", name, rgnl.name];
    teamRequest.predicate = teamPredicate;
    
    NSError *teamError;
    NSArray *teams = [context executeFetchRequest:teamRequest error:&teamError];
    
    //Received some sort of error
    if (!teams || teamError) {
        NSLog(@"Team Error: %@", teamError);
    }
    //Found just one instance
    else if ([teams count] == 1){
        NSLog(@"Found one team match");
        team = [teams firstObject];
    }
    //Found multiple instances
    else if ([teams count] > 1){
        for (Team *t in teams) {
            NSLog(@"Team: %@", t.name);
        }
    }
    //Found no instances and creates a new one
    else{
        team = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:context];
        team.name = name;
        
        [rgnl addTeamsObject:team];
        
        NSLog(@"Created a new team named: %@", team.name);
        
        NSFetchRequest *masterRequest = [NSFetchRequest fetchRequestWithEntityName:@"MasterTeam"];
        masterRequest.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
        NSError *masterError;
        NSArray *masterArray = [context executeFetchRequest:masterRequest error:&masterError];
        
        MasterTeam *mt = nil;
        
        if (!masterArray || masterError) {
            NSLog(@"Master Error: %@", masterError);
        }
        else if ([masterArray count] == 1){
            mt = [masterArray firstObject];
            [mt addTeamsWithinObject:team];
            NSLog(@"Added team to master: %@", mt.name);
        }
        else if ([masterArray count] > 1){
            for (MasterTeam *master in masterArray) {
                NSLog(@"Master Team: %@", master.name);
            }
        }
        else{
            mt = [NSEntityDescription insertNewObjectForEntityForName:@"MasterTeam" inManagedObjectContext:context];
            mt.name = name;
            [mt addTeamsWithinObject:team];
            
            NSLog(@"Created a new master team named: %@", mt.name);
        }
    }
    
    return team;
}

-(NSUInteger)indexInFirstPickList{
    NSUInteger index = [self.firstPickListRegional.firstPickList indexOfObject:self];
    
    return index;
}

-(NSUInteger)indexInSecondPickList{
    NSUInteger index = [self.secondPickListRegional.secondPickList indexOfObject:self];
    
    return index;
}

-(float)autoHighHotAvgCalculated{
    float autoHighHotAvg = 0;
    for (Match *mtch in self.matches) {
        autoHighHotAvg += [mtch.autoHighHotScore floatValue];
    }
    
    if ([self.matches count] > 0) {
        autoHighHotAvg = (float)autoHighHotAvg/(float)[self.matches count];
    }
    
    return autoHighHotAvg;
}
-(float)autoHighMissAvgCalculated{
    float autoHighMissAvg = 0;
    for (Match *mtch in self.matches) {
        autoHighMissAvg += [mtch.autoHighMissScore floatValue];
    }
    
    if ([self.matches count] > 0) {
        autoHighMissAvg = (float)autoHighMissAvg/(float)[self.matches count];
    }
    
    return autoHighMissAvg;
}
-(float)autoHighNotAvgCalculated{
    float autoHighNotAvg = 0;
    for (Match *mtch in self.matches) {
        autoHighNotAvg += [mtch.autoHighNotScore floatValue];
    }
    
    if ([self.matches count] > 0) {
        autoHighNotAvg = (float)autoHighNotAvg/(float)[self.matches count];
    }
    
    return autoHighNotAvg;
}
-(float)autoHighMakesAvgCalculated{
    float autoHighMakesAvg = 0;
    
    autoHighMakesAvg = (float)self.autoHighHotAvgCalculated + (float)self.autoHighNotAvgCalculated;
    
    return autoHighMakesAvg;
}
-(float)autoHighAttemptsAvgCalculated{
    float autoHighAttemptsAvg = 0;
    
    autoHighAttemptsAvg = (float)self.autoHighHotAvgCalculated+(float)self.autoHighNotAvgCalculated+(float)self.autoHighMissAvgCalculated;
    
    return autoHighAttemptsAvg;
}
-(float)autoHighHotPercentageCalculated{
    float autoHighHotPercentage = 0;
    
    if (self.autoHighHotAvgCalculated+self.autoHighNotAvgCalculated > 0) {
        autoHighHotPercentage = ((float)self.autoHighHotAvgCalculated/((float)self.autoHighHotAvgCalculated+(float)self.autoHighNotAvgCalculated))*100;
    }
    
    return autoHighHotPercentage;
}
-(float)autoHighAccuracyPercentageCalculated{
    float autoHighAccuracyPercentage = 0;
    
    if (((float)self.autoHighHotAvgCalculated+(float)self.autoHighNotAvgCalculated+(float)self.autoHighMissAvgCalculated) > 0) {
        autoHighAccuracyPercentage = (((float)self.autoHighHotAvgCalculated+(float)self.autoHighNotAvgCalculated)/((float)self.autoHighHotAvgCalculated+(float)self.autoHighNotAvgCalculated+(float)self.autoHighMissAvgCalculated))*100;
    }
    
    return autoHighAccuracyPercentage;
}
-(float)autoLowHotAvgCalculated{
    float autoLowHotAvg = 0;
    for (Match *mtch in self.matches) {
        autoLowHotAvg += [mtch.autoLowHotScore floatValue];
    }
    
    if ([self.matches count] > 0) {
        autoLowHotAvg = (float)autoLowHotAvg/(float)[self.matches count];
    }
    
    return autoLowHotAvg;
}
-(float)autoLowMissAvgCalculated{
    float autoLowMissAvg = 0;
    for (Match *mtch in self.matches) {
        autoLowMissAvg += [mtch.autoLowMissScore floatValue];
    }
    
    if ([self.matches count] > 0) {
        autoLowMissAvg = (float)autoLowMissAvg/(float)[self.matches count];
    }
    
    return autoLowMissAvg;
}
-(float)autoLowNotAvgCalculated{
    float autoLowNotAvg = 0;
    for (Match *mtch in self.matches) {
        autoLowNotAvg += [mtch.autoLowMissScore floatValue];
    }
    
    if ([self.matches count] > 0) {
        autoLowNotAvg = (float)autoLowNotAvg/(float)[self.matches count];
    }
    
    return autoLowNotAvg;
}
-(float)autoLowMakesAvgCalculated{
    float autoLowMakesAvg = 0;
    
    autoLowMakesAvg = (float)self.autoLowHotAvgCalculated + (float)self.autoLowNotAvgCalculated;
    
    return autoLowMakesAvg;
}
-(float)autoLowAttemptsAvgCalculated{
    float autoLowAttemptsAvg = 0;
    
    autoLowAttemptsAvg = (float)self.autoLowHotAvgCalculated + (float)self.autoLowNotAvgCalculated + (float)self.autoLowMissAvgCalculated;
    
    return autoLowAttemptsAvg;
}
-(float)autoLowHotPercentageCalculated{
    float autoLowHotPercentage = 0;
    
    if (self.autoLowHotAvgCalculated+self.autoLowNotAvgCalculated > 0) {
        autoLowHotPercentage = ((float)self.autoLowHotAvgCalculated/((float)self.autoLowHotAvgCalculated+(float)self.autoLowNotAvgCalculated))*100;
    }
    
    return autoLowHotPercentage;
}
-(float)autoLowAccuracyPercentageCalculated{
    float autoLowAccuracyPercentage = 0;
    
    if ((float)self.autoLowHotAvgCalculated+(float)self.autoLowNotAvgCalculated+(float)self.autoLowMissAvgCalculated > 0) {
        autoLowAccuracyPercentage = (((float)self.autoLowHotAvgCalculated+(float)self.autoLowNotAvgCalculated)/((float)self.autoLowHotAvgCalculated+(float)self.autoLowNotAvgCalculated+(float)self.autoLowMissAvgCalculated))*100;
    }
    
    return autoLowAccuracyPercentage;
}
-(float)autoAccuracyPercentageCalculated{
    float autoAccuracyPercentage = 0;
    float totalHighShotsAttempted = 0;
    float totalLowShotsAttempted = 0;
    
    totalHighShotsAttempted = (float)self.autoHighHotAvgCalculated+(float)self.autoHighNotAvgCalculated+(float)self.autoHighMissAvgCalculated;
    totalLowShotsAttempted = (float)self.autoLowHotAvgCalculated+(float)self.autoLowNotAvgCalculated+(float)self.autoLowMissAvgCalculated;
    
    if (totalHighShotsAttempted > 0 && totalLowShotsAttempted > 0) {
        autoAccuracyPercentage = (((float)self.autoHighHotAvgCalculated+(float)self.autoHighNotAvgCalculated+(float)self.autoLowHotAvgCalculated+(float)self.autoLowNotAvgCalculated)/((float)totalHighShotsAttempted+(float)totalLowShotsAttempted))*100;
    }
    else if (totalHighShotsAttempted == 0 && totalLowShotsAttempted > 0){
        autoAccuracyPercentage = (float)self.autoLowAccuracyPercentageCalculated;
    }
    else if (totalLowShotsAttempted == 0 && totalHighShotsAttempted > 0){
        autoAccuracyPercentage = (float)self.autoHighAccuracyPercentageCalculated;
    }
    
    return autoAccuracyPercentage;
}
-(float)mobilityBonusPercentageCalculated{
    float mobilityBonusPercentage = 0;
    for (Match *mtch in self.matches) {
        mobilityBonusPercentage += [mtch.mobilityBonus floatValue];
    }
    
    if ([self.matches count] > 0) {
        mobilityBonusPercentage = ((float)mobilityBonusPercentage/(float)[self.matches count])*100;
    }
    
    return mobilityBonusPercentage;
}
-(float)autonomousAvgCalculated{
    float autonomousAvg = 0;
    for (Match *mtch in self.matches) {
        autonomousAvg += [mtch.autoHighHotScore floatValue]*20;
        autonomousAvg += [mtch.autoHighNotScore floatValue]*15;
        autonomousAvg += [mtch.autoLowHotScore floatValue]*11;
        autonomousAvg += [mtch.autoLowNotScore floatValue]*6;
        autonomousAvg += [mtch.mobilityBonus floatValue]*5;
    }
    
    if ([self.matches count] > 0) {
        autonomousAvg = (float)autonomousAvg/(float)[self.matches count];
    }
    
    return autonomousAvg;
}

-(float)teleopHighMakeAvgCalculated{
    float teleopHighMakeAvg = 0;
    for (Match *mtch in self.matches) {
        teleopHighMakeAvg += [mtch.teleopHighMake floatValue];
    }
    
    if ([self.matches count] > 0) {
        teleopHighMakeAvg = (float)teleopHighMakeAvg/(float)[self.matches count];
    }
    
    return teleopHighMakeAvg;
}
-(float)teleopHighMissAvgCalculated{
    float teleopHighMissAvg = 0;
    for (Match *mtch in self.matches) {
        teleopHighMissAvg += [mtch.teleopHighMiss floatValue];
    }
    
    if ([self.matches count] > 0) {
        teleopHighMissAvg = (float)teleopHighMissAvg/(float)[self.matches count];
    }
    
    return teleopHighMissAvg;
}
-(float)teleopHighAttemptsAvgCalculated{
    float teleopHighAttemptsAvg = 0;
    
    teleopHighAttemptsAvg = (float)self.teleopHighMakeAvgCalculated+(float)self.teleopHighMissAvgCalculated;
    
    return teleopHighAttemptsAvg;
}
-(float)teleopHighAccuracyPercentageCalculated{
    float teleopHighAccuracyPercentage = 0;
    
    if (self.teleopHighMakeAvgCalculated + self.teleopHighMissAvgCalculated > 0) {
        teleopHighAccuracyPercentage = ((float)self.teleopHighMakeAvgCalculated/((float)self.teleopHighMakeAvgCalculated+(float)self.teleopHighMissAvgCalculated))*100;
    }
    
    return teleopHighAccuracyPercentage;
}
-(float)teleopLowMakeAvgCalculated{
    float teleopLowMakeAvg = 0;
    for (Match *mtch in self.matches) {
        teleopLowMakeAvg += [mtch.teleopLowMake floatValue];
    }
    
    if ([self.matches count] > 0) {
        teleopLowMakeAvg = (float)teleopLowMakeAvg/(float)[self.matches count];
    }
    
    return teleopLowMakeAvg;
}
-(float)teleopLowMissAvgCalculated{
    float teleopLowMissAvg = 0;
    for (Match *mtch in self.matches) {
        teleopLowMissAvg += [mtch.teleopLowMiss floatValue];
    }
    
    if ([self.matches count] > 0) {
        teleopLowMissAvg = (float)teleopLowMissAvg/(float)[self.matches count];
    }
    
    return teleopLowMissAvg;
}
-(float)teleopLowAttemptsAvgCalculated{
    float teleopLowAttemptsAvg = 0;
    
    teleopLowAttemptsAvg = (float)self.teleopLowMakeAvgCalculated + (float)self.teleopLowMissAvgCalculated;
    
    return teleopLowAttemptsAvg;
}
-(float)teleopLowAccuracyPercentageCalculated{
    float teleopLowAccuracyPercentage = 0;
    
    if (self.teleopLowMakeAvgCalculated + self.teleopLowMissAvgCalculated > 0) {
        teleopLowAccuracyPercentage = ((float)self.teleopLowMakeAvgCalculated/((float)self.teleopLowMakeAvgCalculated+(float)self.teleopLowMissAvgCalculated))*100;
    }
    
    return teleopLowAccuracyPercentage;
}
-(float)teleopAccuracyPercentageCalculated{
    float teleopAccuracyPercentage = 0;
    float teleopHighShotsAttempted = 0;
    float teleopLowShotsAttempted = 0;
    
    teleopHighShotsAttempted = (float)self.teleopHighMakeAvgCalculated+(float)self.teleopHighMissAvgCalculated;
    teleopLowShotsAttempted = (float)self.teleopLowMakeAvgCalculated+(float)self.teleopLowMissAvgCalculated;
    if (teleopHighShotsAttempted > 0 && teleopLowShotsAttempted > 0) {
        teleopAccuracyPercentage = (((float)self.teleopHighMakeAvgCalculated+(float)self.teleopLowMakeAvgCalculated)/((float)teleopHighShotsAttempted+(float)teleopLowShotsAttempted))*100;
    }
    else if (teleopHighShotsAttempted == 0 && teleopLowShotsAttempted > 0){
        teleopAccuracyPercentage = (float)self.teleopLowAccuracyPercentageCalculated;
    }
    else if (teleopLowShotsAttempted == 0 && teleopHighShotsAttempted > 0){
        teleopAccuracyPercentage = (float)self.teleopHighAccuracyPercentageCalculated;
    }
    
    
    return teleopAccuracyPercentage;
}
-(float)teleopCatchAvgCalculated{
    float teleopCatchAvg = 0;
    for (Match *mtch in self.matches) {
        teleopCatchAvg += [mtch.teleopCatch floatValue];
    }
    
    if ([self.matches count] > 0) {
        teleopCatchAvg = (float)teleopCatchAvg/(float)[self.matches count];
    }
    
    return teleopCatchAvg;
}
-(float)teleopOverAvgCalculated{
    float teleopOverAvg = 0;
    for (Match *mtch in self.matches) {
        teleopOverAvg += [mtch.teleopOver floatValue];
    }
    
    if ([self.matches count] > 0) {
        teleopOverAvg = (float)teleopOverAvg/(float)[self.matches count];
    }
    
    return teleopOverAvg;
}
-(float)teleopPassedAvgCalculated{
    float teleopPassedAvg = 0;
    for (Match *mtch in self.matches) {
        teleopPassedAvg += [mtch.teleopPassed floatValue];
    }
    
    if ([self.matches count] > 0) {
        teleopPassedAvg = (float)teleopPassedAvg/(float)[self.matches count];
    }
    
    return teleopPassedAvg;
}
-(float)teleopReceivedAvgCalculated{
    float teleopReceivedAvg = 0;
    for (Match *mtch in self.matches) {
        teleopReceivedAvg += [mtch.teleopReceived floatValue];
    }
    
    if ([self.matches count] > 0) {
        teleopReceivedAvg = (float)teleopReceivedAvg/(float)[self.matches count];
    }
    
    return teleopReceivedAvg;
}
-(float)teleopPassReceiveRatioCalculated{
    float teleopPassReceiveRatio = 0;
    
    if (self.teleopReceivedAvg > 0) {
        teleopPassReceiveRatio = (float)self.teleopPassedAvgCalculated/(float)self.teleopReceivedAvgCalculated;
    }
    
    return teleopPassReceiveRatio;
}
-(float)teleopAvgCalculated{
    float teleopAvg = 0;
    for (Match *mtch in self.matches) {
        teleopAvg += [mtch.teleopHighMake floatValue]*10;
        teleopAvg += [mtch.teleopLowMake floatValue];
        teleopAvg += [mtch.teleopCatch floatValue]*10;
        teleopAvg += [mtch.teleopOver floatValue]*10;
    }
    
    if ([self.matches count] > 0) {
        teleopAvg = (float)teleopAvg/(float)[self.matches count];
    }
    
    return teleopAvg;
}

-(float)smallPenaltyAvgCalculated{
    float smallPenaltyAvg = 0;
    for (Match *mtch in self.matches) {
        smallPenaltyAvg += [mtch.penaltySmall floatValue];
    }
    
    if ([self.matches count] > 0) {
        smallPenaltyAvg = (float)smallPenaltyAvg/(float)[self.matches count];
    }
    
    return smallPenaltyAvg;
}
-(float)largePenaltyAvgCalculated{
    float largePenaltyAvg = 0;
    for (Match *mtch in self.matches) {
        largePenaltyAvg += [mtch.penaltyLarge floatValue];
    }
    
    if ([self.matches count] > 0) {
        largePenaltyAvg = (float)largePenaltyAvg/(float)[self.matches count];
    }
    
    return largePenaltyAvg;
}
-(float)penaltyTotalAvgCalculated{
    float penaltyTotalAvg = 0;
    
    penaltyTotalAvg = (float)self.smallPenaltyAvgCalculated+(float)self.largePenaltyAvgCalculated;
    
    return penaltyTotalAvg;
}

-(float)offensiveZonePercentageCalculated{
    float offensiveZonePercentage = 0;
    for (Match *mtch in self.matches) {
        NSString *zoneString = [[mtch.notes componentsSeparatedByString:@":"] firstObject];
        if ([[mtch.red1Pos substringToIndex:1] isEqualToString:@"R"]) {
            if ([zoneString rangeOfString:@"Blue"].location != NSNotFound) {
                offensiveZonePercentage ++;
            }
        }
        else{
            if ([zoneString rangeOfString:@"Red"].location != NSNotFound) {
                offensiveZonePercentage ++;
            }
        }
    }
    
    if ([self.matches count] > 0) {
        offensiveZonePercentage = ((float)offensiveZonePercentage/(float)[self.matches count])*100;
    }
    
    return offensiveZonePercentage;
}
-(float)neutralZonePercentageCalculated{
    float neutralZonePercentage = 0;
    for (Match *mtch in self.matches) {
        NSString *zoneString = [[mtch.notes componentsSeparatedByString:@":"] firstObject];
        if ([zoneString rangeOfString:@"White"].location != NSNotFound) {
            neutralZonePercentage ++;
        }
    }
    
    if ([self.matches count] > 0) {
        neutralZonePercentage = ((float)neutralZonePercentage/(float)[self.matches count])*100;
    }
    
    return neutralZonePercentage;
}
-(float)defensiveZonePercentageCalculated{
    float defensiveZonePercentage = 0;
    for (Match *mtch in self.matches) {
        NSString *zoneString = [[mtch.notes componentsSeparatedByString:@":"] firstObject];
        if ([[mtch.red1Pos substringToIndex:1] isEqualToString:@"R"]) {
            if ([zoneString rangeOfString:@"Red"].location != NSNotFound) {
                defensiveZonePercentage ++;
            }
        }
        else{
            if ([zoneString rangeOfString:@"Blue"].location != NSNotFound) {
                defensiveZonePercentage ++;
            }
        }
    }
    
    if ([self.matches count] > 0) {
        defensiveZonePercentage = ((float)defensiveZonePercentage/(float)[self.matches count])*100;
    }
    
    return defensiveZonePercentage;
}

-(void)updateTeamAveragesForTeam:(Team *)team{
    team.autoHighHotAvg = [NSNumber numberWithFloat:self.autoHighHotAvgCalculated];
    team.autoHighMissAvg = [NSNumber numberWithFloat:self.autoHighMissAvgCalculated];
    team.autoHighNotAvg = [NSNumber numberWithFloat:self.autoHighNotAvgCalculated];
    team.autoHighMakesAvg = [NSNumber numberWithFloat:self.autoHighMakesAvgCalculated];
    team.autoHighAttemptsAvg = [NSNumber numberWithFloat:self.autoHighAttemptsAvgCalculated];
    team.autoHighHotPercentage = [NSNumber numberWithFloat:self.autoHighHotPercentageCalculated];
    team.autoHighAccuracyPercentage = [NSNumber numberWithFloat:self.autoHighAccuracyPercentageCalculated];
    team.autoLowHotAvg = [NSNumber numberWithFloat:self.autoLowHotAvgCalculated];
    team.autoLowMissAvg = [NSNumber numberWithFloat:self.autoLowMissAvgCalculated];
    team.autoLowNotAvg = [NSNumber numberWithFloat:self.autoLowNotAvgCalculated];
    team.autoLowMakesAvg = [NSNumber numberWithFloat:self.autoLowMakesAvgCalculated];
    team.autoLowAttemptsAvg = [NSNumber numberWithFloat:self.autoLowAttemptsAvgCalculated];
    team.autoLowHotPercentage = [NSNumber numberWithFloat:self.autoLowHotPercentageCalculated];
    team.autoLowAccuracyPercentage = [NSNumber numberWithFloat:self.autoLowAccuracyPercentageCalculated];
    team.autoAccuracyPercentage = [NSNumber numberWithFloat:self.autoAccuracyPercentageCalculated];
    team.mobilityBonusPercentage = [NSNumber numberWithFloat:self.mobilityBonusPercentageCalculated];
    team.autonomousAvg = [NSNumber numberWithFloat:self.autonomousAvgCalculated];
    
    team.teleopHighMakeAvg = [NSNumber numberWithFloat:self.teleopHighMakeAvgCalculated];
    team.teleopHighMissAvg = [NSNumber numberWithFloat:self.teleopHighMissAvgCalculated];
    team.teleopHighAttemptsAvg = [NSNumber numberWithFloat:self.teleopHighAttemptsAvgCalculated];
    team.teleopHighAccuracyPercentage = [NSNumber numberWithFloat:self.teleopHighAccuracyPercentageCalculated];
    team.teleopLowMakeAvg = [NSNumber numberWithFloat:self.teleopLowMakeAvgCalculated];
    team.teleopLowMissAvg = [NSNumber numberWithFloat:self.teleopLowMissAvgCalculated];
    team.teleopLowAttemptsAvg = [NSNumber numberWithFloat:self.teleopLowAttemptsAvgCalculated];
    team.teleopLowAccuracyPercentage = [NSNumber numberWithFloat:self.teleopLowAccuracyPercentageCalculated];
    team.teleopAccuracyPercentage = [NSNumber numberWithFloat:self.teleopAccuracyPercentageCalculated];
    team.teleopCatchAvg = [NSNumber numberWithFloat:self.teleopCatchAvgCalculated];
    team.teleopOverAvg = [NSNumber numberWithFloat:self.teleopOverAvgCalculated];
    team.teleopPassedAvg = [NSNumber numberWithFloat:self.teleopPassedAvgCalculated];
    team.teleopReceivedAvg = [NSNumber numberWithFloat:self.teleopReceivedAvgCalculated];
    team.teleopPassReceiveRatio = [NSNumber numberWithFloat:self.teleopPassReceiveRatioCalculated];
    team.teleopAvg = [NSNumber numberWithFloat:self.teleopAvgCalculated];
    
    team.smallPenaltyAvg = [NSNumber numberWithFloat:self.smallPenaltyAvgCalculated];
    team.largePenaltyAvg = [NSNumber numberWithFloat:self.largePenaltyAvgCalculated];
    team.penaltyTotalAvg = [NSNumber numberWithFloat:self.penaltyTotalAvgCalculated];
    
    team.offensiveZonePercentage = [NSNumber numberWithFloat:self.offensiveZonePercentageCalculated];
    team.neutralZonePercentage = [NSNumber numberWithFloat:self.neutralZonePercentageCalculated];
    team.defensiveZonePercentage = [NSNumber numberWithFloat:self.defensiveZonePercentageCalculated];
}


@end





























