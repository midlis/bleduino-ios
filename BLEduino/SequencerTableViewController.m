//
//  SequencerTableViewController.m
//  BLEduino
//
//  Created by Ramon Gonzalez on 6/13/14.
//  Copyright (c) 2014 Kytelabs. All rights reserved.
//

#import "SequencerTableViewController.h"

@interface SequencerTableViewController ()

@end

@implementation SequencerTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sequence = [NSMutableArray arrayWithCapacity:10];
    
    //Begin/End sequence commands. 
    self.start = [[BDFirmataCommandCharacteristic alloc] initWithPinState:4
                                                                pinNumber:99
                                                                 pinValue:99];
    
    self.end = [[BDFirmataCommandCharacteristic alloc] initWithPinState:5
                                                              pinNumber:99
                                                               pinValue:99];
    
    //Set appareance.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UIColor *lightBlue = [UIColor colorWithRed:38/255.0 green:109/255.0 blue:235/255.0 alpha:1.0];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = lightBlue;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    BDLeDiscoveryManager *leManager = [BDLeDiscoveryManager sharedLeManager];
    leManager.delegate = self;
    CBPeripheral *bleduino = [leManager.connectedBleduinos lastObject];
    
    //Global firmata service for listening for updates.
    self.firmata =[[BDFirmataService alloc] initWithPeripheral:bleduino delegate:self];
    [self.firmata subscribeToStartReceivingFirmataCommands];
    
    //Load previous state.
    [self setPreviousState];
}

- (void)viewDidLayoutSubviews
{
    [self.tableView headerViewForSection:0].textLabel.textAlignment = NSTextAlignmentCenter;
}

- (IBAction)dismissModule
{
    //Store sequence for persistance.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *sequence = [[NSMutableArray alloc] initWithCapacity:self.sequence.count];
    NSMutableArray *sequenceStates = [[NSMutableArray alloc] initWithCapacity:self.sequence.count];
    NSMutableArray *sequenceValues = [[NSMutableArray alloc] initWithCapacity:self.sequence.count];
    NSMutableArray *sequenceDelayFormats = [[NSMutableArray alloc] initWithCapacity:self.sequence.count];
    NSMutableArray *sequenceDelayValues = [[NSMutableArray alloc] initWithCapacity:self.sequence.count];
    

    for (BDFirmataCommandCharacteristic *command in self.sequence)
    {
        [sequence addObject:[NSNumber numberWithLong:command.pinNumber]];
        
        //Store delay configuration.
        if(command.pinNumber == 100)
        {
            [sequenceDelayFormats addObject:[NSNumber numberWithLong:command.pinState]];
            [sequenceDelayValues addObject:[NSNumber numberWithLong:command.pinValue]];
        }
        else
        {
            [sequenceStates addObject:[NSNumber numberWithLong:command.pinState]];
            [sequenceValues addObject:[NSNumber numberWithLong:command.pinValue]];
        }
    }
    
    //Archive everything.
    [defaults setObject:sequence             forKey:SEQUENCE];
    [defaults setObject:sequenceStates       forKey:SEQUENCE_STATES];
    [defaults setObject:sequenceValues       forKey:SEQUENCE_VALUES];
    [defaults setObject:sequenceDelayFormats forKey:SEQUENCE_DELAY_FORMATS];
    [defaults setObject:sequenceDelayValues  forKey:SEQUENCE_DELAY_VALUES];
    [defaults synchronize];
    
    [self.delegate sequencerTableViewControllerDismissed:self];
}

