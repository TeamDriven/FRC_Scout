//
//  NextMatch.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/3/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NextMatch : UIViewController<UITextFieldDelegate>

// Red 1
@property (weak, nonatomic) IBOutlet UITextField *red1SearchBox;
@property (weak, nonatomic) IBOutlet UIButton *red1PitData;
@property (weak, nonatomic) IBOutlet UILabel *red1AutoHighMakes;
@property (weak, nonatomic) IBOutlet UILabel *red1AutoHighHot;
@property (weak, nonatomic) IBOutlet UILabel *red1AutoLowMakes;
@property (weak, nonatomic) IBOutlet UILabel *red1AutoLowHot;
@property (weak, nonatomic) IBOutlet UILabel *red1MobilityPercentage;
@property (weak, nonatomic) IBOutlet UILabel *red1TeleopHighMakes;
@property (weak, nonatomic) IBOutlet UILabel *red1TeleopLowMakes;
@property (weak, nonatomic) IBOutlet UILabel *red1TrussShot;
@property (weak, nonatomic) IBOutlet UILabel *red1TrussCatch;
@property (weak, nonatomic) IBOutlet UILabel *red1Passes;
@property (weak, nonatomic) IBOutlet UILabel *red1Receives;
@property (weak, nonatomic) IBOutlet UILabel *red1SmallPenalty;
@property (weak, nonatomic) IBOutlet UILabel *red1LargePenalty;
@property (weak, nonatomic) IBOutlet UILabel *red1Offensive;
@property (weak, nonatomic) IBOutlet UILabel *red1Neutral;
@property (weak, nonatomic) IBOutlet UILabel *red1Defensive;

// Red 2
@property (weak, nonatomic) IBOutlet UITextField *red2SearchBox;
@property (weak, nonatomic) IBOutlet UIButton *red2PitData;
@property (weak, nonatomic) IBOutlet UILabel *red2AutoHighMakes;
@property (weak, nonatomic) IBOutlet UILabel *red2AutoHighHot;
@property (weak, nonatomic) IBOutlet UILabel *red2AutoLowMakes;
@property (weak, nonatomic) IBOutlet UILabel *red2AutoLowHot;
@property (weak, nonatomic) IBOutlet UILabel *red2MobilityPercentage;
@property (weak, nonatomic) IBOutlet UILabel *red2TeleopHighMakes;
@property (weak, nonatomic) IBOutlet UILabel *red2TeleopLowMakes;
@property (weak, nonatomic) IBOutlet UILabel *red2TrussShot;
@property (weak, nonatomic) IBOutlet UILabel *red2TrussCatch;
@property (weak, nonatomic) IBOutlet UILabel *red2Passes;
@property (weak, nonatomic) IBOutlet UILabel *red2Receives;
@property (weak, nonatomic) IBOutlet UILabel *red2SmallPenalty;
@property (weak, nonatomic) IBOutlet UILabel *red2LargePenalty;
@property (weak, nonatomic) IBOutlet UILabel *red2Offensive;
@property (weak, nonatomic) IBOutlet UILabel *red2Neutral;
@property (weak, nonatomic) IBOutlet UILabel *red2Defensive;

// Red 3
@property (weak, nonatomic) IBOutlet UITextField *red3SearchBox;
@property (weak, nonatomic) IBOutlet UIButton *red3PitData;
@property (weak, nonatomic) IBOutlet UILabel *red3AutoHighMakes;
@property (weak, nonatomic) IBOutlet UILabel *red3AutoHighHot;
@property (weak, nonatomic) IBOutlet UILabel *red3AutoLowMakes;
@property (weak, nonatomic) IBOutlet UILabel *red3AutoLowHot;
@property (weak, nonatomic) IBOutlet UILabel *red3MobilityPercentage;
@property (weak, nonatomic) IBOutlet UILabel *red3TeleopHighMakes;
@property (weak, nonatomic) IBOutlet UILabel *red3TeleopLowMakes;
@property (weak, nonatomic) IBOutlet UILabel *red3TrussShot;
@property (weak, nonatomic) IBOutlet UILabel *red3TrussCatch;
@property (weak, nonatomic) IBOutlet UILabel *red3Passes;
@property (weak, nonatomic) IBOutlet UILabel *red3Receives;
@property (weak, nonatomic) IBOutlet UILabel *red3SmallPenalty;
@property (weak, nonatomic) IBOutlet UILabel *red3LargePenalty;
@property (weak, nonatomic) IBOutlet UILabel *red3Offensive;
@property (weak, nonatomic) IBOutlet UILabel *red3Neutral;
@property (weak, nonatomic) IBOutlet UILabel *red3Defensive;

