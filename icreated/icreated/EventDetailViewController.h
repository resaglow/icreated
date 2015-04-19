//
//  EventDetailViewController.h
//  icreated
//
//  Created by Artem Lobanov on 25/12/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailViewController : UIViewController

@property (strong, retain, nonatomic) IBOutlet UITextView *textView;
@property NSString *textViewText;

@end
