//
//  NearbyTableViewController.m
//  VChat
//
//  Created by George Chen on 1/22/14.
//  Copyright (c) 2014 George Chen. All rights reserved.
//

#import "NearbyTableViewController.h"
#import "NearbyUserCell.h"
#import "ChattingViewController.h"
// #import <objc/runtime.h>

@interface NearbyTableViewController ()

@property (nonatomic, strong) NSMutableArray *nearbyUsers;

- (void)loadData;

@end

NSString* const CELL_IDENTIFIER = @"NearbyUserCell";

@implementation NearbyTableViewController

// for use with associatedObjects
//static char indexPathKey;

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
//    NSLog(@"calling view did load");
    [super viewDidLoad];
    self.title = @"Nearby";
    self.nearbyUsers = [[NSMutableArray alloc] init];
    [self loadData];
    
    UINib *customNib = [UINib nibWithNibName:CELL_IDENTIFIER bundle:nil];
    [self.tableView registerNib:customNib forCellReuseIdentifier:CELL_IDENTIFIER];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // obtain list of nearby folks
    // User's location

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NSLog(@"calling number of sections");
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"calling number of rows");
//    NSLog(@"%lu", (unsigned long)[self.nearbyUsers count]);
    // Return the number of rows in the section.
    return [self.nearbyUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"generating cell");
    NearbyUserCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    PFUser *user = self.nearbyUsers[indexPath.row];
    cell.userNameLabel.text = user.username;
//    cell.clickChatButton.tag = indexPath.row;
    
//    objc_setAssociatedObject(cell.userNameLabel, &indexPathKey, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

//    NSLog(@"%@", cell.userNameLabel.text);
    
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark Nearby User Cell delegate
-(void)onClickChatButton:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSLog(@"NearbyTableViewController : onClickChatButton - index is %d",indexPath.row);
    
    PFUser *user = self.nearbyUsers[indexPath.row];
    NSLog(@"Open conversation with %@",user.username);
    
    // open the chat window.
    ChattingViewController *cvc = [[ChattingViewController alloc] init];
    cvc.remoteUser = user;
    
    [self.navigationController pushViewController:cvc animated:YES];

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

//
// This code needs to be updated to NOT include the current user
//

- (void)loadData {
    PFUser *currentUser = [PFUser currentUser];
    PFGeoPoint *userGeoPoint = currentUser[@"location"];
    // Find users near a given location
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"location"
           nearGeoPoint:userGeoPoint
            withinMiles:10.0];
    userQuery.limit = 10;
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//                NSLog(@"%@", objects);
        NSLog(@"updating nearbyusers.  returned objects has %d entries",objects.count);
        
        // the first user is always the current user ??
        // should be, because of the sort-by-distance ordering
        
        NSMutableArray *objToAdd = [[NSMutableArray alloc] initWithArray:objects];
        [objToAdd removeObject:[objToAdd objectAtIndex:0]];
        NSLog(@"the objToAdd array has %d elements",objToAdd.count);
        
//        [self.nearbyUsers addObjectsFromArray:objects];
        [self.nearbyUsers addObjectsFromArray:objToAdd];
        NSLog(@"%@", self.nearbyUsers);
        //        for (PFUser *user in objects) {
        //            NSLog(@"%@", user.username);
        //            [self.nearbyUsers addObject:user];
        //        }
        //        NSLog(@"%@", [[self.nearbyUsers objectAtIndex:1] objectForKey:@"username"]);
        [self.tableView reloadData];
        
    }];
}

@end
