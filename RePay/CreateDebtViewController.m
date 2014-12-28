//
//  UIViewController+CreateDebtViewController.m
//  RePay
//
//  Created by Philip Olsson on 2014-12-02.
//  Copyright (c) 2014 Philip Olsson. All rights reserved.
//

#import "CreateDebtViewController.h"




@interface CreateDebtViewController ()
@end

@implementation CreateDebtViewController

@synthesize friendIds = _friendIds; //Depricated
@synthesize friendNames = _friendNames; //Depricated
@synthesize friendInfo = _friendInfo;

- (void)viewDidLoad {
    
    self.searchResultTableView.hidden = YES;
    
    //Message
    self.Message.layer.borderColor = [[UIColor grayColor] CGColor];
    self.Message.layer.borderWidth = 1.0;
    self.Message.layer.cornerRadius = 8;
    
    //Amount
   // self.Amount.layer.borderColor = [[UIColor grayColor] CGColor];
   // self.Amount.layer.borderWidth = 1.0;
    //self.Amount.layer.cornerRadius = 8;
    
    self.sendToPerson = nil;
    
    //To Person
    //self.DeptToPerson.layer.cornerRadius = 5.0f;
    //self.DeptToPerson.masksToBounds = NO;
    self.DeptToPerson.layer.borderWidth = .5f;
    //self.DeptToPerson.layer.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:0.3].CGColor;
    
    //self.DeptToPerson.layer.shadowColor = [UIColor orangeColor].CGColor;
    //self.DeptToPerson.layer.shadowOpacity = 0.4;
    //self.DeptToPerson.layer.shadowRadius = 5.0f;
    
    
    
    //View controller background
    
    
    
    
    
    
    
    
    
    
    [self getAllFbFriendsOfUserUsingApp];
}


- (IBAction)SendDept:(id)sender {
    
    //NSLog(@"Skickar skuld...");
    
    if (self.sendToPerson == nil) { //Must specify a person
        UIAlertView *mustSelectPerson = [[UIAlertView alloc]
         initWithTitle:@"Välj en person!" message:@"Du måste välja en person att skicka skulden till" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [mustSelectPerson show];
    }else if([self.Amount.text isEqual:@""] || [self.Amount.text isEqual:@"0"]) { //Must specify a amount
        UIAlertView *mustSetAmount = [[UIAlertView alloc]
                                         initWithTitle:@"Ange belopp" message:@"Du måste ange ett giltigt belopp" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [mustSetAmount show];
    }else{
        NSInteger amount = [self.Amount.text intValue];
        if (amount == 0) { //If non-valid text is typed
            UIAlertView *mustSetAmount = [[UIAlertView alloc]
                                          initWithTitle:@"Ange belopp" message:@"Du måste ange ett giltigt belopp" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [mustSetAmount show];
        }else{
            //Send debt to database..
           // NSLog(@"User fb name: %@   User fbId: %@",[[PFUser currentUser] objectForKey:@"fbName"],[[PFUser currentUser] objectForKey:@"fbId"]);
            NSString * toPerson = @"Vill du skicka till personen: ";
            NSString * name = self.sendToPerson.name;
            NSString * mess = [toPerson stringByAppendingString:name];
            mess = [mess stringByAppendingString:@"?"];
            UIAlertView *confirm = [[UIAlertView alloc]
                                          initWithTitle:@"Bekräfta skulden" message:mess delegate:self cancelButtonTitle:@"Nej" otherButtonTitles:@"Ja",nil];
            [confirm show];
        }
    }

    
    
    
}

- (IBAction)dissMissKeyboardOnTap:(id)sender {
    [[self view] endEditing:YES];
}


/* Get all Friends of the users Facebook ID's
 */
- (void) getAllFbFriendsOfUserUsingApp {
    /*NSArray *arr = [[FBSession activeSession] declinedPermissions];
     
     for (NSString *permissions in arr) {
     NSLog(@"Declined permission: %@" , permissions);
     }*/


    
    //TODO: Fix so that if a person denied permission when logging in, make a call to re-approve permission
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            //NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            //NSMutableArray *friendNames = [NSMutableArray arrayWithCapacity:friendObjects.count];
            
            //_friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            //_friendNames = [NSMutableArray arrayWithCapacity:friendObjects.count];
            
            //_friendIds = [[NSMutableArray alloc ] initWithCapacity:friendObjects.count];
            //_friendNames = [NSMutableArray arrayWithCapacity:friendObjects.count];

            _friendInfo = [NSMutableArray arrayWithCapacity:friendObjects.count];

            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                //[_friendIds addObject:[friendObject objectForKey:@"id"]];
                //[_friendNames addObject:[friendObject objectForKey:@"name"]];
                
                Person *person = [[Person alloc] init];
                person.name = [friendObject objectForKey:@"name"];
                person.fbId = [friendObject objectForKey:@"id"];
                [_friendInfo addObject:person];
            }

            NSLog(@"Antalet fb vänner: %lu", (unsigned long)[_friendInfo count]);
            for (size_t i = 0; i < [_friendInfo count]; i++) {
                Person *p = [_friendInfo objectAtIndex:i];
                NSLog(@"Namn: %@   fbId: %@", p.name, p.fbId);
            
            }
            
            /*for (size_t i = 0; i < [_friendIds count]; i++) {
                NSLog(@"\nid: %@  name:%@", [_friendIds objectAtIndex:i], [_friendNames objectAtIndex:i]);
            }*/
            /*
             // Construct a PFUser query that will find friends whose facebook ids
             // are contained in the current user's friend list.
             PFQuery *friendQuery = [PFUser query];
             [friendQuery whereKey:@"fbId" containedIn:friendIds];
             
             // findObjects will return a list of PFUsers that are friends
             // with the current user
             NSArray *friendUsers = [friendQuery findObjects];
             */
        }
    }];
}