- (void)setPreviousState
{
    //Load sequence.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *sequence = (NSArray *)[defaults objectForKey:SEQUENCE];
    NSArray *sequenceStates = (NSArray *)[defaults objectForKey:SEQUENCE_STATES];
    NSArray *sequenceValues = (NSArray *)[defaults objectForKey:SEQUENCE_VALUES];
    NSArray *sequenceDelayFormats = (NSArray *)[defaults objectForKey:SEQUENCE_DELAY_FORMATS];
    NSArray *sequenceDelayValues = (NSArray *)[defaults objectForKey:SEQUENCE_DELAY_VALUES];
    NSInteger delayCounter = 0;
    NSInteger pinCounter = 0;
    
    self.sequence = [[NSMutableArray alloc] initWithCapacity:sequence.count];
    
    for (NSNumber *entry in sequence)
    {
        NSInteger command = [entry intValue];
        switch (command) {
            case 0:
            {
                FirmataCommandPinState state = [[sequenceStates objectAtIndex:pinCounter] intValue];
                NSInteger storedValue = [[sequenceValues objectAtIndex:pinCounter] intValue];
                NSInteger value = (state == FirmataCommandPinStatePWM || state == FirmataCommandPinStateOutput)?storedValue:-1;
                BDFirmataCommandCharacteristic *pin = [[BDFirmataCommandCharacteristic alloc] initWithPinState:state
                                                                                                      pinNumber:0
                                                                                                       pinValue:value];
                [self.sequence addObject:pin];
                pinCounter = pinCounter + 1;
            }break;
                
            case 1:
            {
                FirmataCommandPinState state = [[sequenceStates objectAtIndex:pinCounter] intValue];
                NSInteger storedValue = [[sequenceValues objectAtIndex:pinCounter] intValue];
                NSInteger value = (state == FirmataCommandPinStatePWM || state == FirmataCommandPinStateOutput)?storedValue:-1;
                BDFirmataCommandCharacteristic *pin = [[BDFirmataCommandCharacteristic alloc] initWithPinState:state
                                                                                                      pinNumber:1
                                                                                                       pinValue:value];
                [self.sequence addObject:pin];
                pinCounter = pinCounter + 1;
            }break;
                
            case 2:
            {
                FirmataCommandPinState state = [[sequenceStates objectAtIndex:pinCounter] intValue];
                NSInteger storedValue = [[sequenceValues objectAtIndex:pinCounter] intValue];
                NSInteger value = (state == FirmataCommandPinStatePWM || state == FirmataCommandPinStateOutput)?storedValue:-1;
                BDFirmataCommandCharacteristic *pin = [[BDFirmataCommandCharacteristic alloc] initWithPinState:state
                                                                                                      pinNumber:2
                                                                                                       pinValue:value];
                [self.sequence addObject:pin];
                pinCounter = pinCounter + 1;
            }break;
                
            case 3:
            {
                FirmataCommandPinState state = [[sequenceStates objectAtIndex:pinCounter] intValue];
                NSInteger storedValue = [[sequenceValues objectAtIndex:pinCounter] intValue];
                NSInteger value = (state == FirmataCommandPinStatePWM || state == FirmataCommandPinStateOutput)?storedValue:-1;
                BDFirmataCommandCharacteristic *pin = [[BDFirmataCommandCharacteristic alloc] initWithPinState:state
                                                                                                      pinNumber:3
                                                                                                       pinValue:value];
                [self.sequence addObject:pin];
                pinCounter = pinCounter + 1;
            }break;
                
            case 4:
            {
                
                FirmataCommandPinState state = [[sequenceStates objectAtIndex:pinCounter] intValue];
                NSInteger storedValue = [[sequenceValues objectAtIndex:pinCounter] intValue];
                NSInteger value = (state == FirmataCommandPinStatePWM || state == FirmataCommandPinStateOutput)?storedValue:-1;
                BDFirmataCommandCharacteristic *pin = [[BDFirmataCommandCharacteristic alloc] initWithPinState:state
                                                                                                      pinNumber:4
                                                                                                       pinValue:value];
                [self.sequence addObject:pin];
                pinCounter = pinCounter + 1;
            }break;
                
            case 5:
            {
                FirmataCommandPinState state = [[sequenceStates objectAtIndex:pinCounter] intValue];
                NSInteger storedValue = [[sequenceValues objectAtIndex:pinCounter] intValue];
                NSInteger value = (state == FirmataCommandPinStatePWM || state == FirmataCommandPinStateOutput)?storedValue:-1;
                BDFirmataCommandCharacteristic *pin = [[BDFirmataCommandCharacteristic alloc] initWithPinState:state
                                                                                                      pinNumber:5
                                                                                                       pinValue:value];
                [self.sequence addObject:pin];
                pinCounter = pinCounter + 1;
            }break;
                
            case 6:
            {
                FirmataCommandPinState state = [[sequenceStates objectAtIndex:pinCounter] intValue];
                NSInteger storedValue = [[sequenceValues objectAtIndex:pinCounter] intValue];
                NSInteger value = (state == FirmataCommandPinStatePWM || state == FirmataCommandPinStateOutput)?storedValue:-1;
                BDFirmataCommandCharacteristic *pin = [[BDFirmataCommandCharacteristic alloc] initWithPinState:state
                                                                                                      pinNumber:6
                                                                                                       pinValue:value];
                [self.sequence addObject:pin];
                pinCounter = pinCounter + 1;
            }break;
                
            case 7:
            {
                FirmataCommandPinState state = [[sequenceStates objectAtIndex:pinCounter] intValue];
                NSInteger storedValue = [[sequenceValues objectAtIndex:pinCounter] intValue];
                NSInteger value = (state == FirmataCommandPinStatePWM || state == FirmataCommandPinStateOutput)?storedValue:-1;
                BDFirmataCommandCharacteristic *pin = [[BDFirmataCommandCharacteristic alloc] initWithPinState:state
                                                                                                      pinNumber:7
                                                                                                       pinValue:value];
                [self.sequence addObject:pin];
                pinCounter = pinCounter + 1;
            }break;
                
            case 8:
            {
                FirmataCommandPinState state = [[sequenceStates objectAtIndex:pinCounter] intValue];
                NSInteger storedValue = [[sequenceValues objectAtIndex:pinCounter] intValue];
                NSInteger value = (state == FirmataCommandPinStatePWM || state == FirmataCommandPinStateOutput)?storedValue:-1;
                BDFirmataCommandCharacteristic *pin = [[BDFirmataCommandCharacteristic alloc] initWithPinState:state
                                                                                                      pinNumber:8
                                                                                                       pinValue:value];
                [self.sequence addObject:pin];
                pinCounter = pinCounter + 1;
            }break;
                
            case 9:
            {
                FirmataCommandPinState state = [[sequenceStates objectAtIndex:pinCounter] intValue];
                NSInteger storedValue = [[sequenceValues objectAtIndex:pinCounter] intValue];
                NSInteger value = (state == FirmataCommandPinStatePWM || state == FirmataCommandPinStateOutput)?storedValue:-1;
                BDFirmataCommandCharacteristic *pin = [[BDFirmataCommandCharacteristic alloc] initWithPinState:state
                                                                                                      pinNumber:9
                                                                                                       pinValue:value];
                [self.sequence addObject:pin];
                pinCounter = pinCounter + 1;
            }break;
                
            case 10:
            {
                FirmataCommandPinState state = [[sequenceStates objectAtIndex:pinCounter] intValue];
                NSInteger storedValue = [[sequenceValues objectAtIndex:pinCounter] intValue];
                NSInteger value = (state == FirmataCommandPinStatePWM || state == FirmataCommandPinStateOutput)?storedValue:-1;
                BDFirmataCommandCharacteristic *pin = [[BDFirmataCommandCharacteristic alloc] initWithPinState:state
                                                                                                       pinNumber:10
                                                                                                        pinValue:value];
                [self.sequence addObject:pin];
                pinCounter = pinCounter + 1;
            }break;
                
            case 11:
            {
                FirmataCommandPinState state = [[sequenceStates objectAtIndex:pinCounter] intValue];
                NSInteger storedValue = [[sequenceValues objectAtIndex:pinCounter] intValue];
                NSInteger value = (state == FirmataCommandPinStatePWM || state == FirmataCommandPinStateOutput)?storedValue:-1;
                BDFirmataCommandCharacteristic *pin = [[BDFirmataCommandCharacteristic alloc] initWithPinState:state
                                                                                                       pinNumber:11
                                                                                                        pinValue:value];
                [self.sequence addObject:pin];
                pinCounter = pinCounter + 1;
            }break;
                
            case 12:
            {
                FirmataCommandPinState state = [[sequenceStates objectAtIndex:pinCounter] intValue];
                NSInteger storedValue = [[sequenceValues objectAtIndex:pinCounter] intValue];
                NSInteger value = (state == FirmataCommandPinStatePWM || state == FirmataCommandPinStateOutput)?storedValue:-1;
                BDFirmataCommandCharacteristic *pin = [[BDFirmataCommandCharacteristic alloc] initWithPinState:state
                                                                                                       pinNumber:12
                                                                                                        pinValue:value];
                [self.sequence addObject:pin];
                pinCounter = pinCounter + 1;
            }break;
                
            case 13:
            {
                FirmataCommandPinState state = [[sequenceStates objectAtIndex:pinCounter] intValue];
                NSInteger storedValue = [[sequenceValues objectAtIndex:pinCounter] intValue];
                NSInteger value = (state == FirmataCommandPinStatePWM || state == FirmataCommandPinStateOutput)?storedValue:-1;
                BDFirmataCommandCharacteristic *pin = [[BDFirmataCommandCharacteristic alloc] initWithPinState:state
                                                                                                       pinNumber:13
                                                                                                        pinValue:value];
                [self.sequence addObject:pin];
                pinCounter = pinCounter + 1;
            }break;
                
            case 14:
            {
                FirmataCommandPinState state = [[sequenceStates objectAtIndex:pinCounter] intValue];
                NSInteger storedValue = [[sequenceValues objectAtIndex:pinCounter] intValue];
                NSInteger value = (state == FirmataCommandPinStatePWM || state == FirmataCommandPinStateOutput)?storedValue:-1;
                BDFirmataCommandCharacteristic *pin = [[BDFirmataCommandCharacteristic alloc] initWithPinState:state
                                                                                                       pinNumber:14
                                                                                                        pinValue:value];
                [self.sequence addObject:pin];
                pinCounter = pinCounter + 1;
            }break;
                
            case 15:
            {
                FirmataCommandPinState state = [[sequenceStates objectAtIndex:pinCounter] intValue];
                NSInteger storedValue = [[sequenceValues objectAtIndex:pinCounter] intValue];
                NSInteger value = (state == FirmataCommandPinStatePWM || state == FirmataCommandPinStateOutput)?storedValue:-1;
                BDFirmataCommandCharacteristic *pin = [[BDFirmataCommandCharacteristic alloc] initWithPinState:state
                                                                                                       pinNumber:15
                                                                                                        pinValue:value];
                [self.sequence addObject:pin];
                pinCounter = pinCounter + 1;
            }break;
                
            case 16:
            {
                FirmataCommandPinState state = [[sequenceStates objectAtIndex:pinCounter] intValue];
                NSInteger storedValue = [[sequenceValues objectAtIndex:pinCounter] intValue];
                NSInteger value = (state == FirmataCommandPinStatePWM || state == FirmataCommandPinStateOutput)?storedValue:-1;
                BDFirmataCommandCharacteristic *pin = [[BDFirmataCommandCharacteristic alloc] initWithPinState:state
                                                                                                       pinNumber:16
                                                                                                        pinValue:value];
                [self.sequence addObject:pin];
                pinCounter = pinCounter + 1;
            }break;
                
            case 17:
            {
                FirmataCommandPinState state = [[sequenceStates objectAtIndex:pinCounter] intValue];
                NSInteger storedValue = [[sequenceValues objectAtIndex:pinCounter] intValue];
                NSInteger value = (state == FirmataCommandPinStatePWM || state == FirmataCommandPinStateOutput)?storedValue:-1;
                BDFirmataCommandCharacteristic *pin = [[BDFirmataCommandCharacteristic alloc] initWithPinState:state
                                                                                                       pinNumber:17
                                                                                                        pinValue:value];
                [self.sequence addObject:pin];
                pinCounter = pinCounter + 1;
            }break;
                
            case 18:
            {
                FirmataCommandPinState state = [[sequenceStates objectAtIndex:pinCounter] intValue];
                NSInteger storedValue = [[sequenceValues objectAtIndex:pinCounter] intValue];
                NSInteger value = (state == FirmataCommandPinStatePWM || state == FirmataCommandPinStateOutput)?storedValue:-1;
                BDFirmataCommandCharacteristic *pin = [[BDFirmataCommandCharacteristic alloc] initWithPinState:state
                                                                                                         pinNumber:18
                                                                                                          pinValue:value];
                [self.sequence addObject:pin];
                pinCounter = pinCounter + 1;
            }break;
                
            case 19:
            {
                FirmataCommandPinState state = [[sequenceStates objectAtIndex:pinCounter] intValue];
                NSInteger storedValue = [[sequenceValues objectAtIndex:pinCounter] intValue];
                NSInteger value = (state == FirmataCommandPinStatePWM || state == FirmataCommandPinStateOutput)?storedValue:-1;
                BDFirmataCommandCharacteristic *pin = [[BDFirmataCommandCharacteristic alloc] initWithPinState:state
                                                                                                         pinNumber:19
                                                                                                          pinValue:value];
                [self.sequence addObject:pin];
                pinCounter = pinCounter + 1;
            }break;
                
            case 20:
            {
                FirmataCommandPinState state = [[sequenceStates objectAtIndex:pinCounter] intValue];
                NSInteger storedValue = [[sequenceValues objectAtIndex:pinCounter] intValue];
                NSInteger value = (state == FirmataCommandPinStatePWM || state == FirmataCommandPinStateOutput)?storedValue:-1;
                BDFirmataCommandCharacteristic *pin = [[BDFirmataCommandCharacteristic alloc] initWithPinState:state
                                                                                                        pinNumber:20
                                                                                                         pinValue:value];
                [self.sequence addObject:pin];
                pinCounter = pinCounter + 1;
            }break;
                
                //Time-delay
            default:
            {
                NSInteger delayFormat = [[sequenceDelayFormats objectAtIndex:delayCounter] intValue];
                NSInteger delayValue = [[sequenceDelayValues objectAtIndex:delayCounter] intValue];
                delayCounter = delayCounter + 1;
                
                BDFirmataCommandCharacteristic *pin = [[BDFirmataCommandCharacteristic alloc] initWithPinState:delayFormat
                                                                                                     pinNumber:100
                                                                                                      pinValue:delayValue];
                [self.sequence addObject:pin];
            }
                break;
        }

    }

    [defaults synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addCommand:(id)sender
{
    //Show pin options.
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Select Pin"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:
                                  @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7",
                                  @"8", @"9", @"10", @"13", @"A0", @"A1", @"A2",
                                  @"A3", @"A4", @"A5", @"MISO", @"MOSI", @"SCK", nil];
    
    actionSheet.tag = 300;
    [actionSheet showFromBarButtonItem:[self.toolbarItems objectAtIndex:2] animated:YES];
}

- (IBAction)addDelay:(id)sender
{
    BDFirmataCommandCharacteristic *delay =
    [[BDFirmataCommandCharacteristic alloc] initWithPinState:6
                                                   pinNumber:100
                                                    pinValue:1];
    
    [self.sequence addObject:delay];
    [self.tableView reloadData];
}

- (void) deleteSequence:(id)sender
{
    [self.sequence removeAllObjects];
    [self.tableView setEditing:NO animated:YES];
    [self.tableView reloadData];
    
    UIBarButtonItem *delay = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"delay.png"]
                                                              style:UIBarButtonItemStyleBordered
                                                             target:self
                                                             action:@selector(addDelay:)];
    
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                         target:self
                                                                         action:@selector(addCommand:)];
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                          target:self
                                                                          action:@selector(editSequence:)];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil];
    
    [self setToolbarItems:@[delay, space, add, space, edit]];
}

