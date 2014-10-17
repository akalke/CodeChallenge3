//
//  StationsListViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "StationsListViewController.h"
#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface StationsListViewController () <UITabBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic) NSArray *bikeStation;
@property CLLocationManager *myLocationManager;

@end

@implementation StationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadJSONData];
    [self.myLocationManager startUpdatingLocation];

    // Do any additional setup after loading the view.
}


#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // TODO:
    NSLog(@"Stations: %lu", (unsigned long)self.bikeStation.count);
    return self.bikeStation.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [[self.bikeStation objectAtIndex: indexPath.row] valueForKey:@"stAddress1"];
    cell.detailTextLabel.text = [NSString stringWithFormat: @"Avaialble Bikes: %@", [[self.bikeStation objectAtIndex: indexPath.row] valueForKey:@"availableBikes"]];
    return cell;
}

-(void)loadJSONData{
    NSURL *url = [NSURL URLWithString: @"http://www.divvybikes.com/stations/json/"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        //Confirm JSON response
//        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"station Data: %@", jsonString);

        NSError *jsonError = nil;
        NSDictionary *bikeStationDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error: &jsonError];
        //NSLog(@"%@", self.bikeStationDictionary);
        self.bikeStation = [bikeStationDictionary objectForKey:@"stationBeanList"];

        [self.tableView reloadData];
         }];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ToMapSegue"]){
        UINavigationController * navigationController = segue.destinationViewController;
        MapViewController *myMapViewController = (MapViewController *) navigationController;
        myMapViewController.name = [self.bikeStation valueForKey:@"stAddress1"];
        //myMapViewController.latitude = [[self.bikeStation valueForKey:@"latitude"] doubleValue];
        //myMapViewController.latitude = [[self.bikeStation valueForKey:@"longitude"] doubleValue];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    for(CLLocation *location in locations){
        if(location.verticalAccuracy < 1000 && location.horizontalAccuracy < 1000){
            [self.myLocationManager stopUpdatingLocation];
            break;
        }
    }
}

@end
