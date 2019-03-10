//
//  Category+CoreDataClass.swift
//  ortbalsn-challenge-core-data-relationships
//
//  Created by Nathan Ortbals on 2/27/19.
//  Copyright © 2019 Nathan Ortbals. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Category)
public class Category: NSManagedObject {
    
    var documents: [Document]? {
        return self.rawDocuments?.allObjects as? [Document]
    }
    
    convenience init?(title: String?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        self.init(entity: Category.entity(), insertInto: managedContext)
        
        self.title = title
    }
}
