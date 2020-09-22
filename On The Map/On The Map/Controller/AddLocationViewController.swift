//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Binyamin Alfassi on 20/09/2020.
//  Copyright © 2020 Binyamin Alfassi. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
// This view controller in charge of getting the information of new student locationi and verifying the data
class AddLocationViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    //MARK: Outlets and Variables
    // Navigation bar for searching an address
    @IBOutlet weak var navBarSearch: UINavigationItem!
    // Textfield for MediaURL
    @IBOutlet weak var mediaLinkTextField: LoginTextField!
    // Variables to controll search results
    let locationManager = CLLocationManager()
    var resultSearchController: UISearchController? = UISearchController()
    // Table View for results
    @IBOutlet weak var resultsTableView: UITableView!
    // List of matching results for addresses
    var matchingItems: [MKMapItem] = []
    // Reuse ID for the table cell
    let reuseId = "LocationSearchCellId"
    // search bar pointer -> for internal use
    var searchBar: UISearchBar?
    // selected location - for internal  use
    var selectedLocation: MKMapItem? = nil
    
    //MARK: View Controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting delegate and data source for table view
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        // Setting configurations for search bar
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        resultSearchController!.searchResultsUpdater = self
        // Configuring and placing the search bar
        self.searchBar = resultSearchController!.searchBar
        searchBar!.sizeToFit()
        searchBar!.placeholder = "Search for an address"
        navBarSearch.titleView = resultSearchController?.searchBar
        definesPresentationContext = true
        // Settubg background color of Text Field to be clear
        mediaLinkTextField.backgroundColor = UIColor.clear
        
        // Placing a CANCEL button in navigation bar to go back to MAP/Table view
        let barButtonItem = UIBarButtonItem()
        barButtonItem.title = "CANCEL"
        barButtonItem.target = self
        barButtonItem.action = #selector(cancel)
        self.navigationItem.leftBarButtonItem = barButtonItem
    }
    //MARK: Actions
    // This function invoked when FIND LOCATION button is pressed.
    // It verifies location is selected and mediaURL is valid.
    // If not, it will show appropreate message.
    // If all goes well, it will invoke a confirmation screen with map, and pass to it the location and URL.
    @IBAction func FindLocationPushed(_ sender: Any) {
        // Check if location was selected
        guard let locationSelected = self.selectedLocation else {
            self.ShowFailure(message: "Address is not selected")
            return
        }
        // Check if URL is valid
        guard AppUtilities.verifyUrl(mediaLinkTextField.text) else {
            ShowFailure(message: "Media URL is not valid")
            return
        }
        // Invoke a confirmation screen with map, and pass to it the location and URL
        let seeOnMapVC =  storyboard?.instantiateViewController(withIdentifier: "SeeInMapVC") as! AddLocationMapVC
        seeOnMapVC.selectedLocation = locationSelected
        seeOnMapVC.selectedMediaUrl = mediaLinkTextField.text
        navigationController?.pushViewController(seeOnMapVC, animated: true)
    }
    // Cancel and go back to MAP/TABLE view
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    // Present a failure message on the screen
    func ShowFailure(message: String) {
        let alertVC = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
}

//MARK: SearchBar Functionalities
// Extention for the view controller providing SearchBar functionality
extension AddLocationViewController: UISearchResultsUpdating {
    // Once text is inserted, it gets search results using MapKit API and update the table accordingly
    func updateSearchResults(for searchController: UISearchController) {
        let searchBarText = searchController.searchBar.text
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
//        request.region = res.region
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else { print(error!)
                return
            }
            // Updating the list of results
            self.matchingItems = response.mapItems
            // Updating table
            self.resultsTableView.reloadData()
        }
    }
}

//MARK: TableView Functionality
// Providing Table View functionality
extension AddLocationViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.matchingItems.count
    }

    // Updating cells 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)

        // Configure the cell...
        let selectedItem = matchingItems[indexPath.row].placemark.title
        cell.textLabel?.text = selectedItem
        cell.detailTextLabel?.text = ""

        return cell
    }
    // If a row is selected, the location is stored in selectedLocation variable
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = matchingItems[indexPath.row]
        searchBar?.text = location.placemark.title
        self.selectedLocation = location
    }
}

//MARK: SearchBar Delegate functionality
extension AddLocationViewController: UISearchBarDelegate {
    // If User edit the text, it will clear the selected location variable
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.selectedLocation = nil
    }
}
