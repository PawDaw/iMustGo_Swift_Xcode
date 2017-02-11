//
//  AppDelegate.swift
//  iMustGo
//
//  Created by paw daw on 05/06/16.
//  Copyright © 2016 paw daw. All rights reserved.
//

import UIKit
import MapKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
      
        let urlPath = "http://chat.students.dk/toilet.php"
        let url: NSURL = NSURL(string: urlPath)!
        
        // provide an API for downloading content
        let session = NSURLSession.sharedSession()
        
        // toilets Array
        var toiletObjects = [toilet]()
        

        let task = session.dataTaskWithURL(url)
            { (data, response, error) -> Void in
                if error == nil {
            

                    let returnData = JSON(data: data!)
                    let toilets = returnData["features"].arrayValue
                   
                    for item in toilets {
                    
                        // JSON
                    let status = item["properties"]["Status"].stringValue
                    let address = item["properties"]["Adresse"].stringValue
                    let by = item["properties"]["By"].stringValue
                    let postnr = item["properties"]["Postnr#"].stringValue
                    let lat = item["geometry"]["coordinates"][1].doubleValue   // location  --  latitude
                    let long = item["geometry"]["coordinates"][0].doubleValue // location -- longitude
                    
                    
                        
                    // array with data , implemented in toilet.swift
                    toiletObjects.append(toilet(status: status, address: address,by :by,postnr :postnr, storedIphone: false, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))!)
                            
                
                    
                    
                        print("\(returnData) ")
                        
                        //print("\(address) location: \(by), \(postnr) ")
                        
                        
                    }
                    
                    // connection to MAP VIEW CONNTROLLER and send toiletObjects array, call func. dataIsReady()
                    let vc = (self.window?.rootViewController as! UITabBarController).viewControllers!.first as! ViewController
                    vc.toilets = toiletObjects
                    vc.dataIsReady()
                    
                    // connection to TABLE VIEW CONNTROLLER and send toiletObjects array, call func. dataIsReady()
                    let vcTable = (self.window?.rootViewController as! UITabBarController).viewControllers!.last as! TableViewController
                    vcTable.toilets = toiletObjects
                    vcTable.dataIsReady()
                    
                    
                }else{
                     print("NO data was recieved")
                }
                
        }
        
        
        task.resume()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

