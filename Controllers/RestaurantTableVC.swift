//
//  RestaurantTableVC.swift
//  Restaurant Base
//
//  Created by Sinisa Vukovic on 28/03/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import UIKit
import CoreData

class RestaurantTableVC: CoreDataTableViewController, ApiDelegate {
    
    var detailViewController: MapVC? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let apiService = RequestService.sharedInstance
    let persistanceManager = PerstistenceManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let context = managedObjectContext {
            persistanceManager.clearDatabase(context)
        }
        
        apiService.delegate = self

        setUpBarButtons()
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        if let context = managedObjectContext {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:DataBaseConstants.RESTORAN)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: DataBaseConstants.NAME, ascending: true)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    private func setUpBarButtons() {
        self.navigationItem.leftBarButtonItem = self.editButtonItem
   /*     let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                            action: #selector(RestaurantTableVC.insertNewObject(_:)))*/
        //self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? MapVC
        }
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "showDetail" {
         if let indexPath = self.tableView.indexPathForSelectedRow {
         let object = self.fetchedResultsController?.object(at: indexPath) as? Restoran
         let restoran = Restaurant(name: (object?.name)!, address: (object?.address)!, longitude: (object?.longitude)!, latitude: (object?.latitude)!)
         let mapVC = (segue.destination as! UINavigationController).topViewController as! MapVC
         mapVC.restaurant = restoran
         mapVC.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
         mapVC.navigationItem.leftItemsSupplementBackButton = true
         }
         }
    }
    
    // MARK: - Table View delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomTableVCell {
            var name:String?
            var address:String?
            var longitude: Double?
            var latitude: Double?
            if let restaurant = fetchedResultsController?.object(at: indexPath) as? Restoran {
                managedObjectContext?.performAndWait({
                    name = restaurant.name
                    address = restaurant.address
                    longitude = restaurant.longitude
                    latitude = restaurant.latitude
                })
            }

            if let name = name, let address = address {
                cell.nameLabel.text = name
                cell.addressLabel.text = address
            }
            return cell
        }else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    private func insertNewObject(restaurant: Restaurant) {
        //TODO: Implement inserting new object
        print("Insert new object...")
        persistanceManager.updateRestaurantIfNotPresent(restaurant, managedObjectContext!)
    }
    func apiFinished(restaurantArray: [Restaurant]?) {
        if let restaurants = restaurantArray {
            for restaurant in restaurants {
                insertNewObject(restaurant: restaurant)
            }
        }
    }
}
