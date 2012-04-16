//
//  MoodFirstViewController.m
//  MoodTrend
//
//  Created by Administrator on 11/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "MoodFirstViewController.h"
#import "DatabaseOperations.h"


@implementation MoodFirstViewController


@synthesize buttonMood1;
@synthesize buttonMood2;
@synthesize buttonMood3;


DatabaseOperations *dbOps;


/**
 * The method that's called when any of the button's pressed
 * @param sender  (id)  - The sender i.e. component in the UI which trigerred this event.
 * @date  13/04/2012
 */
-(IBAction) buttonPressed:(id)sender {
    
    if (sender == buttonMood1) {
        NSLog(@"Am doing great!");
        
        UIImage *imageButton1Pressed = [UIImage imageNamed:@"ButtonGreen2.png"];
        [buttonMood1 setBackgroundImage:imageButton1Pressed forState:UIControlStateNormal];
        
        [dbOps insertRecordIntoTableNamed:@"MoodTrack"
                              withField1:@"mood"
                              field1Value:@"1" withField2:@"sleep" field2Value:@"yes"];
        NSArray *moodArray = [dbOps getAllRowsFromTableNamed:@"MoodTrack"];
        [self showMoodRatioWithArray: moodArray];
        
        
    } else if (sender == buttonMood2) {
        NSLog(@"Am doing just okay");
        
        UIImage *imageButton2Pressed = [UIImage imageNamed:@"ButtonYellow2.png"];
        [buttonMood2 setBackgroundImage:imageButton2Pressed forState:UIControlStateNormal];
        
        [dbOps insertRecordIntoTableNamed:@"MoodTrack"
                              withField1:@"mood"
                              field1Value:@"2" withField2:@"sleep" field2Value:@"yes"];
        NSArray *moodArray = [dbOps getAllRowsFromTableNamed:@"MoodTrack"];
        [self showMoodRatioWithArray: moodArray];
        
        
    } else if (sender == buttonMood3) {
        NSLog(@"Am not doing fine");
        
        UIImage *imageButton3Pressed = [UIImage imageNamed:@"ButtonRed2.png"];
        [buttonMood3 setBackgroundImage:imageButton3Pressed forState:UIControlStateNormal];
        
        [dbOps insertRecordIntoTableNamed:@"MoodTrack"
                              withField1:@"mood"
                             field1Value:@"3" withField2:@"sleep" field2Value:@"yes"];
        NSArray *moodArray = [dbOps getAllRowsFromTableNamed:@"MoodTrack"];
        [self showMoodRatioWithArray: moodArray];
    }
}




/**
 * Method that gets called during the moment that the user presses the button.
 * The intention is to show a different image for the button, when it's being pressed; just a visual effect.
 * @param sender  (id)  - The UI component that triggered this event
 * @date - 13/04/2012
 */
-(IBAction) buttonBeingPressed: (id) sender {
    
    if ( sender == buttonMood1 ) {
        UIImage *imageButton1Pressed = [UIImage imageNamed:@"ButtonGreen1.png"];
        [buttonMood1 setBackgroundImage:imageButton1Pressed forState:UIControlStateNormal];
    
    } else if ( sender == buttonMood2 ) {
        UIImage *imageButton2Pressed = [UIImage imageNamed:@"ButtonYellow1.png"];
        [buttonMood2 setBackgroundImage:imageButton2Pressed forState:UIControlStateNormal];
        
    } else if ( sender == buttonMood3 ) {
        UIImage *imageButton3Pressed = [UIImage imageNamed:@"ButtonRed1.png"];
        [buttonMood3 setBackgroundImage:imageButton3Pressed forState:UIControlStateNormal];
    }
}




/**
 * Calculate the mood ratios and display them in the UI
 * @param moodArray  (NSArray) - an array with the values:
 *                                                       1. Total num of rows in the table
 *                                                       2. Count of rows with the value of mood1
 *                                                       3. Count of rows with the value of mood2
 *                                                       4. Count of rows with the value of mood3
 *                                                  in that order
 * @return void
 * @date 13/04/2012
 */
- (void) showMoodRatioWithArray: (NSArray *) moodArray {
    
    NSNumber *num1 = [moodArray objectAtIndex:0];
    double totalCount = [num1 doubleValue];
    
    NSNumber *num2 = [moodArray objectAtIndex:1];
    double mood1Count = [num2 doubleValue];
    
    NSNumber *num3 = [moodArray objectAtIndex:2];
    double mood2Count = [num3 doubleValue];
    
    NSNumber *num4 = [moodArray objectAtIndex:3];
    double mood3Count = [num4 doubleValue];
    
    NSLog  (@"total_cnt:%@ mood1:%@ mood2:%@ mood3:%@",
           [NSString stringWithFormat:@"%@", [moodArray objectAtIndex:0]],
           [NSString stringWithFormat:@"%@", [moodArray objectAtIndex:1]],
           [NSString stringWithFormat:@"%@", [moodArray objectAtIndex:2]],
           [NSString stringWithFormat:@"%@", [moodArray objectAtIndex:3]]);
    
    double ratio1 = mood1Count / totalCount;
    [buttonMood1 setTitle:[NSString stringWithFormat:@"%.2f", ratio1]
                 forState:UIControlStateNormal];
    
    double ratio2 = mood2Count / totalCount;
    [buttonMood2 setTitle:[NSString stringWithFormat:@"%.2f", ratio2]
                 forState:UIControlStateNormal];
    
    double ratio3 = mood3Count / totalCount;
    [buttonMood3 setTitle:[NSString stringWithFormat:@"%.2f", ratio3]
                 forState:UIControlStateNormal];
    
    
    NSLog(@"Mood1Value: %f, Total Value:%f, Mood1 Current Ratio: %f", 
          mood1Count, totalCount, ratio1);
    NSLog(@"Mood2Value: %f, Total Value:%f, Mood2 Current Ratio: %f", 
          mood2Count, totalCount, ratio2);
    NSLog(@"Mood3Value: %f, Total Value:%f, Mood3 Current Ratio: %f", 
          mood3Count, totalCount, ratio3);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    dbOps = [[DatabaseOperations alloc] init];
    [dbOps openDB];
    [dbOps createTableNamed:@"MoodTrack"
                withField1:@"mood" 
                withField2:@"sleep"];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
