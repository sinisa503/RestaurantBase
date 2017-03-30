//
//  RestaurantTableVC.swift
//  Restaurant Base
//
//  Created by Sinisa Vukovic on 28/03/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import UIKit
import CoreData

class RestaurantTableVC: CoreDataTableViewController {
    
    var detailViewController: MapVC? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                            action: #selector(RestaurantTableVC.insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? MapVC
        }
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*
         if segue.identifier == "showDetail" {
         if let indexPath = self.tableView.indexPathForSelectedRow {
         let object = self.fetchedResultsController.object(at: indexPath)
         let controller = (segue.destination as! UINavigationController).topViewController as! MapVC
         controller.detailItem = object
         controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
         controller.navigationItem.leftItemsSupplementBackButton = true
         }
         }
         */
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
        print("Can Edit")
        return true
    }
    
    @objc private func insertNewObject(_ sender: Any) {
        //TODO: Implement inserting new object
        print("Insert new object...")
        let rest = Restaurant(name: NSDate.description(), address: NSDate().description, longitude: 12.1212, latitude: 23.1234)
        PerstistenceManager.updateRestaurantIfNotPresent(rest, managedObjectContext!)
    }
}
