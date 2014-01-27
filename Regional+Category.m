//
//  Regional+Category.m
//  FIRST Scouting App
//
//  Created by Louie Bertoncin on 12/29/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import "Regional+Category.h"

@implementation Regional (Category)

+(Regional *)createRegionalWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context{
    
    Regional *regional = nil;
    
    NSFetchRequest *regionalRequest = [NSFetchRequest fetchRequestWithEntityName:@"Regional"];
    NSPredicate *regionalPredicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    regionalRequest.predicate = regionalPredicate;
    
    NSError *regionalError;
    NSArray *regionals = [context executeFetchRequest:regionalRequest error:&regionalError];
    
    //Received some sort of error
    if (!regionals || regionalError) {
        NSLog(@"Regional Error: %@", regionalError);
    }
    //Found just one instance
    else if ([regionals count] == 1){
        NSLog(@"Found one regional match");
        regional = [regionals firstObject];
    }
    //Found multiple instances
    else if ([regionals count] > 1){
        for (Regional *r in regionals) {
            NSLog(@"Regional: %@", r.name);
        }
    }
    //Found no instances and creates a new one
    else{
        regional = [NSEntityDescription insertNewObjectForEntityForName:@"Regional" inManagedObjectContext:context];
        regional.name = name;
        NSLog(@"Created a new regional named: %@", regional.name);
    }
    
    return regional;
}

@end
