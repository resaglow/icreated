//
//  UsersViewController.h
//  icreated
//
//  Created by Artem Lobanov on 18/12/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableRefreshDataSource.h"
#import "UIBarButtonItem+Menu.h"
#import "UserUpdater.h"
#import "User.h"

@interface UsersViewController : UIViewController <TableDataSourceDelegate, TableRefreshDataSourceDelegate, MenuViewController>
@property BOOL menuFlag;
@end
