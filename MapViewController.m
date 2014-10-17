//
//  MapViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()


@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationCoordinate2D coord;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.name);
    [self displayStation];
    // Do any additional setup after loading the view.
}


-(void)displayStation{

    //Store lat/long coordinates from stops dictionary of each stop
    CLLocationCoordinate2D coord;
    coord.latitude = self.latitude;
    coord.longitude = self.longitude;

    self.coord = coord;


    //Create discrete bus stop
   MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
   point.coordinate = coord;
   point.title = self.name;
    [self.mapView addAnnotation:point];

}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if(annotation == mapView.userLocation){
        return nil;
    }
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyPinID"];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.image = [UIImage imageNamed:@"bikeImage"];
    
    return pin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{

    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;

    MKCoordinateRegion region;
    region.center = self.coord;
    region.span = span;
    [self.mapView setRegion:region animated:YES];
    
    
}
@end
