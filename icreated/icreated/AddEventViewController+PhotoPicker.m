//
//  AddEventViewController+PhotoPicker.m
//  icreated
//
//  Created by Artem Lobanov on 30/11/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "AddEventViewController+PhotoPicker.h"

@implementation AddEventViewController (PhotoPicker)

- (void)showPhotoPicker {
    [self.takeController takePhotoOrChooseFromLibrary];
    self.accessoryViewEnabledSubFlag = NO;
}

// FDTakeDelegate method
- (void)takeController:(FDTakeController *)controller didCancelAfterAttempting:(BOOL)madeAttempt {
    self.accessoryViewEnabledSubFlag = YES;
}

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info {
    [self.photos addObject:photo];
    [self.photosView reloadData];
    
    self.photosViewHeight.constant = NORMAL_VIEW_HEIGHT;
    [(UIButton *)self.accessoryButtons[3] setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

// UICollectionViewDataSource methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    
    UIImage *curImage = (UIImage *)self.photos[indexPath.row];
    UIImageView *cellImageView = (UIImageView *)[cell viewWithTag:100];
    cellImageView.image = curImage;
    
    [cell.layer setBorderWidth:2.0f];
    [cell.layer setBorderColor:[UIColor redColor].CGColor];
    [cell.layer setCornerRadius:5.0f];
    
    return cell;
    
}

@end