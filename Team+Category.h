//
//  Team+Category.h
//  FIRST Scouting App
//
//  Created by Louie Bertoncin on 12/29/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import "Team.h"

@interface Team (Category)

+(Team *)createTeamWithName:(NSString *)name inRegional:(Regional *)rgnl withManagedObjectContext:(NSManagedObjectContext *)context;

@end
