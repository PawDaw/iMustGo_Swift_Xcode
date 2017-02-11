//
//  TableViewController.swift
//  iMustGo
//
//  Created by paw daw on 06/06/16.
//  Copyright © 2016 paw daw. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var savedToilets = [toilet]()
    var toiletsActive = [toilet]()
    var toiletsNotWorking = [toilet]()
    
       

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
        
        if let data = loadToilets(){
            savedToilets += data
            
        }else{
            print("No saved Data")
        }
        
        self.tableView.addSubview(self.refreshControl)
        
    }
    
    
    // ---- Pull to Refresh  ----
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TableViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    func handleRefresh(refreshControl: UIRefreshControl) {
    
        // Fetch more objects from saved data on the device
        
        if let data = loadToilets(){
            savedToilets = data
            
        }else{
            print("No saved Data")
        }

        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
   // ----------
    
    
    // data from AppDelegate class
    var toilets = [toilet]()
    
    
    // func from AppDelegate class
    func dataIsReady(){
        
        // run function to sorting Activ or not working toilets
       sortToiletsStatus()
        
    }
    
    
    
    // MARK: LOADING TOILETS
    
    func loadToilets() -> [toilet]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(toilet.ArchiveURL!.path!) as? [toilet]
    }
    
    
    // sort toilets as  Activ or not working and append to particular arrays
    func sortToiletsStatus(){
        
        for item in toilets {
            if (item.status == "Aktiv"){
                toiletsActive.append(item)
            }else{
                toiletsNotWorking.append(item)
            }
        }
    }
    
    func viewDidLoad(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    

    // MARK: - Table view data source

   func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        // Return the number of sections.
          return 3
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        switch section{
        case 0:
            return self.savedToilets.count
        case 1:
            return self.toiletsActive.count
        case 2:
            return self.toiletsNotWorking.count
        default:
            return self.toilets.count
        }
    }


     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) 

        switch (indexPath.section) {
        case 0:
            cell.textLabel?.text = savedToilets[indexPath.row].address
        case 1:
            cell.textLabel?.text = toiletsActive[indexPath.row].address
        case 2:
            cell.textLabel?.text = toiletsNotWorking[indexPath.row].address
            //return sectionHeaderView
        default:
            cell.textLabel?.text = "Other"
        }
        
        return cell
    }

    // MARK: - Table view data source
    

    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! CustomHeaderCell
        //headerCell.backgroundColor = UIColor.grayColor()
        
        switch (section) {
        case 0:
            headerCell.headerLabel.text = "Saved Toilets";
            //return sectionHeaderView
        case 1:
            headerCell.headerLabel.text = "Activ Toilets";
            //return sectionHeaderView
        case 2:
            headerCell.headerLabel.text = "Not working Toilets";
            //return sectionHeaderView
        default:
            headerCell.headerLabel.text = "Other";
        }
        
        return headerCell
    }
    

   
}
