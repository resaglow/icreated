//
//  EventDetailViewController.m
//  icreated
//
//  Created by Artem Lobanov on 25/12/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "EventDetailViewController.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTitle];
    
    self.textView.userInteractionEnabled = NO;
    self.textView.editable = NO;
    self.textView.text = self.textViewText;
}

- (void)initTitle {
    UILabel *titleView = [UILabel new];
    
    titleView.text = NSLocalizedString(@"Event details", @"");
    titleView.textColor = [UIColor whiteColor];
    titleView.font = [UIFont systemFontOfSize:25.f];
    
    CGRect desiredFrame = [titleView.text boundingRectWithSize:CGSizeMake(self.view.bounds.size.width, 0)
                                                       options:NSStringDrawingTruncatesLastVisibleLine
                                                    attributes:@{NSFontAttributeName:titleView.font}
                                                       context:nil];
    
    titleView.frame = CGRectMake(0, 0, desiredFrame.size.width, desiredFrame.size.height);
    
    self.navigationItem.titleView = titleView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