- (IBAction)editSequence:(id)sender
{
    if(self.tableView.isEditing)
    {
        [self.tableView setEditing:NO animated:YES];
        UIBarButtonItem *delay = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"delay.png"]
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(addDelay:)];

        UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addCommand:)];
        
        UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                              target:self
                                                                              action:@selector(editSequence:)];
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:nil];
        
        [self setToolbarItems:@[delay, space, add, space, edit]];
    }
    else
    {
        [self.tableView setEditing:YES animated:YES];
        UIBarButtonItem *trash = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                               target:self
                                                                               action:@selector(deleteSequence:)];
        
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                               target:self
                                                                               action:@selector(editSequence:)];
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                               action:nil];
        
        [self setToolbarItems:@[space, trash, space, done]];
    }
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.sequence.count == 0)
    {
        return 100;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(self.sequence.count == 0)
    {
        return @"No sequence\n\n\nAdd a command to start a new sequence";
    }
    
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.sequence.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDFirmataCommandCharacteristic *firmataCommand = [self.sequence objectAtIndex:indexPath.row];

    //PWM State
    if(firmataCommand.pinState == FirmataCommandPinStatePWM)
    {
        FirmataPWMCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PwmStateCell" forIndexPath:indexPath];
        cell.pinNumber.text = [SequencerTableViewController firmataPinNames:firmataCommand.pinNumber];
        cell.pinState.attributedText = [SequencerTableViewController firmataPinTypesString:firmataCommand.pinNumber
                                                                             forPinState:firmataCommand.pinState];
        [cell.pinValue addTarget:self
                          action:@selector(pwmUpdate:)
                forControlEvents:UIControlEventTouchUpInside];
        cell.secondPinValue.text = [NSString stringWithFormat:@"%ld", (long)firmataCommand.pinValue];
        cell.pinValue.tag = indexPath.row;
        return cell;
    }
    //Analog State
    else if(firmataCommand.pinState == FirmataCommandPinStateAnalog)
    {
        FirmataAnalogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnalogStateCell" forIndexPath:indexPath];
        cell.pinNumber.text = [SequencerTableViewController firmataPinNames:firmataCommand.pinNumber];
        cell.pinState.attributedText = [SequencerTableViewController firmataPinTypesString:firmataCommand.pinNumber
                                                                             forPinState:firmataCommand.pinState];
        if(firmataCommand.pinValue >= 0)
        {
            cell.pinValue.text = [NSString stringWithFormat:@"%ld", (long)firmataCommand.pinValue];
        }
        else
        {
            cell.pinValue.text = @"…";
            
        }
        
        cell.pinValue.tag = indexPath.row;
        return cell;
    }
    //Digital Out State
    else if(firmataCommand.pinState == FirmataCommandPinStateOutput)
    {
        FirmataDigitalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DigitalStateCell" forIndexPath:indexPath];
        cell.pinNumber.text = [SequencerTableViewController firmataPinNames:firmataCommand.pinNumber];
        cell.pinState.attributedText = [SequencerTableViewController firmataPinTypesString:firmataCommand.pinNumber
                                                                             forPinState:firmataCommand.pinState];
        [cell.pinValue addTarget:self
                          action:@selector(digitalSwitchToggled:)
                forControlEvents:UIControlEventTouchUpInside];
        [cell.pinValue setOn:firmataCommand.pinValue];
        cell.pinValue.tag = indexPath.row;
        return cell;
    }
    //Digital In State
    else if(firmataCommand.pinState == FirmataCommandPinStateInput)
    {
        FirmataAnalogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnalogStateCell" forIndexPath:indexPath];
        cell.pinNumber.text = [SequencerTableViewController firmataPinNames:firmataCommand.pinNumber];
        cell.pinState.attributedText = [SequencerTableViewController firmataPinTypesString:firmataCommand.pinNumber
                                                                             forPinState:firmataCommand.pinState];
        if(firmataCommand.pinValue >= 0)
        {
            cell.pinValue.text = [NSString stringWithFormat:@"%ld", (long)firmataCommand.pinValue];
        }
        else
        {
            cell.pinValue.text = @"…";
            
        }
        
        cell.pinValue.tag = indexPath.row;
        return cell;
    }
    //Time delay.
    else
    {
        TimeDelayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeDelayCell" forIndexPath:indexPath];
        cell.delayName.text = @"Time Delay";
        cell.delayFormat.attributedText = [SequencerTableViewController firmataPinTypesString:firmataCommand.pinNumber
                                                                                  forPinState:firmataCommand.pinState];
        [cell.delayValue addTarget:self
                            action:@selector(delayUpdate:)
                  forControlEvents:UIControlEventTouchUpInside];
        cell.secondDelayValue.text = [NSString stringWithFormat:@"%ld", (long)firmataCommand.pinValue];
        cell.delayValue.tag = indexPath.row;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Save new pin state for persistance.
    BDFirmataCommandCharacteristic *pin = (BDFirmataCommandCharacteristic *)[self.sequence objectAtIndex:indexPath.row];
    NSInteger pinNumber = pin.pinNumber;

    FirmataCommandPinState state = pin.pinState;
    NSInteger types = (state > 3)?4:[SequencerTableViewController firmataPinTypes:pinNumber];
    
    UIActionSheet *actionSheet;
    switch (types) {
        case 0:
        {
            NSString *pinName = [SequencerTableViewController firmataPinNames:pinNumber];
            NSString *message = [NSString stringWithFormat:@"Select state for %@", pinName];
            actionSheet = [[UIActionSheet alloc]
                           initWithTitle:message
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"Digital-Out", @"Digital-In", nil];
        }
            break;
            
        case 1:
        {
            NSString *pinName = [SequencerTableViewController firmataPinNames:pinNumber];
            NSString *message = [NSString stringWithFormat:@"Select state for %@", pinName];
            actionSheet = [[UIActionSheet alloc]
                           initWithTitle:message
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"Digital-Out", @"Digital-In", @"Analog", nil];
        }
            break;
            
        case 2:
        {
            NSString *pinName = [SequencerTableViewController firmataPinNames:pinNumber];
            NSString *message = [NSString stringWithFormat:@"Select state for %@", pinName];
            actionSheet = [[UIActionSheet alloc]
                           initWithTitle:message
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"Digital-Out", @"Digital-In", @"PWM", nil];
        }
            break;
            
        case 3:
        {
            NSString *pinName = [SequencerTableViewController firmataPinNames:pinNumber];
            NSString *message = [NSString stringWithFormat:@"Select state for %@", pinName];
            actionSheet = [[UIActionSheet alloc]
                           initWithTitle:message
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"Digital-Out", @"Digital-In", @"Analog", @"PWM", nil];
        }
            break;
        case 4:
        {
            actionSheet = [[UIActionSheet alloc]
                           initWithTitle:@"Select delay type"
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"Seconds", @"Minutes", nil];
        }
            break;
    }
    
    //Show pin/delay options.
    actionSheet.tag = (types > 3)?(400 + indexPath.row):(200 + indexPath.row);
    [actionSheet showInView:self.view];
}

//Removing Commands
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.sequence removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

//Sorting Commands
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    BDFirmataCommandCharacteristic *command = [self.sequence objectAtIndex:fromIndexPath.row];
    [self.sequence removeObjectAtIndex:fromIndexPath.row];
    [self.sequence insertObject:command atIndex:toIndexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark -
#pragma mark - Pin Updates Delegates
/****************************************************************************/
/*                             Pin Updates Delegates                        */
/****************************************************************************/
- (void) pwmUpdate:(id)sender
{
    UIButton *pinValue = (UIButton *)sender;
    UIAlertView *pwmValue = [[UIAlertView alloc] initWithTitle:@"PWM Value"
                                                       message:@"Please enter the PWM value."
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"Done", nil];
    
    pwmValue.alertViewStyle = UIAlertViewStylePlainTextInput;
    pwmValue.tag = pinValue.tag;
    [pwmValue textFieldAtIndex:0].delegate = self;
    [pwmValue show];
}

- (void) delayUpdate:(id)sender
{
    UIButton *pinValue = (UIButton *)sender;
    UIAlertView *delayValue = [[UIAlertView alloc] initWithTitle:@"Time Delay Value"
                                                       message:@"Please enter the time delay value."
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"Done", nil];
    
    delayValue.alertViewStyle = UIAlertViewStylePlainTextInput;
    delayValue.tag = pinValue.tag;
    [delayValue textFieldAtIndex:0].delegate = self;
    [delayValue show];
}

//Digital-Out
- (void) digitalSwitchToggled:(id)sender
{
    UISwitch *digitalValue = (UISwitch *)sender;
    
    //Update firmata command.
    BDFirmataCommandCharacteristic *digitalSwitchCommand = (BDFirmataCommandCharacteristic *)[self.sequence objectAtIndex:digitalValue.tag];
    digitalSwitchCommand.pinValue = digitalValue.on;
    
    //Send command.
    BDLeDiscoveryManager *leManager = [BDLeDiscoveryManager sharedLeManager];
    
    for(CBPeripheral *bleduino in leManager.connectedBleduinos)
    {
        BDFirmataService *firmataService = [[BDFirmataService alloc] initWithPeripheral:bleduino delegate:self];
        [firmataService writeFirmataCommand:digitalSwitchCommand];
    }
}

//PWM & Time Delay
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Update PWM value.
    if(buttonIndex == 1) //Done button.
    {
        NSInteger pwmValue = [[alertView textFieldAtIndex:0].text integerValue];
        
        if(pwmValue >= 0 && pwmValue <= 255)
        {
            //Update firmata command.
            BDFirmataCommandCharacteristic *pwmCommand = (BDFirmataCommandCharacteristic *)[self.sequence objectAtIndex:alertView.tag];
            pwmCommand.pinValue = pwmValue;

            [self.tableView reloadData];
        }
        else
        {
            UIAlertView *pwmValue = [[UIAlertView alloc] initWithTitle:@"Incorrect Value"
                                                               message:@"Value must be between 0 and 255"
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"Ok", nil];
            
            [pwmValue show];
        }
    }
}

//Analog and Digital-In
- (void)  firmataService:(BDFirmataService *)service
didReceiveFirmataCommand:(BDFirmataCommandCharacteristic *)firmataCommand
                   error:(NSError *)error
{
    BDFirmataCommandCharacteristic *command = [self.sequence objectAtIndex:firmataCommand.pinNumber];
    if(command.pinState == firmataCommand.pinState)
    {
        command.pinValue = firmataCommand.pinValue;
        [self.tableView reloadData];
    }
    
}

//Changing PIN state.
//Sequence is stored in full (pin values and states, time delays, and their order) before user leaves this module.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex < actionSheet.cancelButtonIndex)
    {
        //******************************************
        //***** Update pin state / Add new pin *****
        //******************************************
        if(actionSheet.tag < 400)
        {
            //**********************
            //***** Update pin *****
            //**********************
            if(actionSheet.tag < 300)
            {
                NSInteger index = (actionSheet.tag - 200);
                BDFirmataCommandCharacteristic *pin = (BDFirmataCommandCharacteristic *)[self.sequence objectAtIndex:index];
                NSInteger pinNumber = pin.pinNumber;
                NSInteger types = [SequencerTableViewController firmataPinTypes:pinNumber];
        
                switch (buttonIndex) {
                    case 0:
                        pin.pinState = FirmataCommandPinStateOutput;
                        pin.pinValue = 0;
                        break;
                    case 1:
                        pin.pinState = FirmataCommandPinStateInput;
                        pin.pinValue = -1;
                        break;
                    case 2:
                        if(types == 2)
                        {
                            pin.pinState = FirmataCommandPinStatePWM;
                            pin.pinValue = 0;
                        }
                        else
                        {
                            pin.pinState = FirmataCommandPinStateAnalog;
                            pin.pinValue = -1;
                        }
                        break;
                    case 3:
                        pin.pinState = FirmataCommandPinStatePWM;
                        pin.pinValue = 0;
                        break;
                }
            }
            
            //***********************
            //***** Add new pin *****
            //***********************
            else
            {
                BDFirmataCommandCharacteristic *pin = [[BDFirmataCommandCharacteristic alloc] initWithPinState:0
                                                                                                     pinNumber:buttonIndex
                                                                                                      pinValue:0];
                [self.sequence insertObject:pin atIndex:self.sequence.count];

            }
        }
        //*****************************
        //***** Update time-delay *****
        //*****************************
        else
        {
            NSInteger index = (actionSheet.tag - 400);
            BDFirmataCommandCharacteristic *delay = [self.sequence objectAtIndex:index];
            delay.pinState = 6 + buttonIndex;
        }
 
        //Update view.
        [self.tableView reloadData];
    }
}

