//
//  Regional+Category.h
//  FIRST Scouting App
//
//  Created by Louie Bertoncin on 12/29/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import "Regional.h"

@interface Regional (Category)

+(Regional *)createRegionalWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;

@end
