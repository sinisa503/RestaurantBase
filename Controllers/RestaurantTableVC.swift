//
//  RestaurantTableVC.swift
//  Restaurant Base
//
//  Created by Sinisa Vukovic on 28/03/2017.
//  Copyright © 2017 Sinisa Vukovic. All rights reserved.
//

import UIKit
import CoreData

class RestaurantTableVC: CoreDataTableViewController, ApiProtocol {
    
    private var detailViewController: MapVC? = nil
    private var apiService:RequestService?
    private let persistanceManager = PerstistenceManager.sharedInstance
    private var numberOfObjectsInDatabase:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if persistanceManager.context != nil {
            numberOfObjectsInDatabase = persistanceManager.countObjects(entityName: DataBaseConstants.ENTITY_RESTAURANT, predicate: nil)
            if numberOfObjectsInDatabase == 0 {
                apiService = RequestService.sharedInstance
                apiService?.delegate = self
            }
                fetchDataFromDatabase()
        }
        setUpSplitView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueiConstants.SHOW_DETAIL {
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
            let customCell = configure(cell: cell, at: indexPath)
            return customCell
        }else {
            return UITableViewCell()
        }
    }
    
    //MARK: ApiService delegate - called when download from web is finished
    func apiFinished(restaurantArray: [Restaurant]?) {
        if let restaurants = restaurantArray {
            for restaurant in restaurants {
                if let context = persistanceManager.context {
                    context.perform({ [weak self] in
                        _ = self?.persistanceManager.updateDatabaseWith(restaurant: restaurant, andImage: nil)
                    })
                }
            }
        }
    }
    
    //MARK: private funcions
    
    private func configure(cell: CustomTableVCell ,at indexPath: IndexPath  ) -> CustomTableVCell{
        var name, address:String?
        var image: UIImage?
        if let restaurant = fetchedResultsController?.object(at: indexPath) as? Restoran {
            persistanceManager.context?.performAndWait({
                name = restaurant.name
                address = restaurant.address
                if let data = restaurant.image {
                    image = UIImage(data: (data as NSData) as Data)
                }
            })
        }
        if let name = name, let address = address {
            cell.nameLabel.text = name
            cell.addressLabel.text = address
            if let image = image {
                cell.photo.image = image
            }
        }
        return cell
    }
    
    private func fetchDataFromDatabase(context: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:DataBaseConstants.ENTITY_RESTAURANT)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: DataBaseConstants.NAME, ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func setUpSplitView() {
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? MapVC
        }
    }
    
    //NSFetchRequestController sync table with database
    func fetchDataFromDatabase() {
        if let context = persistanceManager.context {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:DataBaseConstants.ENTITY_RESTAURANT)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: DataBaseConstants.NAME, ascending: true)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        }
    }
}
