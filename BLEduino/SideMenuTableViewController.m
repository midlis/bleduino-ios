//
//  SideMenuTableViewController.m
//  BLEduino
//
//  Created by Ramon Gonzalez on 11/12/13.
//  Copyright (c) 2013 Kytelabs. All rights reserved.
//

#import "SideMenuTableViewController.h"
#import "ModulesCollectionViewController.h"

@implementation SideMenuTableViewController
{
    NSArray *_titles;
    NSArray *_images;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _titles = @[@"Modules", @"BLE Manager", @"Settings", @"BLEduino Hardware", @"Kytelabs"];
    _images = @[@"modules.png", @"manager.png", @"settings.png", @"hardware.png", @"contact.png"];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:
                                  CGRectMake(0, (self.view.frame.size.height - 54 * 7) / 2.0f, self.view.frame.size.width, 54 * 10)
                                                              style:UITableViewStyleGrouped];
        
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        
        tableView.backgroundView = nil;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView.scrollsToTop = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *navigationController = (UINavigationController *)self.sideMenuViewController.contentViewController;
    
    //App functionality, i.e. Modules, BLE Manager, Settings.
    if(indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
                navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"modulesController"]];
                [self.sideMenuViewController hideMenuViewController];
                break;
            case 1:
                navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"bleController"]];
                [self.sideMenuViewController hideMenuViewController];
                break;
            case 2:
                navigationController.viewControllers = @[[self.storyboard instantiateViewControllerWithIdentifier:@"settingsController"]];
                [self.sideMenuViewController hideMenuViewController];
                break;
        }
    }
    
    //BLEduino hardware.
    else if (indexPath.section == 1)
    {
        //Open bleduino.cc
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://bleduino.cc"]];
    }
    
    //Contact Kytelabs
    else if (indexPath.section == 2)
    {
        if([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            [controller setSubject:@"Hello Kytelabs from BLEduino App"];
            [controller setToRecipients:@[@"help@bleduino.cc"]];
            if(controller) [self presentViewController:controller
                                              animated:YES
                                            completion:nil];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Email"
                                                            message:@"Your phone is not configure for sending emails. Add your email account on settings."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }

}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    int rows = 0;
    switch (sectionIndex) {
        case 0:
            rows = 3;
            break;
        case 1:
            rows = 1;
            break;
        case 2:
            rows = 1;
            break;
    }
        
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;

    switch (section) {
        case 0:
            title = @"General";
            break;
        case 1:
            title = @"Hardware";
            break;
        case 2:
            title = @"Contact";
            break;
    }
    
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor blueColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    //Configure cell.
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = _titles[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:_images[indexPath.row]];
            break;
        case 1:
            cell.textLabel.text = _titles[indexPath.row+3];
            cell.imageView.image = [UIImage imageNamed:_images[indexPath.row+3]];
            break;
        case 2:
            cell.textLabel.text = _titles[indexPath.row+4];
            cell.imageView.image = [UIImage imageNamed:_images[indexPath.row+4]];
            break;
    }

    return cell;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    NSString *title;
//    
//    switch (section) {
//        case 0:
//            title = @"GENERAL";
//            break;
//        case 1:
//            title = @"HARDWARE";
//            break;
//        case 2:
//            title = @"CONTACT";
//            break;
//    }
//    
//    /* Create custom view to display section header... */
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, tableView.frame.size.width - 100, 18)];
//    [label setFont:[UIFont boldSystemFontOfSize:12]];
//    label.textColor = [UIColor whiteColor];
//    [label setText:title];
//    return label;
//}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController");
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController");
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController");
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController");
    
    UINavigationController *nav = (UINavigationController *)sideMenu.contentViewController; //Content controller.
    [nav.topViewController performSelector:@selector(showStatusBar)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
