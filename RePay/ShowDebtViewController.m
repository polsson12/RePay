//
//  UIViewController+ShowDebtViewController.m
//  RePay
//
//  Created by Philip Olsson on 2014-12-08.
//  Copyright (c) 2014 Philip Olsson. All rights reserved.
//

#import "ShowDebtViewController.h"
#import "DebtDetailsViewController.h"


@interface ShowDebtViewController ()

@end

@implementation ShowDebtViewController

@synthesize debts = _debts;
@synthesize debtsToPerson = _debtsToPerson;
@synthesize uniqueFbIds = _uniqueFbIds;




- (void)viewDidLoad {

    //Fetch depts..
    self.showDeptsTableView.hidden = YES;
    _debts = nil;
    [self fetchDeptsForUser];
}






#pragma mark table view methods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

        return [_debtsToPerson count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //NSLog(@"Inne i cell for row at index path");
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (tableView == _showDeptsTableView) {
        NSString* name;
        NSInteger index = 0;
        if([[[_debtsToPerson objectAtIndex:indexPath.row] objectAtIndex:0] count] == 0){
            NSLog(@"Kommer hit.........");
            index = 1;
        }
        //If the debt objects toFbId string is not equal to the current user fbId we know that the text in the cell should be toName
        
        
        /*if (![[[[[_debtsToPerson objectAtIndex:indexPath.row] objectAtIndex:index] objectAtIndex:0] toFbId] isEqualToString:[[PFUser currentUser] objectForKey:@"fbId"]]) {
            name = [[[[_debtsToPerson objectAtIndex:indexPath.row] objectAtIndex:0] objectAtIndex:0] toName];
        }else{ //Else we know that the text in the cell should be fromName
            name = [[[[_debtsToPerson objectAtIndex:indexPath.row] objectAtIndex:0] objectAtIndex:0] fromName];
        }
        BOOL app = YES;
        for (int i = 0; i < [[_debtsToPerson objectAtIndex:indexPath.row] count]; i++) {
            for (int j = 0; j < [[[_debtsToPerson objectAtIndex:indexPath.row] objectAtIndex:i] count]; j++) {
                //NSLog([[[[_debtsToPerson objectAtIndex:indexPath.row] objectAtIndex:i] objectAtIndex:j] approved] ? @"Yes" : @"No");
                if(![[[[_debtsToPerson objectAtIndex:indexPath.row] objectAtIndex:i] objectAtIndex:j] approved]){
                    app = NO;
                    break;
                }
            }
            
            if (!app) {
                NSLog(@"breakar.........");
                break;
            }
        }*/
        if (app) {
            cell.textLabel.textColor  = [UIColor colorWithRed:11.0/255.0 green:96.0/255.0 blue:254.0/255.0 alpha:1];
        }else{
            cell.textLabel.textColor  = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        }
        cell.textLabel.text = name;

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"toDebtDeatilsViewController" sender:[_debtsToPerson objectAtIndex:indexPath.row ]];
}

/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //[_objects removeObjectAtIndex:indexPath.row];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        NSLog(@"Unhandled editing style! %ld", editingStyle);
    }
}*/


/*
 * Fetch the depts for the current user
 */

