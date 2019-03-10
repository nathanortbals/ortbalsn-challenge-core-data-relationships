//
//  CategoriesTableViewController.swift
//  ortbalsn-challenge-core-data-relationships
//
//  Created by Nathan Ortbals on 2/27/19.
//  Copyright © 2019 Nathan Ortbals. All rights reserved.
//

import UIKit
import CoreData

class CategoriesTableViewController: UITableViewController {

    @IBAction func addButton(_ sender: Any) {
        self.performSegue(withIdentifier: "moveToNewCategory", sender: nil)
    }
    
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try managedContext.fetch(fetchRequest)
            
            tableView.reloadData()
        } catch {
            print("Could not fetch categories")
        }
    }
    
    func deleteCategory(at indexPath: IndexPath) {
        let category = categories[indexPath.row]
        
        if let managedContext = category.managedObjectContext {
            managedContext.delete(category)
            
            do {
                try managedContext.save()
                
                self.categories.remove(at: indexPath.row)
                
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
            } catch{
                print("Could not delete category")
                
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categories[indexPath.row]
        
        if let cell = cell as? CategoryTableViewCell {
            cell.titleLabel.text = category.title
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DocumentsTableViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                destination.category = self.categories[selectedRow]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
            deleteCategory(at: indexPath)
        }
    }

}
