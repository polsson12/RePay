//
//  UIViewController+ShowDebtViewController.h
//  RePay
//
//  Created by Philip Olsson on 2014-12-08.
//  Copyright (c) 2014 Philip Olsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>


@interface Debt : NSObject
@property NSString* fromName;
@property NSString* fromFbId;
@property NSString* message;
@property NSString* toName;
@property NSString* toFbId;
@property NSNumber* amount;
@property BOOL      approved;
@property NSDate*   createdAt;

@end

@implementation Debt

- (instancetype)init
{
    self = [super init];
    if (self) {
        //TODO: what here? if anything at al?
    }
    return self;
}

@end


@interface ShowDebtViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>

//Table view
@property (weak, nonatomic) IBOutlet UITableView *showDeptsTableView;


@property (strong, nonatomic) NSMutableArray *debts;
@property (strong, nonatomic) NSMutableArray *debtsToPerson;
@property (strong, nonatomic) NSMutableArray *uniqueFbIds;



- (void) fetchDeptsForUser;
- (void) sortDepts;

@end