- (void) fetchDeptsForUser{
    
    PFQuery *toMe = [PFQuery queryWithClassName:@"Debts"];
    [toMe whereKey:@"toFbId" equalTo:[[PFUser currentUser] objectForKey:@"fbId"]];

    PFQuery *fromMe = [PFQuery queryWithClassName:@"Debts"];
    [fromMe whereKey:@"fromFbId" equalTo:[[PFUser currentUser] objectForKey:@"fbId"]];

    PFQuery *query = [PFQuery orQueryWithSubqueries:@[toMe,fromMe]];

    
    NSLog(@"User fbId: %@",[[PFUser currentUser] objectForKey:@"fbId"]);
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu objects.", (unsigned long)objects.count);

            _debts = [NSMutableArray arrayWithCapacity:objects.count];
            
            _uniqueFbIds = [[NSMutableArray alloc] init];
            for (PFObject *object in objects) {
                Debt* d = [[Debt alloc] init];
                d.fromName = object [@"fromName"];
                d.fromFbId = object [@"fromFbId"];
                d.message = object [@"message"];
                d.toName = object [@"toName"];
                d.toFbId = object [@"toFbId"];
                d.amount = object [@"amount"];
                d.approved = [object [@"approved"] boolValue];
                d.createdAt = [object createdAt];
                [_debts addObject:d];
                //NSLog(d.approved ? @"Yes" : @"No");

                //NSLog(@"object id: %@", [object objectId]);
                if(![_uniqueFbIds containsObject:d.fromFbId] && !([d.fromFbId isEqualToString:[[PFUser currentUser] objectForKey:@"fbId"]])) {
                    [_uniqueFbIds addObject:d.fromFbId];
                }
                if (![_uniqueFbIds containsObject:d.toFbId] && !([d.toFbId isEqualToString:[[PFUser currentUser] objectForKey:@"fbId"]])) {
                    [_uniqueFbIds addObject:d.toFbId];
                }
              
            }
            NSLog(@"_uniqueFbIds har nu storleken: %lu ", (unsigned long)[_uniqueFbIds count]);
            NSLog(@"_depts har nu storleken: %lu ", (unsigned long)[_debts count]);
            if ([_uniqueFbIds count] > 0) { // We have depts.. Do the processing for them and show tableview..
                self.showDeptsTableView.hidden = NO;
                [self sortDepts];
                [self.showDeptsTableView reloadData];
            }else{
                //TODO: View that says no debts..
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Inga skulder"
                                                                message:@"Du har inga nuvarande skulder"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }

        } else {
            //TODO: No internet connection?
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void) sortDepts{
    //NSMutableArray* arr = [[NSMutableArray alloc] init];
   _debtsToPerson = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_uniqueFbIds count];i++) {
        NSMutableArray* arr = [[NSMutableArray alloc] init];
        
        NSString *attributeName1  = @"toFbId";
        NSString *attributeValue = [_uniqueFbIds objectAtIndex:i];
        
        //Debts from me to someone else with fbId: attributeValue
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"%K like %@",attributeName1 , attributeValue];
        [arr addObject:[_debts filteredArrayUsingPredicate:predicate1]];
        
        //Debts to me from someone else with fbId: attributeValue
        NSString *attributeName2  = @"fromFbId";
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"%K like %@",attributeName2, attributeValue];
        [arr addObject:[_debts filteredArrayUsingPredicate:predicate2]];
        NSLog(@"Storlekten på arr: %lu", (unsigned long)[arr count]);
        if ([[arr objectAtIndex:0] count] == 0) {
            NSLog(@"Index 0 har storleken 0");
        }
        
        [_debtsToPerson addObject:arr];

        /*
        
        NSLog(@"Storlekten på _debtsToPerson: %lu", (unsigned long)[_debtsToPerson count]);
    
        //NSLog(@"Storlek: %@",[[[[_debtsToPerson objectAtIndex:0] objectAtIndex:0] objectAtIndex:0] amount]);

        
        for (int i = 0; i < [_debtsToPerson count]; i++) {
            for (int j = 0; j < [[_debtsToPerson objectAtIndex:i] count]; j++) {
                for (int k = 0; k < [[[_debtsToPerson objectAtIndex:i] objectAtIndex:j] count]; k++) {
                    NSLog(@"Skuld: %@",[[[[_debtsToPerson objectAtIndex:i] objectAtIndex:j] objectAtIndex:k] toName]);

                }
                NSLog(@"------------");
            }
        }
         */
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqual: @"Inga skulder"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toDebtDeatilsViewController"]) {
        DebtDetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.debts = sender;
        
    }
}


@end








