//
//  Match+Category.h
//  FIRST Scouting App
//
//  Created by Louie Bertoncin on 12/29/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import "Match.h"

@interface Match (Category)

+(Match *)createMatchWithDictionary:(NSDictionary *)dict inTeam:(Team *)tm withManagedObjectContext:(NSManagedObjectContext *)context;

@end
