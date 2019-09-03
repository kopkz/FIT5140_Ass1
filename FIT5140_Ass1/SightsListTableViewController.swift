//
//  SightsListTableViewController.swift
//  FIT5140_Ass1
//
//  Created by 匡正 on 2/9/19.
//  Copyright © 2019 匡正. All rights reserved.
//

import UIKit

class SightsListTableViewController: UITableViewController, UISearchResultsUpdating, DatabaseListener {
    
//    var locationManager: CLLocationManager = CLLocationManager()
    var mapViewController: MapViewController?
    
    let SECTION_SIGHTS = 0
    let SECTION_COUNT = 1
    let CELL_SIGHT = "sightCell"
    let CELL_COUNT = "countCell"
    
    var allSights: [Sights] = []
    var filteredSights: [Sights] = []
    var locations = [LocationAnnotation]()
    weak var databaseController: DatabaseProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Get the database controller once from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        let searchController = UISearchController(searchResultsController: nil); searchController.searchResultsUpdater = self; searchController.obscuresBackgroundDuringPresentation = false; searchController.searchBar.placeholder = "Search Sights"
            navigationItem.searchController = searchController
        // This view controller decides how the search controller is presented.
        definesPresentationContext = true
        

        
        let sights = databaseController!.fetchSights()
        
        for sight in sights {
            let location = LocationAnnotation(newTitle: sight.name!, newSubtitle: sight.shortDesscripution!, lat: sight.latitude, long: sight.longitude, iconName: sight.iconName!)
            mapViewController?.mapView.addAnnotation(location)
            locations.append(location)
        }
        
    
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
//    func addAnnotation(sight: Sights) {
//        let location = LocationAnnotation(newTitle: sight.name!, newSubtitle: sight.shortDesscripution!, lat: sight.latitude, long: sight.longitude)
//        mapViewController?.mapView.addAnnotation(location)
//    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listenr: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listenr: self)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased(), searchText.count > 0 {
            filteredSights = allSights.filter({(sight: Sights) -> Bool in
                return sight.name?.lowercased().contains(searchText) ?? false
            })
        }
        else {
            filteredSights = allSights
        }
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == SECTION_SIGHTS {
            return filteredSights.count
        }
        else {
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == SECTION_SIGHTS {
            let sightCell = tableView.dequeueReusableCell(withIdentifier: CELL_SIGHT, for: indexPath) as! SightTableViewCell
            let sight = filteredSights[indexPath.row]

            sightCell.nameLabel.text = sight.name
            sightCell.shortDesLabel.text = sight.shortDesscripution
            sightCell.iconImageView.image = UIImage(named: sight.iconName!)
            
            
            return sightCell
        }
        
        let countCell = tableView.dequeueReusableCell(withIdentifier: CELL_COUNT, for: indexPath)

        // Configure the cell...

        countCell.textLabel?.text = "\(allSights.count) sights in the database"
        countCell.selectionStyle = .none
        return countCell
    }
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_COUNT {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        var filteredLocation: LocationAnnotation
        
        for location in locations {
            if location.title == filteredSights[indexPath.row].name {
                filteredLocation =  location
                mapViewController?.focusOn(annotation: filteredLocation)
            }
        }
       
        
    
//        if superHeroDelegate!.addSuperHero(newHero: filteredHeroes[indexPath.row]) {
//            navigationController?.popViewController(animated: true)
//            return
//        }
        
//        tableView.deselectRow(at: indexPath, animated: true)
//        displayMessage(title: "Party Full", message: "Cannot add any more members to party")
    }
    
    
    func displayMessage(title: String, message: String) {
        // Setup an alert to show user details about the Person
        // UIAlertController manages an alert instance
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Database Listener
    var listenerType = ListenerType.sights
    
    func onImagesChange(change: DatabaseChange, images: [Images]) {
        
    }
    
    func onSightsChange(change: DatabaseChange, sights: [Sights]) {
        allSights = sights
        updateSearchResults(for: navigationItem.searchController!)
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_SIGHTS{
            // Delete the row from the data source
            var filteredLocation: LocationAnnotation
            
            for location in locations {
                if location.title == filteredSights[indexPath.row].name {
                    locations.remove(at: locations.firstIndex(of: location)!)
                    filteredLocation =  location
                    mapViewController?.mapView.removeAnnotation(filteredLocation)
                }
            }
            self.allSights.remove(at: indexPath.row)
            self.filteredSights.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
//        else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
