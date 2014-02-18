//
//  Globals.h
//  FIRST Scouting App
//
//  Created by Eris on 12/4/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Globals : NSObject

// Red 1, Red 2, etc
extern NSString *pos;

// Scout's three initials
extern NSString *initials;

// Team number of the scout's team
extern NSString *scoutTeamNum;

// Regional that the scouter is in at the time
extern NSString *currentRegional;

// All regionals in the 2014 season in chronological order
extern NSArray *regionalNames;
extern NSArray *week1Regionals;
extern NSArray *week2Regionals;
extern NSArray *week3Regionals;
extern NSArray *week4Regionals;
extern NSArray *week5Regionals;
extern NSArray *week6Regionals;
extern NSArray *week7Regionals;
extern NSArray *allWeekRegionals;

// Core Data Filepath
extern NSFileManager *FSAfileManager;
extern NSURL *FSAdocumentsDirectory;
extern NSString *FSAdocumentName;
extern NSURL *FSApathurl;
extern UIManagedDocument *FSAdocument;
extern NSManagedObjectContext *context;

// Match Schedule Filepath
extern NSArray *schedulePaths;
extern NSString *scheduleDirectory;
extern NSString *schedulePath;

@end
