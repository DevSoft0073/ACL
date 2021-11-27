//
//  SaveSearchData.swift
//  ACL
//
//  Created by Aman on 04/08/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit
import CoreData

class SaveSearchData : NSObject{
   
    func saveDataInCoreData(idSearch: String) ->[SearchedData]{
      var dataHistory:[SearchedData] = []
      let appdelegate = UIApplication.shared.delegate as! AppDelegate
      let context = appdelegate.persistentContainer.viewContext
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchedData")
      request.predicate = NSPredicate(format: "name = %@", argumentArray: [idSearch])
      request.returnsObjectsAsFaults = false
      do{
        let results =  try context.fetch(request) as! [NSManagedObject]
        if results.count > 0 {
          //update
          //already item in data
          do{
            try context.save()
          }catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
          }
        } else {
          print("Add new data")
          let entity = NSEntityDescription.entity(forEntityName: "SearchedData", in: context)
          let dataInHistory = NSManagedObject(entity: entity!, insertInto: context)
          dataInHistory.setValue(idSearch, forKey: "name")
          do{
            try context.save()
            dataHistory.append(dataInHistory as! SearchedData)
          }catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
          }
        }
      }catch{
        //
      }
      return dataHistory
    }


    //Mark: save cart data in core data
    var searchHistoryData: [NSManagedObject] = []
    //Mark: fetch data from cart
    func getHistoryData(){
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
          return
      }
      let managedContext = appDelegate.persistentContainer.viewContext
      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SearchedData")
      do{
        searchHistoryData = try managedContext.fetch(fetchRequest)
        
      }catch let error as NSError{
        print("Could not fetch. \(error), \(error.userInfo)")
      }
      
    }

    
}



