//
//  AddEventViewController+PhotoPicker.h
//  icreated
//
//  Created by Artem Lobanov on 30/11/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "AddEventViewController.h"

@interface AddEventViewController (PhotoPicker) <UICollectionViewDataSource, UICollectionViewDelegate>

- (void)showPhotoPicker;

@end
