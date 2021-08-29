//
//  DBService.swift
//  QRScanFind
//
//  Created by Jae Lee on 8/28/21.
//

import Foundation
import UIKit
import CoreData

enum TableName:String {
    case Code
}

class DBService {
    
    var codes: [NSManagedObject] = []
    
    init() {
        getCodes()
    }
    
    func saveCode(id: Int64) {
        
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: TableName.Code.rawValue,
                                       in: managedContext)!
        let code = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        code.setValue(id, forKeyPath: "id")
        do {
            try managedContext.save()
            codes.append(code)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getCodes() {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TableName.Code.rawValue)
        do {
            codes = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func deleteCode(object:NSManagedObject) {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        do {
            managedContext.delete(object)
            try managedContext.save()
        } catch {
            print(error)
        }
    }
    
    func doesCodeIdExist(id:Int64) -> Bool {
        self.codes.contains { code in
            if let idCode = code.value(forKeyPath: "id") as? Int64 {
                return idCode == id
            } else {
                return false
            }
        }
    }
    
    /**
     function returns first index of found code object
     */
    func findCodeId(id:Int64) -> Int? {
        self.codes.firstIndex { code in
            if let idCode = code.value(forKeyPath: "id") as? Int64 {
                return idCode == id
            } else {
                return false
            }
        }
    }
 }
