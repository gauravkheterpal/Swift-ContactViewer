//
//  SwiftSF.swift
//  SFTest
//
//  Created by Gaurav Kheterpal on 02/02/15.
//  Copyright (c) 2015 Gaurav Kheterpal. All rights reserved.
//

import UIKit

class ContactListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let kCellIdentifier = "Default"
    var dataRows:NSArray = NSArray()
    @IBOutlet weak var contactsTableView:UITableView!
    @IBOutlet weak var loadingSpinner:UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contacts"
        self.navigationController?.navigationBar.translucent = false;
        var loadContact:DataClass = DataClass()
        loadContact.delegate = self
        
        self.loadingSpinner.startAnimating()
        loadContact.fetchContacts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchContactSuccess(records:NSArray){
        
        self.loadingSpinner.stopAnimating()
        self.dataRows = records
        println(self.dataRows.objectAtIndex(0));

        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        contactsTableView.reloadData()
        
    }
    func fetchContactFailed(error:NSError){
        self.loadingSpinner.stopAnimating()
        println("fetchContactFailed \(error)")
        let alert = UIAlertView()
        alert.title = "Error in fetching contacts"
        alert.message = "\(error.localizedDescription)"
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    
    //UITableViewDataSource methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(self.dataRows.count == 0){
            return 0
        }
        return self.dataRows.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell! = contactsTableView.dequeueReusableCellWithIdentifier("default") as? UITableViewCell
        
        // Configure the cell for this indexPath
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "default")
        }
        
        // Configure the cell to show the data.
        var contactObj:NSDictionary = self.dataRows.objectAtIndex(indexPath.row) as NSDictionary
        cell.textLabel?.text = contactObj["Name"] as NSString
        //this adds the arrow to the right hand side.
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        // Make sure the constraints have been added to this cell, since it may have just been created from scratch
        return cell
    }
    
    //UITableViewDelegate methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var contactDetailVCntrl = ContactDetailViewController(nibName: "ContactDetailViewController", bundle: nil)
        var contactObj:NSDictionary = self.dataRows.objectAtIndex(indexPath.row) as NSDictionary
        var selectedContactId:NSString = contactObj.valueForKey("Id")  as NSString
        contactDetailVCntrl.contactId = selectedContactId
        self.navigationController?.pushViewController(contactDetailVCntrl, animated: true)
    }

}
