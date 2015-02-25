//
//  CViewController.swift
//  SFTest
//
//  Created by Gaurav Kheterpal on 02/02/15.
//  Copyright (c) 2015 Gaurav Kheterpal. All rights reserved.
//

import UIKit
class ContactDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet var contactDetailTableView:UITableView!
    @IBOutlet var loadingSpinner:UIActivityIndicatorView!
    let kCellIdentifier = "CellIdentifier"
    var contactId:String?
    var fName:String?
    var company:String?
    var designation:String?
    var address:String?
    var email:String?
    var phone:String?
    var website:String?
    var iOSVersion:NSString  = UIDevice.currentDevice().systemVersion
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.translucent = false
        
        if(iOSVersion.floatValue >= 8.0) {
            // [[UIDevice currentDevice] systemVersion];
            self.contactDetailTableView.allowsSelection = false
            
            self.contactDetailTableView.registerClass(TableViewCell.self, forCellReuseIdentifier: kCellIdentifier)
            
            // Self-sizing table view cells in iOS 8 require that the rowHeight property of the table view be set to the constant UITableViewAutomaticDimension
            self.contactDetailTableView.rowHeight = UITableViewAutomaticDimension
            
            // Self-sizing table view cells in iOS 8 are enabled when the estimatedRowHeight property of the table view is set to a non-zero value.
            // Setting the estimated row height prevents the table view from calling tableView:heightForRowAtIndexPath: for every row in the table on first load;
            // it will only be called as cells are about to scroll onscreen. This is a major performance optimization.
            self.contactDetailTableView.estimatedRowHeight = 44.0 // set this to whatever your "average" cell height is; it doesn't need to be very accurate*/
        }
        var loadContact:DataClass = DataClass()
        loadContact.delegate = self
        self.loadingSpinner.startAnimating()
        loadContact.fetchContactDetail(self.contactId)
        //fetchContact()
    }
    //UITableViewDataSource methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 6
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "default")
        
        let cell: TableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as TableViewCell
        
        // Configure the cell for this indexPath
        cell.updateFonts()
        // Configure the cell to show the data.
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Name"
            if(self.fName != nil) {
                cell.bodyLabel.text = self.fName
            }
        case 1:
            cell.titleLabel.text = "Company"
            if(self.company != nil) {
                cell.bodyLabel.text = self.company
            }
        case 2:
            cell.titleLabel.text = "Title"
            if(self.designation != nil) {
                cell.bodyLabel.text = self.designation
            }
        case 3:
            cell.titleLabel.text = "Phone"
            if(self.phone != nil) {
                cell.bodyLabel.text = self.phone
            }
        case 4:
            cell.titleLabel.text = "Email"
            if(self.email != nil) {
                cell.bodyLabel.text = self.email
            }
        case 5:
            cell.titleLabel.text = "Address"
            if(self.address != nil) {
                cell.bodyLabel.text = self.address
            }
        default:
            cell.titleLabel.text = ""
            cell.bodyLabel.text = ""
        }
        
        // Make sure the constraints have been added to this cell, since it may have just been created from scratch
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        return cell
    }
    
    func setContactDetails(contactDetails :NSDictionary){
        
        //Fetch Contact Name
        if !(contactDetails.valueForKey("FirstName") is NSNull) {
            var firstName = contactDetails.valueForKey("FirstName") as NSString
            self.fName = "\(firstName)"
            
        }
        
        if !(contactDetails.valueForKey("LastName") is NSNull) {
            var lastName = contactDetails.valueForKey("LastName") as NSString
            self.fName = "\(lastName)"
            
        }
        
        self.title = self.fName
        //Fetch Contact Company Name
        if !(contactDetails.valueForKey("Account") is NSNull) {
            var accountDetail = contactDetails.valueForKey("Account") as NSDictionary
            
            if !(accountDetail.valueForKey("Name") is NSNull) {
                var accountName = contactDetails.valueForKey("Account")?.valueForKey("Name") as NSString
                self.company = accountName
                
            }else {
                self.company = ""
            }
            
        }else {
            self.company = ""
        }
        
        
        //Fetch Contact Title
        if !(contactDetails.valueForKey("Title") is NSNull) {
            var title = contactDetails.valueForKey("Title") as NSString
            self.designation = title
            
        } else {
            self.designation = ""
        }
        
        
        //Fetch Contact Email
        if !(contactDetails.valueForKey("Email") is NSNull) {
            var emailAddress = contactDetails.valueForKey("Email") as NSString
            self.email = emailAddress
            
        } else {
            self.email = ""
        }
        
        //Fetch Contact Phone No
        if !(contactDetails.valueForKey("Phone") is NSNull) {
            var phoneno = contactDetails.valueForKey("Phone") as NSString
            self.phone = phoneno
            
        } else {
            self.phone = ""
        }
        
        //Fetch Contact Mailing Address
        self.address = ""
        var mailingAddress = ""
        
        if !(contactDetails.valueForKey("MailingStreet") is NSNull) {
            var mailingStreet:NSString = contactDetails.valueForKey("MailingStreet") as NSString
            mailingAddress += "\(mailingStreet)"
            
        }
        
        if !(contactDetails.valueForKey("MailingCity") is NSNull) {
            var mailingCity = contactDetails.valueForKey("MailingCity") as NSString
            mailingAddress += "\n\(mailingCity)"
            
        }
        
        if !(contactDetails.valueForKey("MailingState") is NSNull) {
            var mailingState = contactDetails.valueForKey("MailingState") as NSString
            mailingAddress += ",\(mailingState)"
            
        }
        
        if !(contactDetails.valueForKey("MailingPostalCode") is NSNull) {
            var mailingPostalCode = contactDetails.valueForKey("MailingPostalCode") as NSString
            mailingAddress += " \(mailingPostalCode)"
            
        }
        
        if !(contactDetails.valueForKey("MailingCountry") is NSNull) {
            var mailingCountry = contactDetails.valueForKey("MailingCountry") as NSString
            mailingAddress += "\n\(mailingCountry)"
            
        }
        
        self.address = mailingAddress
    }
    func fetchContactSuccess(records:NSArray){
        self.loadingSpinner.stopAnimating()
        var recordDetails:NSDictionary = records.objectAtIndex(0) as NSDictionary
        setContactDetails(recordDetails)
        self.contactDetailTableView.delegate = self
        self.contactDetailTableView.dataSource = self
        self.contactDetailTableView.reloadData()
        
    }
    func fetchContactFailed(error:NSError){
        self.loadingSpinner.stopAnimating()
        println("fetchContact DetailsFailed \(error)")
        let alert = UIAlertView()
        alert.title = "Error in getting contact details"
        alert.message = "\(error.localizedDescription)"
        alert.addButtonWithTitle("OK")
        alert.show()
    }
}
