//
//  UIBarButtonItem+Menu.h
//  icreated
//
//  Created by Artem Lobanov on 23/04/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWRevealViewController/SWRevealViewController.h>

@protocol MenuViewController <NSObject>
- (SWRevealViewController *)revealViewController;
@end

@interface UIBarButtonItem (Menu)
+ (void)initMenuWithController:(UIViewController<MenuViewController> *)sender;
@end
