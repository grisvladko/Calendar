//
//  searchViewController.swift
//  Calendar
//
//  Created by hyperactive on 02/08/2020.
//  Copyright © 2020 hyperactive. All rights reserved.
//

import UIKit

class searchViewController: UIViewController, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    var searchController: UISearchController! = nil
    var resultTable: SearchResultTableViewController!
    var dataBase: Calendars!
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        summonCalendars()
        
        resultTable = SearchResultTableViewController.init(style: .grouped)
        resultTable.tableView.delegate = self
        resultTable.tableView.dataSource = self
        
        initSearchController()
        
        let b = UIBarButtonItem(title: "back", style: .plain, target: nil, action: nil)
        b.tintColor = .blue
        navigationController?.navigationBar.topItem?.backBarButtonItem = b
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = events[indexPath.row].title
        cell.detailTextLabel?.text = events[indexPath.row].location
        
        (cell as? SearchCell)?.event = events[indexPath.row]
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "EventDetailsViewController")
        (vc as? EventDetailsViewController)!.event = events[indexPath.row]            
        navigationController?.show(vc, sender: nil)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty ?? false {
            events.removeAll()
        }
        resultTable.tableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        if searchText?.isEmpty ?? false {
            events.removeAll()
            return
        }
        for calendar in dataBase.calendars {
            for event in calendar.events {
                if searchEvent(event: event, text: searchText!) {
                    events.append(event)
                }
            }
        }
        resultTable.tableView.reloadData()
    }
    
    func searchEvent(event: Event, text: String) -> Bool {
        if (event.title.contains(text) || event.location.contains(text) || event.start.contains(text) || event.end.contains(text)) && !events.contains(where: { $0.isEqual(event: event)} ) {
            return true
        }
        return false
    }
    
    func initSearchController() {
    
        searchController = UISearchController(searchResultsController: resultTable)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        searchController.isActive = true
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.barTintColor = .blue
          
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func summonCalendars() {
        let url = getURL()
        guard let data = try? Data(contentsOf: url) else { return }
        dataBase = (try? JSONDecoder().decode(Calendars.self, from: data))!
    }
}
