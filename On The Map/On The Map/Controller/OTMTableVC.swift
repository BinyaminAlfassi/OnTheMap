//
//  OTMTableVC.swift
//  On The Map
//
//  Created by Binyamin Alfassi on 19/09/2020.
//  Copyright © 2020 Binyamin Alfassi. All rights reserved.
//

import UIKit

// This class implements the screen for table locations
class OTMTableVC: UITableViewController {
    //MARK: Outlets & Variables
    // Navigation bar
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    // Reuse ID for table cell
    let reuseId = "OTMTableReuseId"
    // A list of all students location stored in the Model
    var studentsLocationList: [StudentLocation] {return StudentsLocationsModel.studentsLocationList}
    
    //MARK: View Controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting the buttons for Navigation bar
        setNavigationButtons()
        // Getting students location list using Udacity client
        getStudentsList()
    }
    //MARK: Utilities functions
    // This function get students location using Udacity client request
    @objc func getStudentsList() {
        UdacityClient.getStudentsLocation(completion: handleStudentsListResponse(studentsLocationList:error:))
    }
    // This function handles the response of request for stuents list
    func handleStudentsListResponse(studentsLocationList: [StudentLocation], error: Error?) {
        if let error = error {
            print(error)
            ShowFailure(message: "Could not fetch locations.\nPlease try again later.")
            lockUI(lock: true)
        } else {
            // Updating the model
            StudentsLocationsModel.updateStudentsLocationList(newList: studentsLocationList)
            // Updating the table view
            tableView.reloadData()
        }
    }
    // This function set all buttons in navigation bar
    func setNavigationButtons() {
        // Refresh button -> will refresh the list of students locations
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(getStudentsList))
        // Add Button -> Add a new location.
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLocation))
        self.navigationItem.rightBarButtonItems = [addButton, refreshButton]
        // Logout button -> User logout
        let logoutButton = UIBarButtonItem()
        logoutButton.title = "LOGOUT"
        logoutButton.target = self
        logoutButton.action = #selector(logout)
        self.navigationItem.leftBarButtonItem = logoutButton
    }
    // Logout user and returns the user to login screen
    @objc func logout() {
        UdacityClient.logout {
            self.dismiss(animated: true, completion: nil)
        }
    }
    // This function invokes a screen to add a new student-location
    @objc func addLocation() {
        let newVc = (storyboard?.instantiateViewController(identifier: "AddLocationID"))!
        present(newVc, animated: true, completion: nil)
    }
    
    // This function present a faluite notice on the screen
    func ShowFailure(message: String) {
        let alertVC = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    // Lock UI if an error occurs
    func lockUI(lock: Bool){
        let buttons = self.navigationItem.rightBarButtonItems!
        for button in buttons {
            button.isEnabled = !lock
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentsLocationList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        // Getting correct student location
        let studentLocation = self.studentsLocationList[indexPath.row]
        // Updating cell with the full name and media URL
        cell.textLabel?.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        cell.detailTextLabel?.text = studentLocation.mediaURL
        cell.imageView?.image = UIImage(named: "LocationPin")

        return cell
    }
    // Once user select a row in the table, Safari will be opened with the media URL, if the URL is valid
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Getting correct student location
        let studentLocation = self.studentsLocationList[indexPath.row]
        let url = studentLocation.mediaURL
        // Checking if URL is valid
        if AppUtilities.verifyUrl(url) {
            // Open safari with the URL
            UIApplication.shared.open(URL(string: url)!, completionHandler: nil)
        }
    }
    // lock the navigation bar while scrolling
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
