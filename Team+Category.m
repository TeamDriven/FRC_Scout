//
//  Team+Category.m
//  FIRST Scouting App
//
//  Created by Louie Bertoncin on 12/29/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import "Team+Category.h"
#import "Regional.h"

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
    }
    
    return team;
}

@end
