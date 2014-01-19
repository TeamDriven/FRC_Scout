//
//  Match+Category.m
//  FIRST Scouting App
//
//  Created by Louie Bertoncin on 12/29/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import "Match+Category.h"
#import "Team.h"
#import "Scoring.h"

@implementation Match (Category)

+(Match *)createMatchWithDictionary:(NSDictionary *)dict inTeam:(Team *)tm withManagedObjectContext:(NSManagedObjectContext *)context{
    
    Match *match = nil;
    
    NSFetchRequest *matchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Match"];
    NSPredicate *matchPredicate = [NSPredicate predicateWithFormat:@"(matchNum contains %@) AND (teamNum.name contains %@)", [dict objectForKey:@"matchNum"], tm.name];
    matchRequest.predicate = matchPredicate;
    
    NSError *matchError;
    NSArray *matches = [context executeFetchRequest:matchRequest error:&matchError];
    
    if (!matches || matchError) {
        NSLog(@"Match Error: %@", matchError);
    }
    else if ([matches count] == 1){
        NSLog(@"Found one match instance");
        match = [matches firstObject];
    }
    else if ([matches count] > 1){
        for (Match *m in matches) {
            NSLog(@"Match: %@", m.matchNum);
        }
    }
    else{
        match = [NSEntityDescription insertNewObjectForEntityForName:@"Match" inManagedObjectContext:context];
        match.autoHighHotScore = [dict objectForKey:@"autoHighHotScore"];
        match.autoHighNotScore = [dict objectForKey:@"autoHighNotScore"];
        match.autoHighMissScore = [dict objectForKey:@"autoHighMissScore"];
        match.autoLowHotScore = [dict objectForKey:@"autoLowHotScore"];
        match.autoLowNotScore = [dict objectForKey:@"autoLowNotScore"];
        match.autoLowMissScore = [dict objectForKey:@"autoLowMissScore"];
        match.mobilityBonus = [dict objectForKey:@"mobilityBonus"];
        match.teleopHighMake = [dict objectForKey:@"teleopHighMake"];
        match.teleopHighMiss = [dict objectForKey:@"teleopHighMiss"];
        match.teleopLowMake = [dict objectForKey:@"teleopLowMake"];
        match.teleopLowMiss = [dict objectForKey:@"teleopLowMiss"];
        match.teleopOver = [dict objectForKey:@"teleopOver"];
        match.teleopCatch = [dict objectForKey:@"teleopCatch"];
        match.teleopPassed = [dict objectForKey:@"teleopPassed"];
        match.teleopReceived = [dict objectForKey:@"teleopReceived"];
        match.penaltyLarge = [dict objectForKey:@"penaltyLarge"];
        match.penaltySmall = [dict objectForKey:@"penaltySmall"];
        match.notes = [dict objectForKey:@"notes"];
        match.red1Pos = [dict objectForKey:@"red1Pos"];
        match.recordingTeam = [dict objectForKey:@"recordingTeam"];
        match.scoutInitials = [dict objectForKey:@"scoutInitials"];
        match.matchType = [dict objectForKey:@"matchType"];
        match.matchNum = [dict objectForKey:@"matchNum"];
        match.uniqeID = [dict objectForKey:@"uniqueID"];
        
        [tm addMatchesObject:match];
        
        
        NSLog(@"Created a new match named: %@", match.matchNum);
        
    }
    
    
    return match;
}

@end