- (IBAction)sendSequence:(id)sender
{
    //Add begin/end commands to sequence.
    NSMutableArray *finalSequence = [NSMutableArray arrayWithArray:self.sequence];
    [finalSequence insertObject:self.start atIndex:0];
    [finalSequence insertObject:self.end atIndex:finalSequence.count];
    
    //Send command.
    BDLeDiscoveryManager *leManager = [BDLeDiscoveryManager sharedLeManager];
    
    for(CBPeripheral *bleduino in leManager.connectedBleduinos)
    {
        for(BDFirmataCommandCharacteristic *command in finalSequence)
        {
            BDFirmataService *firmataService = [[BDFirmataService alloc] initWithPeripheral:bleduino delegate:self];
            [firmataService writeFirmataCommand:command];
        }
    }
}

//Helper Methods
+ (NSInteger) firmataPinTypes:(NSInteger)pinNumber
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger types = 0;
    switch (pinNumber) {
        case 0:
            types = (NSInteger)[defaults integerForKey:FIRMATA_PIN0_STATE_TYPES];
            break;
            
        case 1:
            types = (NSInteger)[defaults integerForKey:FIRMATA_PIN1_STATE_TYPES];
            break;
            
        case 2:
            types = (NSInteger)[defaults integerForKey:FIRMATA_PIN2_STATE_TYPES];
            break;
            
        case 3:
            types = (NSInteger)[defaults integerForKey:FIRMATA_PIN3_STATE_TYPES];
            break;
            
        case 4:
            types = (NSInteger)[defaults integerForKey:FIRMATA_PIN4_STATE_TYPES];
            break;
            
        case 5:
            types = (NSInteger)[defaults integerForKey:FIRMATA_PIN5_STATE_TYPES];
            break;
            
        case 6:
            types = (NSInteger)[defaults integerForKey:FIRMATA_PIN6_STATE_TYPES];
            break;
            
        case 7:
            types = (NSInteger)[defaults integerForKey:FIRMATA_PIN7_STATE_TYPES];
            break;
            
        case 8:
            types = (NSInteger)[defaults integerForKey:FIRMATA_PIN8_STATE_TYPES];
            break;
            
        case 9:
            types = (NSInteger)[defaults integerForKey:FIRMATA_PIN9_STATE_TYPES];
            break;
            
        case 10:
            types = (NSInteger)[defaults integerForKey:FIRMATA_PIN10_STATE_TYPES];
            break;
            
        case 11:
            types = (NSInteger)[defaults integerForKey:FIRMATA_PIN13_STATE_TYPES];
            break;
            
        case 12:
            types = (NSInteger)[defaults integerForKey:FIRMATA_PINA0_STATE_TYPES];
            break;
            
        case 13:
            types = (NSInteger)[defaults integerForKey:FIRMATA_PINA1_STATE_TYPES];
            break;
            
        case 14:
            types = (NSInteger)[defaults integerForKey:FIRMATA_PINA2_STATE_TYPES];
            break;
            
        case 15:
            types = (NSInteger)[defaults integerForKey:FIRMATA_PINA3_STATE_TYPES];
            break;
            
        case 16:
            types = (NSInteger)[defaults integerForKey:FIRMATA_PINA4_STATE_TYPES];
            break;
            
        case 17:
            types = (NSInteger)[defaults integerForKey:FIRMATA_PINA5_STATE_TYPES];
            break;
            
        case 18:
            types = (NSInteger)[defaults integerForKey:FIRMATA_PIN_MISO_STATE_TYPES];
            break;
            
        case 19:
            types = (NSInteger)[defaults integerForKey:FIRMATA_PIN_MOSI_STATE_TYPES];
            break;
            
        case 20:
            types = (NSInteger)[defaults integerForKey:FIRMATA_PIN_SCK_STATE_TYPES];
            break;
    }
    
    [defaults synchronize];
    return types;
}

