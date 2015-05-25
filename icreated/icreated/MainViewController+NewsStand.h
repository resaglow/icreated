//
//  MainViewController+NewsStand.h
//  icreated
//
//  Created by Artem Lobanov on 29/11/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController (NewsStand) <TableDataSourceDelegate, TableRefreshDataSourceDelegate>

- (void)initNewsStand;
- (void)refreshingMethod:(void (^)(void))handler;

enum MyViewTags {
    kDateTimeLabelTag = 2,
    kPlacemarkTag,
    kImageViewTag
};

@end
