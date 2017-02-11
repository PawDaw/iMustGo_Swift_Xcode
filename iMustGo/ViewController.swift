//
//  ViewController.swift
//  iMustGo
//
//  Created by paw daw on 05/06/16.
//  Copyright © 2016 paw daw. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    let locatonManager = CLLocationManager()
    
    
    @IBAction func enabledChanged(sender: UISwitch) {
        
        if sender.on {
            
             // Start Updating current location
            locatonManager.startUpdatingLocation()
            
        } else {
            // Stop Updating current location
            locatonManager.stopUpdatingLocation()
        }
    }
    
    @IBOutlet var mapView: MKMapView!
    
    
    
    // table to save favourite toilets
    var savedToilets = [toilet]()

    
    
    
    // data from AppDelegate class
    var toilets = [toilet]()
    
    // func from AppDelegate class
    func dataIsReady(){
        
        if let data = loadToilets(){
            savedToilets += data
            
            for t in savedToilets{
                for t2 in toilets{
                    if t.address == t2.address{
                        t2.storedIphone = true
                    }
                }
                
            }

            
        }else{
            print("No saved Data")
        }
 

        // add some annotation to the map
        mapView.addAnnotations(toilets)
        
    }
    
    
    
    
    // set TRUE value to toilets storedIphone attribute
    func set_True_StoredIphone(){
        
      
            
            for t in toilets{
                for t2 in savedToilets{
                    if t.address == t2.address{
                        t.storedIphone = true
                    }
                }
            }
        
         // refresh all pins
         mapView.removeAnnotations(toilets)
         mapView.addAnnotations(toilets)

    }
    
    // set TRUE or FALSE value to toilets storedIphone attribute from savedToilets array
    func set_False_StoredIphone(){
        
            for t in toilets{
                for t2 in savedToilets{
                    if t.address == t2.address{
                        t.storedIphone = t2.storedIphone
                    }
                }
           }
        
        
        // refresh all pins
        mapView.removeAnnotations(toilets)
        mapView.addAnnotations(toilets)
        
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Set to self
        self.locatonManager.delegate = self
        
        // Best location
        self.locatonManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Request to use Localization , info.plist - add line - WAZNE
        self.locatonManager.requestWhenInUseAuthorization()
        
        // Start Updating current location
       // self.locatonManager.startUpdatingLocation()
        
        // Show BLUE  dotpin
        self.mapView.showsUserLocation = true
        
        // call method  " centerMapOnRegion "
        let initialLocation = CLLocation(latitude: 56.143657, longitude: 10.178651)
        centerMapOnRegion(initialLocation)
        mapView.addAnnotations(toilets)
    
    }
    
    // Center, zoom map region with given location
    private func centerMapOnRegion(location: CLLocation)
    {
        
        let regionRadius: CLLocationDistance = 5000
        let zoomLevel = 2.0

        let coordinateRegion = MKCoordinateRegionMakeWithDistance(
            location.coordinate,
            regionRadius * zoomLevel,
            regionRadius * zoomLevel)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    
    // MARK: - Location Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // last location
        let location = locations.last
        
        // Center to current Location
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        // Zoom to region with Center,  (5,5)-ZOOM value
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.09))
        
        // set Region to Show with Animaction Zooming
        self.mapView.setRegion(region, animated: true)
        
        mapView.addAnnotations(toilets)
        
        
    }
    
    
    

}

//  PIN extension , the method that gets called for every annotation you add to the map ( mapView.addAnnotations(toilets) )

extension ViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        // praticular toliet item as annotation
        if let annotation = annotation as? toilet{
            
            let identifier = "pin"
            var view: MKPinAnnotationView  // pin icon !!!!
            
                
                // make a pin from scratch It cost some memory
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                
                view.canShowCallout = true  // show extra info to pin
                view.centerOffset = CGPoint(x: -5.0, y: 5.0)
            
                // call method from toilet class and set diffrents colors
                view.pinTintColor = annotation.pinColor()
            
                if annotation.storedIphone == true {
                    
                    // DELETE button ; Add an image to the right callout.
                    let deleteButton = UIButton(type: UIButtonType.Custom) as UIButton
                    deleteButton.frame.size.width = 50
                    deleteButton.frame.size.height = 50
                    deleteButton.backgroundColor = UIColor.redColor()
                    deleteButton.setImage(UIImage(named: "ic_delete_white"), forState: .Normal)
                    view.rightCalloutAccessoryView = deleteButton as UIView

                }else{
                    
                    // ADD button ; Add an image to the right callout.
                    let addButton = UIButton(type: UIButtonType.Custom) as UIButton
                    addButton.frame.size.width = 50
                    addButton.frame.size.height = 50
                    addButton.backgroundColor = UIColor.greenColor()
                    addButton.setImage(UIImage(named: "ic_add_circle_outline_white"), forState: .Normal)
                    view.rightCalloutAccessoryView = addButton as UIView
                    
                    // standard button
                    //view.rightCalloutAccessoryView = UIButton(type: .ContactAdd) as UIView

                }
            
            // ROUT button ; Add an image to the right callout.
            let routButton = UIButton(type: UIButtonType.Custom) as UIButton
            routButton.frame.size.width = 50
            routButton.frame.size.height = 50
            routButton.backgroundColor = UIColor.blueColor()
            routButton.setImage(UIImage(named: "walk"), forState: .Normal)
            view.leftCalloutAccessoryView = routButton as UIView

            
            
            return view
        }
        
        return nil
        
    }
    
    
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
     // check button annotation side left or right
     if (control == view.leftCalloutAccessoryView){
        
        let location = view.annotation as? toilet  // when you cicked on the button teke the location
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving];
        location!.mapItem().openInMapsWithLaunchOptions(launchOptions)
        
        
     }else{
        
        
        let toiletItem = view.annotation as? toilet
        
        if toiletItem?.storedIphone == false{
            
            toiletItem!.storedIphone = true
            
            savedToilets.append(toiletItem!)
            
            set_True_StoredIphone()
            
            savePhotos()
            
            
            
        }else{
            
            
            for wc in savedToilets
            {
                if wc.address == toiletItem?.address{
                    wc.storedIphone = false
                    set_False_StoredIphone()
                    savedToilets.removeAtIndex(savedToilets.indexOf(wc)!)
                }
            }
            
            savePhotos()
            
        }
        
        
        }
    
        
    }
    
   
    
    // MARK: SAVING Toilets
    
    func savePhotos(){
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(savedToilets, toFile: toilet.ArchiveURL!.path!)
        
        if !isSuccessfulSave{
            print("Failed to save the toilet list")
            
        }else{
            print("Data SAVED !!! ")
        }
    }
    
    // MARK: LOADING Toilets
    
    func loadToilets() -> [toilet]? {

        return NSKeyedUnarchiver.unarchiveObjectWithFile(toilet.ArchiveURL!.path!) as? [toilet]

    }
    
  
    
    
}

