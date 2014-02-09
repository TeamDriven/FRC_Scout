//
//  PitTeam+Category.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 1/22/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "PitTeam+Category.h"
#import "MasterTeam.h"

@implementation PitTeam (Category)

+(PitTeam *)createPitTeamWithDictionary:(NSDictionary *)pitDict inManagedObjectContext:(NSManagedObjectContext *)context{
    PitTeam *pitTm = nil;
    
    NSFetchRequest *pitTeamRequest = [NSFetchRequest fetchRequestWithEntityName:@"PitTeam"];
    NSPredicate *pitTeamPredicate = [NSPredicate predicateWithFormat:@"(teamNumber = %@)", [pitDict objectForKey:@"teamNumber"]];
    pitTeamRequest.predicate = pitTeamPredicate;
    
    NSError *pitTeamError;
    NSArray *pitTeams = [context executeFetchRequest:pitTeamRequest error:&pitTeamError];
    
    if (!pitTeams || pitTeamError) {
        NSLog(@"Pit Team Error: %@", pitTeamError);
    }
    else if ([pitTeams count] == 1){
        NSLog(@"Found one Pit Team instance");
        pitTm = [pitTeams firstObject];
    }
    else if ([pitTeams count] > 1){
        for (PitTeam *pt in pitTeams) {
            NSLog(@"Pit Team: %@", pt.teamNumber);
        }
    }
    else{
        pitTm = [NSEntityDescription insertNewObjectForEntityForName:@"PitTeam" inManagedObjectContext:context];
        pitTm.driveTrain = [pitDict objectForKey:@"driveTrain"];
        pitTm.shooter = [pitDict objectForKey:@"shooter"];
        pitTm.preferredGoal = [pitDict objectForKey:@"preferredGoal"];
        pitTm.goalieArm = [pitDict objectForKey:@"goalieArm"];
        pitTm.floorCollector = [pitDict objectForKey:@"floorCollector"];
        pitTm.autonomous = [pitDict objectForKey:@"autonomous"];
        pitTm.autoStartingPosition = [pitDict objectForKey:@"autoStartingPosition"];
        pitTm.hotGoalTracking = [pitDict objectForKey:@"hotGoalTracking"];
        pitTm.catchingMechanism = [pitDict objectForKey:@"catchingMechanism"];
        pitTm.bumperQuality = [pitDict objectForKey:@"bumperQuality"];
        pitTm.image = [pitDict objectForKey:@"image"];
        pitTm.teamNumber = [pitDict objectForKey:@"teamNumber"];
        pitTm.teamName = [pitDict objectForKey:@"teamName"];
        pitTm.notes = [pitDict objectForKey:@"notes"];
        pitTm.uniqueID = [pitDict objectForKey:@"uniqueID"];
        
        
        NSLog(@"Created a new Pit Team with team number %@ and team name %@", pitTm.teamNumber, pitTm.teamName);
        
        NSFetchRequest *masterRequest = [NSFetchRequest fetchRequestWithEntityName:@"MasterTeam"];
        masterRequest.predicate = [NSPredicate predicateWithFormat:@"name = %@", pitTm.teamNumber];
        NSError *masterError;
        NSArray *masterArray = [context executeFetchRequest:masterRequest error:&masterError];
        
        MasterTeam *mt = nil;
        
        if (!masterArray || masterError) {
            NSLog(@"Master Error: %@", masterError);
        }
        else if ([masterArray count] == 1){
            mt = [masterArray firstObject];
            mt.pitTeam = pitTm;
            NSLog(@"Added pit team to master: %@", pitTm.teamNumber);
        }
        else if ([masterArray count] > 1){
            for (MasterTeam *master in masterArray) {
                NSLog(@"Master Team: %@", master.name);
            }
        }
        else{
            mt = [NSEntityDescription insertNewObjectForEntityForName:@"MasterTeam" inManagedObjectContext:context];
            mt.name = pitTm.teamNumber;
            mt.pitTeam = pitTm;
            
            NSLog(@"Created a new master team named: %@", mt.name);
        }
        
    }
    
    
    
    return pitTm;
}

@end
