//
//  Team+Category.m
//  FIRST Scouting App
//
//  Created by Louie Bertoncin on 12/29/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import "Team+Category.h"
#import "Regional.h"
#import "MasterTeam.h"
#import "Match.h"

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

-(float)autoHighHotAvg{
    float autoHighHotAvg = 0;
    for (Match *mtch in self.matches) {
        autoHighHotAvg += [mtch.autoHighHotScore floatValue];
    }
    
    if ([self.matches count] > 0) {
        autoHighHotAvg = (float)autoHighHotAvg/(float)[self.matches count];
    }
    
    return autoHighHotAvg;
}
-(float)autoHighMissAvg{
    float autoHighMissAvg = 0;
    for (Match *mtch in self.matches) {
        autoHighMissAvg += [mtch.autoHighMissScore floatValue];
    }
    
    if ([self.matches count] > 0) {
        autoHighMissAvg = (float)autoHighMissAvg/(float)[self.matches count];
    }
    
    return autoHighMissAvg;
}
-(float)autoHighNotAvg{
    float autoHighNotAvg = 0;
    for (Match *mtch in self.matches) {
        autoHighNotAvg += [mtch.autoHighNotScore floatValue];
    }
    
    if ([self.matches count] > 0) {
        autoHighNotAvg = (float)autoHighNotAvg/(float)[self.matches count];
    }
    
    return autoHighNotAvg;
}
-(float)autoHighAvg{
    float autoHighAvg = 0;
    
    autoHighAvg = (float)self.autoHighHotAvg + (float)self.autoHighNotAvg;
    
    return autoHighAvg;
}
-(float)autoHighHotPercentage{
    float autoHighHotPercentage = 0;
    
    if (self.autoHighHotAvg+self.autoHighNotAvg > 0) {
        autoHighHotPercentage = ((float)self.autoHighHotAvg/((float)self.autoHighHotAvg+(float)self.autoHighNotAvg))*100;
    }
    
    return autoHighHotPercentage;
}
-(float)autoHighAccuracyPercentage{
    float autoHighAccuracyPercentage = 0;
    
    if (((float)self.autoHighHotAvg+(float)self.autoHighNotAvg+(float)self.autoHighMissAvg) > 0) {
        autoHighAccuracyPercentage = (((float)self.autoHighHotAvg+(float)self.autoHighNotAvg)/((float)self.autoHighHotAvg+(float)self.autoHighNotAvg+(float)self.autoHighMissAvg))*100;
    }
    
    return autoHighAccuracyPercentage;
}
-(float)autoLowHotAvg{
    float autoLowHotAvg = 0;
    for (Match *mtch in self.matches) {
        autoLowHotAvg += [mtch.autoLowHotScore floatValue];
    }
    
    if ([self.matches count] > 0) {
        autoLowHotAvg = (float)autoLowHotAvg/(float)[self.matches count];
    }
    
    return autoLowHotAvg;
}
-(float)autoLowMissAvg{
    float autoLowMissAvg = 0;
    for (Match *mtch in self.matches) {
        autoLowMissAvg += [mtch.autoLowMissScore floatValue];
    }
    
    if ([self.matches count] > 0) {
        autoLowMissAvg = (float)autoLowMissAvg/(float)[self.matches count];
    }
    
    return autoLowMissAvg;
}
-(float)autoLowNotAvg{
    float autoLowNotAvg = 0;
    for (Match *mtch in self.matches) {
        autoLowNotAvg += [mtch.autoLowMissScore floatValue];
    }
    
    if ([self.matches count] > 0) {
        autoLowNotAvg = (float)autoLowNotAvg/(float)[self.matches count];
    }
    
    return autoLowNotAvg;
}
-(float)autoLowAvg{
    float autoLowAvg = 0;
    
    autoLowAvg = (float)self.autoLowHotAvg + (float)self.autoLowNotAvg;
    
    return autoLowAvg;
}
-(float)autoLowHotPercentage{
    float autoLowHotPercentage = 0;
    
    if (self.autoLowHotAvg+self.autoLowNotAvg > 0) {
        autoLowHotPercentage = ((float)self.autoLowHotAvg/((float)self.autoLowHotAvg+(float)self.autoLowNotAvg))*100;
    }
    
    return autoLowHotPercentage;
}
-(float)autoLowAccuracyPercentage{
    float autoLowAccuracyPercentage = 0;
    
    if ((float)self.autoLowHotAvg+(float)self.autoLowNotAvg+(float)self.autoLowMissAvg > 0) {
        autoLowAccuracyPercentage = (((float)self.autoLowHotAvg+(float)self.autoLowNotAvg)/((float)self.autoLowHotAvg+(float)self.autoLowNotAvg+(float)self.autoLowMissAvg))*100;
    }
    
    return autoLowAccuracyPercentage;
}
-(float)autoAccuracyPercentage{
    float autoAccuracyPercentage = 0;
    float totalHighShotsAttempted = 0;
    float totalLowShotsAttempted = 0;
    
    totalHighShotsAttempted = (float)self.autoHighHotAvg+(float)self.autoHighNotAvg+(float)self.autoHighMissAvg;
    totalLowShotsAttempted = (float)self.autoLowHotAvg+(float)self.autoLowNotAvg+(float)self.autoLowMissAvg;
    
    if (totalHighShotsAttempted > 0 && totalLowShotsAttempted > 0) {
        autoAccuracyPercentage = (((float)self.autoHighHotAvg+(float)self.autoHighNotAvg+(float)self.autoLowHotAvg+(float)self.autoLowNotAvg)/((float)totalHighShotsAttempted+(float)totalLowShotsAttempted))*100;
    }
    else if (totalHighShotsAttempted == 0 && totalLowShotsAttempted > 0){
        autoAccuracyPercentage = (float)self.autoLowAccuracyPercentage;
    }
    else if (totalLowShotsAttempted == 0 && totalHighShotsAttempted > 0){
        autoAccuracyPercentage = (float)self.autoHighAccuracyPercentage;
    }
    
    return autoAccuracyPercentage;
}
-(float)mobilityBonusPercentage{
    float mobilityBonusPercentage = 0;
    for (Match *mtch in self.matches) {
        mobilityBonusPercentage += [mtch.mobilityBonus floatValue];
    }
    
    if ([self.matches count] > 0) {
        mobilityBonusPercentage = ((float)mobilityBonusPercentage/(float)[self.matches count])*100;
    }
    
    return mobilityBonusPercentage;
}
-(float)autonomousAvg{
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

-(float)teleopHighMakeAvg{
    float teleopHighMakeAvg = 0;
    for (Match *mtch in self.matches) {
        teleopHighMakeAvg += [mtch.teleopHighMake floatValue];
    }
    
    if ([self.matches count] > 0) {
        teleopHighMakeAvg = (float)teleopHighMakeAvg/(float)[self.matches count];
    }
    
    return teleopHighMakeAvg;
}
-(float)teleopHighMissAvg{
    float teleopHighMissAvg = 0;
    for (Match *mtch in self.matches) {
        teleopHighMissAvg += [mtch.teleopHighMiss floatValue];
    }
    
    if ([self.matches count] > 0) {
        teleopHighMissAvg = (float)teleopHighMissAvg/(float)[self.matches count];
    }
    
    return teleopHighMissAvg;
}
-(float)teleopHighAccuracyPercentage{
    float teleopHighAccuracyPercentage = 0;
    
    if (self.teleopHighMakeAvg + self.teleopHighMissAvg > 0) {
        teleopHighAccuracyPercentage = ((float)self.teleopHighMakeAvg/((float)self.teleopHighMakeAvg+(float)self.teleopHighMissAvg))*100;
    }
    
    return teleopHighAccuracyPercentage;
}
-(float)teleopLowMakeAvg{
    float teleopLowMakeAvg = 0;
    for (Match *mtch in self.matches) {
        teleopLowMakeAvg += [mtch.teleopLowMake floatValue];
    }
    
    if ([self.matches count] > 0) {
        teleopLowMakeAvg = (float)teleopLowMakeAvg/(float)[self.matches count];
    }
    
    return teleopLowMakeAvg;
}
-(float)teleopLowMissAvg{
    float teleopLowMissAvg = 0;
    for (Match *mtch in self.matches) {
        teleopLowMissAvg += [mtch.teleopLowMiss floatValue];
    }
    
    if ([self.matches count] > 0) {
        teleopLowMissAvg = (float)teleopLowMissAvg/(float)[self.matches count];
    }
    
    return teleopLowMissAvg;
}
-(float)teleopLowAccuracyPercentage{
    float teleopLowAccuracyPercentage = 0;
    
    if (self.teleopLowMakeAvg + self.teleopLowMissAvg > 0) {
        teleopLowAccuracyPercentage = ((float)self.teleopLowMakeAvg/((float)self.teleopLowMakeAvg+(float)self.teleopLowMissAvg))*100;
    }
    
    return teleopLowAccuracyPercentage;
}
-(float)teleopAccuracyPercentage{
    float teleopAccuracyPercentage = 0;
    float teleopHighShotsAttempted = 0;
    float teleopLowShotsAttempted = 0;
    
    teleopHighShotsAttempted = (float)self.teleopHighMakeAvg+(float)self.teleopHighMissAvg;
    teleopLowShotsAttempted = (float)self.teleopLowMakeAvg+(float)self.teleopLowMissAvg;
    if (teleopHighShotsAttempted > 0 && teleopLowShotsAttempted > 0) {
        teleopAccuracyPercentage = (((float)self.teleopHighMakeAvg+(float)self.teleopLowMakeAvg)/((float)teleopHighShotsAttempted+(float)teleopLowShotsAttempted))*100;
    }
    else if (teleopHighShotsAttempted == 0 && teleopLowShotsAttempted > 0){
        teleopAccuracyPercentage = (float)self.teleopLowAccuracyPercentage;
    }
    else if (teleopLowShotsAttempted == 0 && teleopHighShotsAttempted > 0){
        teleopAccuracyPercentage = (float)self.teleopHighAccuracyPercentage;
    }
    
    
    return teleopAccuracyPercentage;
}
-(float)teleopCatchAvg{
    float teleopCatchAvg = 0;
    for (Match *mtch in self.matches) {
        teleopCatchAvg += [mtch.teleopCatch floatValue];
    }
    
    if ([self.matches count] > 0) {
        teleopCatchAvg = (float)teleopCatchAvg/(float)[self.matches count];
    }
    
    return teleopCatchAvg;
}
-(float)teleopOverAvg{
    float teleopOverAvg = 0;
    for (Match *mtch in self.matches) {
        teleopOverAvg += [mtch.teleopOver floatValue];
    }
    
    if ([self.matches count] > 0) {
        teleopOverAvg = (float)teleopOverAvg/(float)[self.matches count];
    }
    
    return teleopOverAvg;
}
-(float)teleopPassedAvg{
    float teleopPassedAvg = 0;
    for (Match *mtch in self.matches) {
        teleopPassedAvg += [mtch.teleopPassed floatValue];
    }
    
    if ([self.matches count] > 0) {
        teleopPassedAvg = (float)teleopPassedAvg/(float)[self.matches count];
    }
    
    return teleopPassedAvg;
}
-(float)teleopReceivedAvg{
    float teleopReceivedAvg = 0;
    for (Match *mtch in self.matches) {
        teleopReceivedAvg += [mtch.teleopReceived floatValue];
    }
    
    if ([self.matches count] > 0) {
        teleopReceivedAvg = (float)teleopReceivedAvg/(float)[self.matches count];
    }
    
    return teleopReceivedAvg;
}
-(float)teleopPassReceiveRatio{
    float teleopPassReceiveRatio = 0;
    
    if (self.teleopReceivedAvg > 0) {
        teleopPassReceiveRatio = (float)self.teleopPassedAvg/(float)self.teleopReceivedAvg;
    }
    
    return teleopPassReceiveRatio;
}
-(float)teleopAvg{
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

-(float)smallPenaltyAvg{
    float smallPenaltyAvg = 0;
    for (Match *mtch in self.matches) {
        smallPenaltyAvg += [mtch.penaltySmall floatValue];
    }
    
    if ([self.matches count] > 0) {
        smallPenaltyAvg = (float)smallPenaltyAvg/(float)[self.matches count];
    }
    
    return smallPenaltyAvg;
}
-(float)largePenaltyAvg{
    float largePenaltyAvg = 0;
    for (Match *mtch in self.matches) {
        largePenaltyAvg += [mtch.penaltyLarge floatValue];
    }
    
    if ([self.matches count] > 0) {
        largePenaltyAvg = (float)largePenaltyAvg/(float)[self.matches count];
    }
    
    return largePenaltyAvg;
}

-(float)offensiveZonePercentage{
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
-(float)neutralZonePercentage{
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
-(float)defensiveZonePercentage{
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


@end

//NSString *zoneString = [[mtch.notes componentsSeparatedByString:@":"] firstObject];
//if ([zoneString rangeOfString:@"White"].location != NSNotFound) {neutralCount ++;}
//
//if ([[mtch.red1Pos substringToIndex:1] isEqualToString:@"R"]) {
//    if ([zoneString rangeOfString:@"Red"].location != NSNotFound) {
//        defensiveCount++;
//    }
//    if ([zoneString rangeOfString:@"Blue"].location != NSNotFound) {
//        offensiveCount++;
//    }
//}
//else{
//    if ([zoneString rangeOfString:@"Blue"].location != NSNotFound) {
//        defensiveCount++;
//    }
//    if ([zoneString rangeOfString:@"Red"].location != NSNotFound) {
//        offensiveCount++;
//    }
//}





