#pragma mark table view methods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"Kommer hit...2");
    //NSLog(@"Inne i number of rows in section");
    if (tableView == _searchResultTableView) {
        return [self.searchResults count];
    }else   //TODO: Is this correct??
        return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Kommer hit...1");
    //NSLog(@"Inne i cell for row at index path");
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    //TODO: Could it possibly be another tableView?? I dont think so. :o
    if (tableView == _searchResultTableView) {
        //cell.textLabel.text = [[self.searchResults objectAtIndex:indexPath.row]];
        cell.textLabel.text = [[self.searchResults objectAtIndex:indexPath.row] name];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString *name = [self.searchResults objectAtIndex:indexPath.row];
    /*UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Row Selected" message:name delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    */
    /*UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
     */
    // Display Alert Message
    //[messageAlert show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.searchResultTableView.hidden = YES;
    [self deptToPerson:indexPath.row];
    
}

#pragma mark Search methods

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    ///NSLog(@"search text length is: %lu", (unsigned long)[searchText length]);
    if ([searchText length] == 0) {
       // NSLog(@"search text length är 0");
        self.searchResultTableView.hidden = YES;
    }else{
        self.searchResultTableView.hidden = NO;
        //NSLog(@"Texten ändrades till: %@", searchText);


        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name beginswith[c] %@", searchText];
        
        
        self.searchResults = [self.friendInfo filteredArrayUsingPredicate:predicate];
        
        /*self.searchResults = [self.friendNames filteredArrayUsingPredicate:predicate];
        if ([self.searchResults count] > 0) {
            for (NSString *name in (self.searchResults)) {
                NSLog(@"Results från sökningen: %@",name);
            }
        }*/
        [self.searchResultTableView reloadData];
    }
}

- (void) deptToPerson:(NSInteger) index {
    NSString *to = @"Till: ";

    NSString *person = [[self.searchResults objectAtIndex:index] name];
    self.DeptToPerson.text = [to stringByAppendingString:person];
    
    self.sendToPerson = [[Person alloc] init];
    self.sendToPerson.fbId = [[self.searchResults objectAtIndex:index] fbId];
    self.sendToPerson.name = person;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([alertView.title isEqual: @"Bekräfta skulden"]) {
        if (buttonIndex == 0) {
            NSLog(@"Cancel...");
        }else if (buttonIndex == 1){
            NSLog(@"Skicka skuld...");
            [self sendDebtToDataBase];
        }
    }
}

- (void) sendDebtToDataBase{
    
    PFObject *debt = [PFObject objectWithClassName:@"Debts"];
    debt[@"fromName"] = [[PFUser currentUser] objectForKey:@"fbName"];
    debt[@"fromFbId"] = [[PFUser currentUser] objectForKey:@"fbId"];
    debt[@"amount"] = [NSNumber numberWithInt:[self.Amount.text intValue]];
    debt[@"approved"] = @NO;
    debt[@"message"] = self.Message.text;
    debt[@"toName"] = self.sendToPerson.name;
    debt[@"toFbId"] = self.sendToPerson.fbId;
    
    //testObject[@"foo"] = @"bar";
    [debt saveInBackground];
    [self.navigationController popViewControllerAnimated:YES];

}




@end










