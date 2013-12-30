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
        match.teleHighScore = [dict objectForKey:@"teleHighScore"];
        match.autoHighScore = [dict objectForKey:@"autoHighScore"];
        match.teleMidScore = [dict objectForKey:@"teleMidScore"];
        match.autoMidScore = [dict objectForKey:@"autoMidScore"];
        match.teleLowScore = [dict objectForKey:@"teleLowScore"];
        match.autoLowScore = [dict objectForKey:@"autoLowScore"];
        //match.endGame = [dict objectForKey:@"endGame"];
        match.penaltyLarge = [dict objectForKey:@"penaltyLarge"];
        match.penaltySmall = [dict objectForKey:@"penaltySmall"];
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
