//
//  MapCalloutDataSource.m
//  icreated
//
//  Created by Artem Lobanov on 20/04/15.
//  Copyright (c) 2015 pispbsu. All rights reserved.
//

// Callout configs
#define kCalloutStandardInfoWidth 60
#define kCalloutStandardInfoHeight 20
#define kCalloutStandardIconSide 20

#define kCalloutTextHeight 60

#define kCalloutWidth 180
#define kCalloutHeight 80

#import "MapCalloutDataSource.h"
#import "NSDate+RFC1123.h"

@implementation MapCalloutDataSource

- (id)initWithMapView:(MKMapView *)mapView {
    self = [super initWithMapView:mapView];
    
    [self initCalloutView];
    self.mapView.calloutView = self.calloutView;
    
    return self;
}


- (void)initCalloutView {
    self.calloutView = [SMCalloutView platformCalloutView];
    self.calloutView.delegate = self;
    
    UIFont *fontAwesome = [UIFont fontWithName:@"FontAwesome" size:kFAStandardFontSize];
    UIFont *smallFont = [UIFont systemFontOfSize:kFASmallFontSize];
    
    
    UILabel *category = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kCalloutStandardIconSide, kCalloutStandardIconSide)];
    
    UIButton *people = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    people.frame = CGRectMake(kCalloutStandardIconSide, 0, kCalloutStandardInfoWidth + kCalloutStandardIconSide, kCalloutStandardIconSide);
    self.calloutPeopleCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kCalloutStandardInfoWidth, kCalloutStandardInfoHeight)];
    self.calloutPeopleCount.font = smallFont;
    UILabel *peopleIcon = [[UILabel alloc] initWithFrame:CGRectMake(kCalloutStandardInfoWidth, 0, kCalloutStandardIconSide, kCalloutStandardIconSide)];
    peopleIcon.font = fontAwesome;
    peopleIcon.text = kFAPeople;
    [people addSubview:self.calloutPeopleCount];
    [people addSubview:peopleIcon];
    
    UIButton *time = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    time.frame = CGRectMake(2 * kCalloutStandardIconSide + kCalloutStandardInfoWidth, 0, kCalloutStandardInfoWidth + kCalloutStandardIconSide, kCalloutStandardIconSide);
    self.calloutTimeText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kCalloutStandardInfoWidth, kCalloutStandardInfoHeight)];
    self.calloutTimeText.font = smallFont;
    UILabel *timeIcon = [[UILabel alloc] initWithFrame:CGRectMake(kCalloutStandardInfoWidth, 0, kCalloutStandardIconSide, kCalloutStandardIconSide)];
    timeIcon.font = fontAwesome;
    timeIcon.text = kFATime;
    [time addSubview:self.calloutTimeText];
    [time addSubview:timeIcon];
    
    UIButton *higherView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    higherView.frame = CGRectMake(0, 0, kCalloutWidth, kCalloutStandardInfoHeight);
    [higherView addSubview:category];
    [higherView addSubview:people];
    [higherView addSubview:time];
    
    self.calloutTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, kCalloutStandardInfoHeight, kCalloutWidth, kCalloutTextHeight)];
    self.calloutTextView.backgroundColor = [UIColor clearColor];
    self.calloutTextView.editable = NO;
    self.calloutTextView.userInteractionEnabled = NO;
    self.calloutTextView.font = smallFont;
    
    UIButton *contentView = [UIButton new];
    contentView.frame = CGRectMake(0, 0, kCalloutWidth, kCalloutHeight);
    [contentView addSubview:self.calloutTextView];
    [contentView addSubview:higherView];
    
    self.calloutView.contentView = contentView;
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    EventAnnotation *annotation = (EventAnnotation *)view.annotation;
    self.delegate.curAnnotation = annotation;
    self.calloutTextView.text = annotation.title;
    self.calloutTimeText.text = [annotation.date RFC1123String];
    
    CGFloat fixedWidth = self.calloutTextView.frame.size.width;
    CGSize newSize = [self.calloutTextView sizeThatFits:CGSizeMake(fixedWidth, CGFLOAT_MAX)];
    
    CGRect newFrame = self.calloutTextView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    
    if (newFrame.size.height <= 80.0f) {
        CGFloat textViewsHeightDiff = self.calloutTextView.frame.size.height - newFrame.size.height;
        self.calloutTextView.frame = newFrame;
        self.calloutView.contentView.frame = CGRectMake(0,
                                                        0,
                                                        self.calloutView.contentView.frame.size.width,
                                                        self.calloutView.contentView.frame.size.height - textViewsHeightDiff);
    }
    
    self.calloutView.calloutOffset = view.calloutOffset;
    
    [self.calloutView presentCalloutFromRect:view.bounds inView:view constrainedToView:self.delegate.view animated:YES];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    [self.calloutView dismissCalloutAnimated:YES];
}


@end