+ (NSMutableAttributedString *) firmataPinTypesString:(NSInteger)pinNumber
                                          forPinState:(FirmataCommandPinState)state
{
    UIColor *selection = [UIColor colorWithRed:38/255.0 green:109/255.0 blue:235/255.0 alpha:1.0];
    NSString *digital   = @"Digital-Out • Digital-In";
    NSString *analog    = @"Digital-Out • Digital-In • Analog";
    NSString *pwm       = @"Digital-Out • Digital-In • PWM";
    NSString *allTypes  = @"Digital-Out • Digital-In • Analog • PWM";
    NSString *delay     = @"Seconds • Minutes";
    NSString *rangeString;
    
    NSMutableAttributedString *types_String;
    NSInteger types = (state > 3)?4:[SequencerTableViewController firmataPinTypes:pinNumber];
    switch (types) {
        case 0:
            types_String = [[NSMutableAttributedString alloc] initWithString:digital];
            rangeString = digital;
            break;
        case 1:
            types_String = [[NSMutableAttributedString alloc] initWithString:analog];
            rangeString = analog;
            break;
        case 2:
            types_String = [[NSMutableAttributedString alloc] initWithString:pwm];
            rangeString = pwm;
            break;
        case 3:
            types_String = [[NSMutableAttributedString alloc] initWithString:allTypes];
            rangeString = allTypes;
            break;
        case 4:
            types_String = [[NSMutableAttributedString alloc] initWithString:delay];
            rangeString = delay;
            break;
    }
    
    switch ((NSInteger)state) {
        case 0:
        {
            NSRange range = [rangeString rangeOfString:@"Digital-Out"];
            [types_String addAttribute:NSForegroundColorAttributeName value:selection range:range];
        }
            break;
        case 1:
        {
            NSRange range = [rangeString rangeOfString:@"Digital-In"];
            [types_String addAttribute:NSForegroundColorAttributeName value:selection range:range];
        }
            break;
        case 2:
        {
            NSRange range = [rangeString rangeOfString:@"Analog"];
            [types_String addAttribute:NSForegroundColorAttributeName value:selection range:range];
            
        }
            break;
        case 3:
        {
            NSRange range = [rangeString rangeOfString:@"PWM"];
            [types_String addAttribute:NSForegroundColorAttributeName value:selection range:range];
        }
            break;
        case 6:
        {
            NSRange range = [rangeString rangeOfString:@"Seconds"];
            [types_String addAttribute:NSForegroundColorAttributeName value:selection range:range];
        }
            break;
        case 7:
        {
            NSRange range = [rangeString rangeOfString:@"Minutes"];
            [types_String addAttribute:NSForegroundColorAttributeName value:selection range:range];
        }
            break;
    }
    return types_String;
}


