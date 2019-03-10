//
//  DocumentsTableViewController.swift
//  ortbalsn-challenge-core-data
//
//  Created by Nathan Ortbals on 2/18/19.
//  Copyright © 2019 Nathan Ortbals. All rights reserved.
//

import UIKit
import CoreData

class DocumentsTableViewController: UITableViewController {
    
    var category: Category?
    
    @IBAction func addButton(_ sender: Any) {
        self.performSegue(withIdentifier: "moveToNewDocument", sender: nil)
    }
    
    @IBOutlet weak var addButtonItem: UIBarButtonItem!
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func deleteDocument(at indexPath: IndexPath) {
        if let document = category?.documents?[indexPath.row], let managedContext = document.managedObjectContext {
            managedContext.delete(document)
            
            do {
                try managedContext.save()
                
                category?.removeFromRawDocuments(document)
                
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
            } catch{
                print("Could not delete document")
                
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.documents?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)
        
        if let document = category?.documents?[indexPath.row], let cell = cell as? DocumentTableViewCell {
            cell.titleLabel.text = document.title
            
            if let dateModified = document.dateModified {
                cell.modifiedLabel.text = dateFormatter.string(from: dateModified)
            }
            
            if let size = document.size {
                cell.sizeLabel.text = String(size) + " bytes"
            }
            else {
                cell.sizeLabel.text = ""
            }
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DocumentViewController {
            destination.category = category
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                destination.existingDocument = category?.documents?[selectedRow]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "moveToNewDocument", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
            deleteDocument(at: indexPath)
        }
    }
}
