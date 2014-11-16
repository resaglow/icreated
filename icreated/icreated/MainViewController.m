//
//  MainViewController.m
//  icreated
//
//  Created by Artem Lobanov on 17/10/14.
//  Copyright (c) 2014 pispbsu. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"

@interface CustomMapView : MKMapView
@property (nonatomic, strong) SMCalloutView *calloutView;
@end


@interface MainViewController () <MKMapViewDelegate, UIGestureRecognizerDelegate, SMCalloutViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;
@property (strong, nonatomic) IBOutlet UITableView *newsStand;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) CustomMapView *map;
@property (nonatomic, retain) EventAnnotation *customAnnotation;
@property (nonatomic, strong) SMCalloutView *calloutView;

@end



@implementation MainViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuButton.target = self.revealViewController;
    self.menuButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\uf044"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:nil];
    
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIFont fontWithName:@"FontAwesome" size:26.0], NSFontAttributeName,
                                                                      nil]
                                       forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem.title = @"\uf0c9";
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(20, 0, -20, 0)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                    [UIFont fontWithName:@"FontAwesome" size:26.0], NSFontAttributeName,
                                                                    nil]
                                                          forState:UIControlStateNormal];
    
    [self viewDidLoadNewsStand];
    [self viewDidLoadMap];
    
    self.map.hidden = YES;
    
}


- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [self.view bringSubviewToFront:self.newsStand];
    }
    else if (sender.selectedSegmentIndex == 1) {
        self.map.hidden = NO;
        [self.view bringSubviewToFront:self.map];
    }
}


- (void)viewDidLoadNewsStand {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    [[EventUpdater fetchedResultsController] performFetch:nil];
    
    [self.newsStand setDataSource:self];
    [self.newsStand setDelegate:self];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshNewsStand)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.newsStand addSubview:self.refreshControl];
}

- (void)refreshNewsStand {
    [EventUpdater getEventsWithCompletionHandler:^(void) {
        [[EventUpdater fetchedResultsController] performFetch:nil];
        
        [self.newsStand reloadData];
        NSLog(@"Newsstand reloaded");
        
        [self.refreshControl endRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger secNum = [[[EventUpdater fetchedResultsController] sections] count];
    NSLog(@"%ld sections", (long)secNum);
    return secNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> secInfo = [[[EventUpdater fetchedResultsController] sections] objectAtIndex:section];
    NSLog(@"%lu rows", (unsigned long)[secInfo numberOfObjects]);
    return [secInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"eventCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    Event *event = [[EventUpdater fetchedResultsController] objectAtIndexPath:indexPath];
    cell.textLabel.text = event.desc;
    cell.detailTextLabel.text = event.date;
    
    return cell;
}






@synthesize map = _map;
@synthesize selectedAnnotationView = _selectedAnnotationView;
@synthesize customAnnotation = _customAnnotation;

- (void)viewDidLoadMap {
    self.map = [[CustomMapView alloc] initWithFrame:self.view.bounds];
    [self.map setDelegate:self];
    [self.map setShowsUserLocation:YES];
    [self.view addSubview:self.map];
    
    NSTimer* timer = [NSTimer timerWithTimeInterval:10.0 target:self selector:@selector(refreshMap) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

    [self refreshMap];
    [self testAnnotation];
    
    self.map.calloutView = self.calloutView;
}

- (void)testAnnotation {
    NSLog(@"Got in testAnnotation");
    self.customAnnotation = [[EventAnnotation alloc] init];
    self.customAnnotation.title = @"test";
    self.customAnnotation.subtitle = @"testDate";
    
    CLLocationCoordinate2D curCoordinate;
    curCoordinate.latitude = 38.6335;
    curCoordinate.longitude = -90.2045;
    self.customAnnotation.coordinate = curCoordinate;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.map addAnnotation:self.customAnnotation];
    });

    self.calloutView = [SMCalloutView platformCalloutView];
    self.calloutView.delegate = self;
    
    UIButton *disclosureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    disclosureButton.backgroundColor = [UIColor redColor];
    [disclosureButton setTitle:@"Normal" forState:UIControlStateNormal];
    [disclosureButton setTitle:@"Selected" forState:UIControlStateSelected];
    disclosureButton.frame = CGRectMake(0, 0, 60, 20);
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, 60, 20)];
    [textView setText:@"thisText"];
    
    UIView *contentView = [UIView new];
    contentView.frame = CGRectMake(0, 0, 200, 100);
    [contentView addSubview:disclosureButton];
    [contentView addSubview:textView];
    
    self.calloutView.contentView = contentView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    self.calloutView.calloutOffset = view.calloutOffset;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.calloutView presentCalloutFromRect:view.bounds inView:view constrainedToView:self.view animated:YES];
    });
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    NSLog(@"Got in view for annotation");
    if ([annotation isKindOfClass:[EventAnnotation class]]) {
        NSLog(@"Got in view for event annotation");
        NSString *identifier = @"eventAnnotation";
        MKPinAnnotationView* annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:identifier];
        }
        else {
            annotationView.annotation = annotation;
        }
        
        annotationView.image = [self eventPinWithSize:CGSizeMake(38, 38)];
        
        return annotationView;
    }
    
    return nil;
}

- (UIImage *)eventPinWithSize:(CGSize)size {
    NSString *pinSymbol = @"\uf041";
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [pinSymbol drawInRect:CGRectMake(0, 0, size.width, size.height)
           withAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],
                            NSFontAttributeName:[UIFont fontWithName:@"FontAwesome"
                                                                size:size.height]}];
    // It's supposed that height == width
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)refreshMap {
    NSLog(@"Request to refresh map");
    [EventUpdater getEventsWithCompletionHandler:^(void) {
        NSLog(@"Refreshing map");
        [[EventUpdater fetchedResultsController] performFetch:nil];
        
        for (NSInteger i = 0; i < [[[[EventUpdater fetchedResultsController] sections] objectAtIndex:0] numberOfObjects]; i++) {
            NSIndexPath *indexPath = [[NSIndexPath alloc] init];
            indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            Event *curEvent = [[EventUpdater fetchedResultsController] objectAtIndexPath:indexPath];
            
            
            EventAnnotation *curAnnotation = [[EventAnnotation alloc] init];
            
            curAnnotation.title = curEvent.desc;
            curAnnotation.subtitle = curEvent.date;
            
            NSLog(@"%@, %@, %@", curEvent.desc, curEvent.date, curEvent.latitude);
            
            CLLocationCoordinate2D curCoordinate;
            curCoordinate.latitude = curEvent.latitude.doubleValue;
            curCoordinate.longitude = curEvent.longitude.doubleValue;
            curAnnotation.coordinate = curCoordinate;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.map addAnnotation:curAnnotation];
            });
        }
        
        NSLog(@"Map refresh done");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end


@implementation CustomMapView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *calloutMaybe = [self.calloutView hitTest:[self.calloutView convertPoint:point fromView:self]
                                           withEvent:event];
    if (calloutMaybe) return calloutMaybe;
    
    return [super hitTest:point withEvent:event];
}

@end