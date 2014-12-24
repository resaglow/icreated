//
//  MenuViewController.h
//  icreated
//
//  Created by Artem Lobanov on 17/10/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface MenuViewController : UITableViewController <UITableViewDataSource, UITabBarDelegate, SWRevealViewControllerDelegate>

- (void)reloadMenu;

@end
