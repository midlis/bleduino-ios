//
//  GameControllerViewController.m
//  BLEduino
//
//  Created by Ramon Gonzalez on 11/14/13.
//  Copyright (c) 2013 Kytelabs. All rights reserved.
//

#import "GameControllerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BDLeManager.h"
#import "BDController.h"
#import "BDButtonAction.h"
#import "OBShapedButton.h"

#pragma mark -
#pragma mark Setup
/****************************************************************************/
/*                                  Setup                                   */
/****************************************************************************/

@interface GameControllerViewController ()
@property (weak) IBOutlet OBShapedButton *yButton;
@property (weak) IBOutlet OBShapedButton *xButton;
@property (weak) IBOutlet OBShapedButton *aButton;
@property (weak) IBOutlet OBShapedButton *bButton;

@property (weak) IBOutlet UIButton *start;
@property (weak) IBOutlet UIButton *select;

@property (strong) UIImageView *orientationIndicator;
@property (strong) UIView *orientationIndicatorMask;

@end

@implementation GameControllerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    //Setup joystick.
    CGRect originFrame = CGRectMake(10, 25, 270, 270);
    MFLJoystick *joystick = [[MFLJoystick alloc] initWithFrame:originFrame];
    [joystick setThumbImage:[UIImage imageNamed:@"joystick-neutral.png"]
                 andBGImage:[UIImage imageNamed:@"joystick-bg.png"]];
    [joystick setDelegate:self];
    [self.view addSubview:joystick];
        
    //Initiate last position.
    CGPoint center = CGPointMake(CGRectGetMidX(originFrame), CGRectGetMidY(originFrame));
    self.lastPosition = center;
    
    //Setup orientation tracking and alert.
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
    //What's initial orientation?
    UIDeviceOrientation currentOrientation = [[UIDevice currentDevice] orientation];
    BOOL isLandscape = (currentOrientation == UIDeviceOrientationLandscapeLeft);
    
    self.orientationIndicatorMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 568, 320)];
    self.orientationIndicatorMask.backgroundColor = [UIColor lightTextColor];
    self.orientationIndicatorMask.alpha = (isLandscape)?0:1.0;
    
    self.orientationIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(259, 80, 50, 160)];
    self.orientationIndicator.image = [UIImage imageNamed:@"rotate-left.png"];
    self.orientationIndicator.alpha = (isLandscape)?0:1.0;
    
    [self.view addSubview:self.orientationIndicatorMask];
    [self.view addSubview:self.orientationIndicator];
    
    UIColor *lightBlue = [UIColor colorWithRed:THEME_COLOR_RED/255.0
                                         green:THEME_COLOR_GREEN/255.0
                                          blue:THEME_COLOR_BLUE/255.0
                                         alpha:1.0];
    
    //Setup dismiss button.
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
    dismissButton.frame = CGRectMake(0, 0, 60, 50);
    dismissButton.tintColor = lightBlue;
    [dismissButton setImage:[UIImage imageNamed:@"arrow-left.png"] forState:UIControlStateNormal];
    [dismissButton addTarget:self
                      action:@selector(dismissModule)
            forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:dismissButton];
    
    //Setup push buttons.
    //Button Pressing Down Observer
    [self.xButton addTarget:self action:@selector(xButton:) forControlEvents:UIControlEventTouchDown];
    [self.yButton addTarget:self action:@selector(yButton:) forControlEvents:UIControlEventTouchDown];
    [self.aButton addTarget:self action:@selector(aButton:) forControlEvents:UIControlEventTouchDown];
    [self.bButton addTarget:self action:@selector(bButton:) forControlEvents:UIControlEventTouchDown];
    
    //Button Released Observer
    [self.xButton addTarget:self action:@selector(xButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
    [self.yButton addTarget:self action:@selector(yButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
    [self.aButton addTarget:self action:@selector(aButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
    [self.bButton addTarget:self action:@selector(bButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
    
    //Start/Select buttons.
    [self.start addTarget:self action:@selector(startButton:) forControlEvents:UIControlEventTouchDown];
    [self.start addTarget:self action:@selector(startButtonReleased:) forControlEvents:UIControlEventTouchDown];
    [self.select addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchDown];
    [self.select addTarget:self action:@selector(selectButtonReleased:) forControlEvents:UIControlEventTouchDown];
    
    //Appareance
    self.start.tintColor = lightBlue;
    self.select.tintColor = lightBlue;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissModule
{
    [self.delegate gameControllerModuleViewControllerDismissed:self];
}


- (void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            /* start rotate left animation */

            [UIView beginAnimations:@"Orientation Indicator" context:nil];
            self.orientationIndicator.alpha = 1.0;
            self.orientationIndicatorMask.alpha = 1.0;
            [UIView commitAnimations];
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            /* start rotate left animation */
        
            [UIView beginAnimations:@"Orientation Indicator" context:nil];
            self.orientationIndicator.alpha = 1.0;
            self.orientationIndicatorMask.alpha = 1.0;
            [UIView commitAnimations];
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            //This is the orientation we want.
            
            [UIView beginAnimations:@"Orientation Indicator" context:nil];
            self.orientationIndicator.alpha = 0;
            self.orientationIndicatorMask.alpha = 0;
            [UIView setAnimationDuration:0.3];
            [UIView commitAnimations];
            break;
            
        case UIDeviceOrientationLandscapeRight:
            /* start rotate left animation */
            
            [UIView beginAnimations:@"Orientation Indicator" context:nil];
            self.orientationIndicator.alpha = 1.0;
            self.orientationIndicatorMask.alpha = 1.0;
            [UIView setAnimationDuration:0.3];
            [UIView commitAnimations];
            break;
        
        default:
            break;
    };
}
/****************************************************************************/
/*                       Button Action Updates                              */
/****************************************************************************/

#pragma mark -
#pragma mark - Joystick Updates
//Vertical Resolution: 200, 135 > neutral, 35 > 90 (Max up), 235 > -90 (Max down)
//Horizontal Resolution: 200, 135 > neutral, 35 > 90 (Max left), 235 > -90 (Max right)

//Adapted - Vertical Resolution: 25, 1 > 90 (Max up), 26 > -90 (Max down), 13 > neutral
//Adapted - Horizontal Resolution: 25, 1 > 90 (Max left), 26 > -90 (Max right), 13 > neutral
- (void)joystick:(MFLJoystick *)aJoystick didUpdate:(CGPoint)dir
{
    //Lowering resolution to 25. If change is 8px then send data update.
    if(labs(self.lastPosition.x - dir.x) > 7 || labs(self.lastPosition.y - dir.y) > 7)
    {
        self.lastPosition = dir;
        CGFloat adaptedX = ceil((dir.x-34)/8);
        CGFloat adaptedY = ceil((dir.y-34)/8);
        CGPoint adaptedPoint = CGPointMake(adaptedX, adaptedY);
    
        //Create Vertical Joystick action.
        BDButtonAction *vJoystickUpdate = [[BDButtonAction alloc] init];
        vJoystickUpdate.buttonValue = adaptedPoint.y;
        vJoystickUpdate.buttonID = 0;
        
        //Create Horizontal Joystick action.
        BDButtonAction *hJoystickUpdate = [[BDButtonAction alloc] init];
        hJoystickUpdate.buttonValue = adaptedPoint.x;
        hJoystickUpdate.buttonID = 1;
        
        //Send joystick action.
        BDLeManager *leManager = [BDLeManager sharedLeManager];
        
        for(CBPeripheral *bleduino in leManager.connectedBleduinos)
        {
            BDController *gameController = [[BDController alloc] initWithPeripheral:bleduino
                                                                                         delegate:self];
            [gameController writeButtonAction:vJoystickUpdate]; //Vertical
            [gameController writeButtonAction:hJoystickUpdate]; //Horizontal
        }
        
        NSLog(@"GameController, sent *Vertical Joystick* action update, state: %f", adaptedPoint.y);
        NSLog(@"GameController, sent *Horizontal Joystick* action update, state: %f", adaptedPoint.x);
    }
}

#pragma mark -
#pragma mark Button Pushed Down
//Send button pushed down action.
- (void)yButton:(id)sender
{
    [self ySendUpdateWithStateSelected:YES];
}

- (void)xButton:(id)sender
{
    [self xSendUpdateWithStateSelected:YES];
}

- (void)aButton:(id)sender
{
    [self aSendUpdateWithStateSelected:YES];
}

- (void)bButton:(id)sender
{
    [self bSendUpdateWithStateSelected:YES];
}

#pragma mark -
#pragma mark Button Released
//Send button released action.
- (void)yButtonReleased:(id)sender
{
    [self ySendUpdateWithStateSelected:NO];
}

- (void)xButtonReleased:(id)sender
{
    [self xSendUpdateWithStateSelected:NO];
}

- (void)aButtonReleased:(id)sender
{
    [self aSendUpdateWithStateSelected:NO];
}

- (void)bButtonReleased:(id)sender
{
    [self bSendUpdateWithStateSelected:NO];
}

#pragma mark -
#pragma mark Send Button Action Updates
//Send button action updates.
- (void)ySendUpdateWithStateSelected:(BOOL)selected
{
    //Create button action.
    BDButtonAction *yButtonUpdate = [BDButtonAction action];
    yButtonUpdate.buttonStatus = [[NSNumber numberWithBool:selected] integerValue];
    yButtonUpdate.buttonID = 2;
    
    //Send button action.
    [BDBleduino writeValue:yButtonUpdate];
    
    NSLog(@"GameController, sent button *Y* action update, state: %i", selected);
}

- (void)xSendUpdateWithStateSelected:(BOOL)selected
{
    //Create button action.
    BDButtonAction *xButtonUpdate = [BDButtonAction action];
    xButtonUpdate.buttonStatus = [[NSNumber numberWithBool:selected] integerValue];
    xButtonUpdate.buttonID = 3;
    
    //Send button action.
    [BDBleduino writeValue:xButtonUpdate];
    
    NSLog(@"GameController, sent button *X* action update, state: %i", selected);
}

- (void)aSendUpdateWithStateSelected:(BOOL)selected
{
    //Create button action.
    BDButtonAction *aButtonUpdate = [BDButtonAction action];
    aButtonUpdate.buttonStatus = [[NSNumber numberWithBool:selected] integerValue];
    aButtonUpdate.buttonID = 4;
    
    //Send button action.
    [BDBleduino writeValue:aButtonUpdate];
    
    NSLog(@"GameController, sent button *A* action update, state: %i", selected);
}

- (void)bSendUpdateWithStateSelected:(BOOL)selected
{
    //Create button action.
    BDButtonAction *bButtonUpdate = [BDButtonAction action];
    bButtonUpdate.buttonStatus = [[NSNumber numberWithBool:selected] integerValue];
    bButtonUpdate.buttonID = 5;
    
    //Send button action.
    [BDBleduino writeValue:bButtonUpdate];
    
    
    NSLog(@"GameController, sent button *B* action update, state: %i", selected);
}

#pragma mark -
#pragma mark Start/Select buttons
//Send start/select action.

- (void)startButton:(id)sender
{
    [self startSendUpdateWithStateSelected:YES];
}

- (void)startButtonReleased:(id)sender
{
    [self startSendUpdateWithStateSelected:NO];
}

- (void)selectButton:(id)sender
{
    [self selectSendUpdateWithStateSelected:YES];
}

- (void)selectButtonReleased:(id)sender
{
    [self selectSendUpdateWithStateSelected:NO];
}

- (void)startSendUpdateWithStateSelected:(BOOL)selected
{
    //Create button action.
    BDButtonAction *startButtonUpdate = [[BDButtonAction alloc] init];
    startButtonUpdate.buttonStatus = [[NSNumber numberWithBool:selected] integerValue];
    startButtonUpdate.buttonID = 6;
    
    //Send button action.
    BDLeManager *leManager = [BDLeManager sharedLeManager];
    
    for(CBPeripheral *bleduino in leManager.connectedBleduinos)
    {
        BDController *gameController = [[BDController alloc] initWithPeripheral:bleduino
                                                                                 delegate:self];
        [gameController writeButtonAction:startButtonUpdate];
    }
    
    NSLog(@"GameController, sent button *Start* action update");
}

- (void)selectSendUpdateWithStateSelected:(BOOL)selected
{
    //Create button action.
    BDButtonAction *selectButtonUpdate = [[BDButtonAction alloc] init];
    selectButtonUpdate.buttonStatus = [[NSNumber numberWithBool:selected] integerValue];;
    selectButtonUpdate.buttonID = 7;
    
    //Send button action.
    BDLeManager *leManager = [BDLeManager sharedLeManager];
    
    for(CBPeripheral *bleduino in leManager.connectedBleduinos)
    {
        BDController *gameController = [[BDController alloc] initWithPeripheral:bleduino
                                                                                 delegate:self];
        [gameController writeButtonAction:selectButtonUpdate];
    }
    
    NSLog(@"GameController, sent button *Select* action update");
}

@end
