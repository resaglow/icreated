//
//  UIBarButtonItem+Menu.m
//  icreated
//
//  Created by Artem Lobanov on 23/04/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

#import "UIBarButtonItem+Menu.h"

@implementation UIBarButtonItem (Menu)

+ (void)initMenuWithController:(UIViewController<MenuViewController> *)sender {
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = kFAMenu;
    [barButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"FontAwesome" size:kFABarButtonFontSize], NSFontAttributeName, nil]
                             forState:UIControlStateNormal];
    barButton.tintColor = [UIColor whiteColor];
    barButton.target = sender.revealViewController;
    barButton.action = @selector(revealToggle:);
    sender.navigationItem.leftBarButtonItem = barButton;
    
    [sender.view addGestureRecognizer:sender.revealViewController.panGestureRecognizer];
}

@end