+ (NSString *) firmataPinNames:(NSInteger)pinNumber
{
    NSString *name;
    if(pinNumber < 12)
    {
        if(pinNumber == 11) pinNumber = pinNumber+2; //Fix for pin 13.
        name = [NSString stringWithFormat:@"Pin %ld", (long)pinNumber];
    }
    else
    {
        switch (pinNumber) {
            case 12:
                name = @"Pin A0";
                break;
            case 13:
                name = @"Pin A1";
                break;
            case 14:
                name = @"Pin A2";
                break;
            case 15:
                name = @"Pin A3";
                break;
            case 16:
                name = @"Pin A4";
                break;
            case 17:
                name = @"Pin A5";
                break;
            case 18:
                name = @"Pin MISO";
                break;
            case 19:
                name = @"Pin MOSI";
                break;
            case 20:
                name = @"Pin SCK";
                break;
                
        }
    }
    
    return name;
}


#pragma mark -
#pragma mark - LeManager Delegate
/****************************************************************************/
/*                            LeManager Delegate                            */
/****************************************************************************/
//Disconnected from BLEduino and BLE devices.
- (void) didDisconnectFromBleduino:(CBPeripheral *)bleduino error:(NSError *)error
{
    NSString *name = ([bleduino.name isEqualToString:@""])?@"BLE Peripheral":bleduino.name;
    NSLog(@"Disconnected from peripheral: %@", name);
    
    //Verify if notify setting is enabled.
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL notifyDisconnect = [prefs integerForKey:SETTINGS_NOTIFY_DISCONNECT];
    
    if(notifyDisconnect)
    {
        //Push local notification.
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        //Is application on the foreground?
        if([[UIApplication sharedApplication] applicationState] != UIApplicationStateBackground)
        {
            NSString *message = [NSString stringWithFormat:@"The BLE device '%@' has disconnected to the BLEduino app.", name];
            //Application is on the foreground, store notification attributes to present alert view.
            notification.userInfo = @{@"title"  : @"BLEduino",
                                      @"message": message,
                                      @"disconnect": @"disconnect"};
        }
        
        //Present notification.
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
}


@end