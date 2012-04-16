//
//  MoodFirstViewController.h
//  MoodTrend
//
//  Created by Administrator on 11/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseOperations.h"

@interface MoodFirstViewController : UIViewController {
    UIButton *buttonMood1;
    UIButton *buttonMood2;
    UIButton *buttonMood3;
}

@property (nonatomic, retain) IBOutlet UIButton *buttonMood1;
@property (nonatomic, retain) IBOutlet UIButton *buttonMood2;
@property (nonatomic, retain) IBOutlet UIButton *buttonMood3;


// Method that gets triggered automatically when the button's pressed
-(IBAction) buttonPressed:(id)sender;

-(void) buttonBeingPressed: (id) sender;

// Method to display the mood ratios in the UI
- (void) showMoodRatioWithArray: (NSArray *) moodArray;


@end
