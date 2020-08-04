//
//  LocationTableViewController.swift
//  Calendar
//
//  Created by hyperactive on 23/07/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit
import MapKit

class LocationTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate {
    
    let locationManager = CLLocationManager()
    var results: [MKMapItem] = []
    var item: MKMapItem!
    var locations = [String]()
    var searchController: UISearchController! = nil
    var locationTitle: String = ""
    var locationDetails: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        searchController.isActive = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.barTintColor = .blue
        
        //find a way to cancel the back button on navigationController
        navigationController?.delegate = self
        navigationItem.backBarButtonItem?.tintColor = .blue
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (navigationController?.topViewController as? AddEventTableViewController)?.location = locationTitle
        (navigationController?.topViewController as? AddEventTableViewController)?.locationTitle.text = locationTitle
        (navigationController?.topViewController as? AddEventTableViewController)?.subtitle = locationDetails
        (navigationController?.topViewController as? AddEventTableViewController)?.mapLocation = item
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchRequest = MKLocalSearch.Request()
        
        let location = locationManager.location!
        let l = CLLocationCoordinate2D(latitude: location.coordinate.latitude , longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.0, longitudeDelta: 0.0)
        let region = MKCoordinateRegion(center: l, span: span)
        searchRequest.region = region
        
        let searchText = searchController.searchBar.text
        searchRequest.naturalLanguageQuery = searchText

        let search = MKLocalSearch(request: searchRequest)
        search.start { response, _ in
            guard response != nil else {
                return
            }
        
            self.results = response?.mapItems ?? []
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = results[indexPath.row].placemark
        locationTitle = selectedItem.name ?? ""
        locationDetails = parseAddress(selectedItem: selectedItem)
        item = results[indexPath.row]
        navigationController?.popViewController(animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        
        let selectedItem = results[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            print("location:: (location)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
}
