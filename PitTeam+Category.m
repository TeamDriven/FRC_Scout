//
//  PitTeam+Category.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 1/22/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "PitTeam+Category.h"

@implementation PitTeam (Category)

+(PitTeam *)createPitTeamWithDictionary:(NSDictionary *)pitDict inManagedObjectContext:(NSManagedObjectContext *)context{
    PitTeam *pitTm = nil;
    
    NSFetchRequest *pitTeamRequest = [NSFetchRequest fetchRequestWithEntityName:@"PitTeam"];
    NSPredicate *pitTeamPredicate = [NSPredicate predicateWithFormat:@"(teamNumber contains %@)", [pitDict objectForKey:@"teamNumber"]];
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
        
        
        NSLog(@"Created a new Pit Team with team number %@ and team name %@", pitTm.teamNumber, pitTm.teamName);
        
    }
    
    
    
    return pitTm;
}

@end
