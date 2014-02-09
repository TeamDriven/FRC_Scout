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

@end
