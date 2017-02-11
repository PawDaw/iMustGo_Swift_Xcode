//
//  toilet.swift
//  iMustGo
//
//  Created by paw daw on 05/06/16.
//  Copyright © 2016 paw daw. All rights reserved.
//

import UIKit
import MapKit

// NSObject that mean a I can storage this class on the disk
// NSCoding coding data we have to use two func encoding and decoding

class toilet: NSObject,NSCoding ,  MKAnnotation {

    
    let status : String
    let address : String?
    let by : String?
    let postnr : String?
    var storedIphone : Bool?
    let coordinate : CLLocationCoordinate2D
    
    init?(status: String, address:String, by:String,postnr:String,storedIphone:Bool, coordinate:CLLocationCoordinate2D) {
    
        self.status = status
        self.address = address
        self.by = by
        self.postnr = postnr
        self.storedIphone = storedIphone
        self.coordinate = coordinate
        
        super.init()
        
        // Initialize should fail if status or address is empty
        if address.isEmpty || status.isEmpty || by.isEmpty || postnr.isEmpty  {
            return nil
        }
        
    }
    
    
    // -------  MAP KIT componetns  -------
    
    // title shows in the  pin pop up
    var title: String? {
        return address
    }
    
    // subtitle shows in the  pin pop up
    var subtitle: String? {
        return status
    }
    
    // pinColor for STAUTS: Activ -> green , not working -> red, saved on the decive -> purple
    func pinColor() -> UIColor  {
        switch status {
            
        case "Ude af drift" :
             return UIColor.redColor()
            
        case "Aktiv" :
            
            if  storedIphone == true {
                
                return UIColor.blackColor()
            }else{
                return UIColor.greenColor()
            }
            
        default:
             return UIColor.purpleColor()
        }
    }
    
    
    // annotation left button ROUT from the current location
    func mapItem() -> MKMapItem {
        let placemark = MKPlacemark(coordinate: self.coordinate, addressDictionary: nil)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.title
        
        return mapItem
    }

    
    
    
    // --------   Persist Data ----------
    
    // constants instead of retyping the strings (which increases the likelihood of mistakes).
    // MARK : TYPES
    struct PropertyKey {
        static let statusKey = "status"
        static let addressKey = "address"
        static let byKey = "by"
        static let postnrKey = "postnr"
        static let storedIphoneKey = "storedIphone"
        static let latitudeKey = "latitude"
        static let longitudeKey = "longitude"
        
    }
   
    
    // MARK: create a file path to data
    
    static let DocumentDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentDirectory.URLByAppendingPathComponent("file_15")
    //Outside of the toilet class, you’ll access the path using the syntax toilet.ArchiveURL.path!
    
    
    
    // ---------  CODING  NScoding -------
    // two methods requarie after implemented NSCoding ( encodeWithCoder and convenience)
    
    
   
    
    // MARK : NScoding
    
    
    // Coding data
    
    func encodeWithCoder(aCoder: NSCoder) {

        aCoder.encodeObject(status, forKey: PropertyKey.statusKey)
        aCoder.encodeObject(address, forKey: PropertyKey.addressKey)
        aCoder.encodeObject(by, forKey: PropertyKey.byKey)
        aCoder.encodeObject(postnr, forKey: PropertyKey.postnrKey)
        aCoder.encodeBool(storedIphone!, forKey: PropertyKey.storedIphoneKey )
        aCoder.encodeObject(self.coordinate.latitude, forKey: PropertyKey.latitudeKey)
        aCoder.encodeObject(self.coordinate.longitude, forKey: PropertyKey.longitudeKey)
       
        
    }
    
    // READ retriving data
    required convenience init?(coder aDecoder: NSCoder) {
        
        let status = aDecoder.decodeObjectForKey(PropertyKey.statusKey) as! String
        let address = aDecoder.decodeObjectForKey(PropertyKey.addressKey) as! String
        let by = aDecoder.decodeObjectForKey(PropertyKey.byKey) as! String
        let postnr = aDecoder.decodeObjectForKey(PropertyKey.postnrKey) as! String
        let storedIphone = aDecoder.decodeBoolForKey(PropertyKey.storedIphoneKey)
        let latitude = aDecoder.decodeObjectForKey(PropertyKey.latitudeKey) as! Double
        let longitude = aDecoder.decodeObjectForKey(PropertyKey.longitudeKey) as! Double
        
        // must call designated initializer to load the toilet
        self.init(status: status, address: address, by:by,postnr:postnr,storedIphone:storedIphone,coordinate:CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        
        
    }

    
   
}
