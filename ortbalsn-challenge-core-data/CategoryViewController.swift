//
//  CategoryViewController.swift
//  ortbalsn-challenge-core-data-relationships
//
//  Created by Nathan Ortbals on 2/27/19.
//  Copyright © 2019 Nathan Ortbals. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    
    var existingCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveCategory))
        self.navigationItem.rightBarButtonItem  = saveBarButtonItem
        
        if let existingCategory = existingCategory {
            titleTextField.text = existingCategory.title
        }
    }
    
    @objc
    func saveCategory() {
        let title = titleTextField.text
        
        var category: Category?
        if let existingCategory = existingCategory {
            existingCategory.title = title
            
            category = existingCategory
        }
        else {
            category = Category(title: title)
        }
        
        if let category = category{
            do {
                let managedContext = category.managedObjectContext
                try managedContext?.save()
                
                self.navigationController?.popViewController(animated: true)
            } catch{
                print("Category not saved")
            }
        }
    }

}