// Blue 1
@property (weak, nonatomic) IBOutlet UITextField *blue1SearchBox;
@property (weak, nonatomic) IBOutlet UIButton *blue1PitData;
@property (weak, nonatomic) IBOutlet UILabel *blue1AutoHighMakes;
@property (weak, nonatomic) IBOutlet UILabel *blue1AutoHighHot;
@property (weak, nonatomic) IBOutlet UILabel *blue1AutoLowMakes;
@property (weak, nonatomic) IBOutlet UILabel *blue1AutoLowHot;
@property (weak, nonatomic) IBOutlet UILabel *blue1MobilityPercentage;
@property (weak, nonatomic) IBOutlet UILabel *blue1TeleopHighMakes;
@property (weak, nonatomic) IBOutlet UILabel *blue1TeleopLowMakes;
@property (weak, nonatomic) IBOutlet UILabel *blue1TrussShot;
@property (weak, nonatomic) IBOutlet UILabel *blue1TrussCatch;
@property (weak, nonatomic) IBOutlet UILabel *blue1Passes;
@property (weak, nonatomic) IBOutlet UILabel *blue1Receives;
@property (weak, nonatomic) IBOutlet UILabel *blue1SmallPenalty;
@property (weak, nonatomic) IBOutlet UILabel *blue1LargePenalty;
@property (weak, nonatomic) IBOutlet UILabel *blue1Offensive;
@property (weak, nonatomic) IBOutlet UILabel *blue1Neutral;
@property (weak, nonatomic) IBOutlet UILabel *blue1Defensive;


// Blue 2
@property (weak, nonatomic) IBOutlet UITextField *blue2SearchBox;
@property (weak, nonatomic) IBOutlet UIButton *blue2PitData;
@property (weak, nonatomic) IBOutlet UILabel *blue2AutoHighMakes;
@property (weak, nonatomic) IBOutlet UILabel *blue2AutoHighHot;
@property (weak, nonatomic) IBOutlet UILabel *blue2AutoLowMakes;
@property (weak, nonatomic) IBOutlet UILabel *blue2AutoLowHot;
@property (weak, nonatomic) IBOutlet UILabel *blue2MobilityPercentage;
@property (weak, nonatomic) IBOutlet UILabel *blue2TeleopHighMakes;
@property (weak, nonatomic) IBOutlet UILabel *blue2TeleopLowMakes;
@property (weak, nonatomic) IBOutlet UILabel *blue2TrussShot;
@property (weak, nonatomic) IBOutlet UILabel *blue2TrussCatch;
@property (weak, nonatomic) IBOutlet UILabel *blue2Passes;
@property (weak, nonatomic) IBOutlet UILabel *blue2Receives;
@property (weak, nonatomic) IBOutlet UILabel *blue2SmallPenalty;
@property (weak, nonatomic) IBOutlet UILabel *blue2LargePenalty;
@property (weak, nonatomic) IBOutlet UILabel *blue2Offensive;
@property (weak, nonatomic) IBOutlet UILabel *blue2Neutral;
@property (weak, nonatomic) IBOutlet UILabel *blue2Defensive;


// Blue 3
@property (weak, nonatomic) IBOutlet UITextField *blue3SearchBox;
@property (weak, nonatomic) IBOutlet UIButton *blue3PitData;
@property (weak, nonatomic) IBOutlet UILabel *blue3AutoHighMakes;
@property (weak, nonatomic) IBOutlet UILabel *blue3AutoHighHot;
@property (weak, nonatomic) IBOutlet UILabel *blue3AutoLowMakes;
@property (weak, nonatomic) IBOutlet UILabel *blue3AutoLowHot;
@property (weak, nonatomic) IBOutlet UILabel *blue3MobilityPercentage;
@property (weak, nonatomic) IBOutlet UILabel *blue3TeleopHighMakes;
@property (weak, nonatomic) IBOutlet UILabel *blue3TeleopLowMakes;
@property (weak, nonatomic) IBOutlet UILabel *blue3TrussShot;
@property (weak, nonatomic) IBOutlet UILabel *blue3TrussCatch;
@property (weak, nonatomic) IBOutlet UILabel *blue3Passes;
@property (weak, nonatomic) IBOutlet UILabel *blue3Receives;
@property (weak, nonatomic) IBOutlet UILabel *blue3SmallPenalty;
@property (weak, nonatomic) IBOutlet UILabel *blue3LargePenalty;
@property (weak, nonatomic) IBOutlet UILabel *blue3Offensive;
@property (weak, nonatomic) IBOutlet UILabel *blue3Neutral;
@property (weak, nonatomic) IBOutlet UILabel *blue3Defensive;





@end






















