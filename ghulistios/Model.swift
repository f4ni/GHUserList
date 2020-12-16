//
//  Users.swift
//  ghulistios
//
//  Created by f4ni on 13.12.2020.
//

import UIKit
import CoreData
import SwiftUI

public class User: NSManagedObject {
    
    
}

public class UserDetail: Codable{
    
    @NSManaged public var login: String?
    @NSManaged public var id: NSNumber?
    @NSManaged public var node_id: String?
    @NSManaged public var avatar_url: String?
    @NSManaged public var gravatar_id: String?
    @NSManaged public var url: String?
    @NSManaged public var html_url: String?
    @NSManaged public var followers_url: String?
    @NSManaged public var following_url: String?
    @NSManaged public var gists_url: String?
    @NSManaged public var starred_url: String?
    @NSManaged public var subscriptions_url: String?
    @NSManaged public var organizations_url: String?
    @NSManaged public var repos_url: String?
    @NSManaged public var events_url: String?
    @NSManaged public var received_events_url: String?
    @NSManaged public var type: String?
    @NSManaged public var site_admin: String?
    @NSManaged public var name: String?
    @NSManaged public var company: NSNumber?
    @NSManaged public var blog: String?
    @NSManaged public var location: String?
    @NSManaged public var email: String?
    @NSManaged public var hireable: String?
    @NSManaged public var bio: String?
    @NSManaged public var twitter_username: String?
    @NSManaged public var public_repos: NSNumber?
    @NSManaged public var public_gists: NSNumber?
    @NSManaged public var followers: NSNumber?
    @NSManaged public var following: NSNumber?
    @NSManaged public var created_at: String?
    @NSManaged public var updated_at: String?
    @NSManaged public var notes: String?
}

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    
    @NSManaged public var login: String?
    @NSManaged public var id: NSNumber?
    @NSManaged public var node_id: String?
    @NSManaged public var avatar_url: String?
    @NSManaged public var gravatar_id: String?
    @NSManaged public var url: String?
    @NSManaged public var html_url: String?
    @NSManaged public var followers_url: String?
    @NSManaged public var following_url: String?
    @NSManaged public var gists_url: String?
    @NSManaged public var starred_url: String?
    @NSManaged public var subscriptions_url: String?
    @NSManaged public var organizations_url: String?
    @NSManaged public var repos_url: String?
    @NSManaged public var events_url: String?
    @NSManaged public var received_events_url: String?
    @NSManaged public var type: String?
    @NSManaged public var site_admin: String?
    @NSManaged public var name: String?
    @NSManaged public var company: NSNumber?
    @NSManaged public var blog: String?
    @NSManaged public var location: String?
    @NSManaged public var email: String?
    @NSManaged public var hireable: String?
    @NSManaged public var bio: String?
    @NSManaged public var twitter_username: String?
    @NSManaged public var public_repos: NSNumber?
    @NSManaged public var public_gists: NSNumber?
    @NSManaged public var followers: NSNumber?
    @NSManaged public var following: NSNumber?
    @NSManaged public var created_at: String?
    @NSManaged public var updated_at: String?
    @NSManaged public var notes: String?

    

}



class Model: NSObject {
    
    var since = Int(0)
    let baseApiUrlStr = "https://api.github.com"
    var sessionForSearch = URLSessionDataTask()
    static let sharedInstance = Model()

     func saveInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{self.createUserEntityFrom(dictionary: $0)}
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    func saveSingleInCoreDataWith(dt: [String: AnyObject]) {
       self.createUserEntityFrom(dictionary: dt)
       do {
           try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
       } catch let error {
           print(error)
       }
   }
     func clearData() {
        do {
            
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: User.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    
    private func createUserEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        
        
        let req: NSFetchRequest<User> = User.fetchRequest()
        
        let fetchReq:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
        fetchReq.predicate = NSPredicate(format: "login = %@", argumentArray: [dictionary["login"]])
        do {
            let test = try context.fetch(fetchReq)
            if let res = try context.execute(fetchReq) as? User{
                
            }
            else{
                
                if let userEntity = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
                            
                            userEntity.login = dictionary["login"] as? String
                            userEntity.avatar_url = dictionary["avatar_url"] as? String
                            return userEntity
                        }
            }
          
        } catch  {
            print(error)
        }
        
        
        return nil
    }
    
}

class CoreDataStack: NSObject {
    
    static let sharedInstance = CoreDataStack()
    private override init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ghulistios")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getUserWith(login: String) throws -> [User]?{

      let context = persistentContainer.viewContext
      let request: NSFetchRequest<User> = User.fetchRequest()

      request.predicate = NSPredicate(format: "login == %@ ", argumentArray: [login])

      return try context.fetch(request)

    }
    
    
    func filterUsers( word: String) throws -> [User]?{

     let context = persistentContainer.viewContext
     let request: NSFetchRequest<User> = User.fetchRequest()
    print("searching for \(word)")
      request.predicate = NSPredicate(format: "login contains[c] %@ || notes contains[c] %@ ", argumentArray: [word, word])
        
      return try context.fetch(request)

    }

    func saveNotes(itemDetail: String) {

        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        manageObject.setValue(itemDetail, forKey: "notes")
        do {
           try context.save()
            //print("note saved for \()")
        } catch {
            print("error")
        }
   }
    func updateData(login: String, notes: String?) -> Bool {
                
        var success = false
        
        let context = persistentContainer.viewContext
        
        let fetchReq:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
        fetchReq.predicate = NSPredicate(format: "login = %@",  login)
        do {
            let test = try context.fetch(fetchReq)
            let objUpd = test[0] as! NSManagedObject
            objUpd.setValue(notes ?? "Default", forKey: "notes")
            do{
                try context.save()
                success = true
            }
        } catch  {
            print(error)
        }
        return success
    }

    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}



extension CoreDataStack {
    
    func applicationDocumentsDirectory() {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "yo.BlogReaderApp" in the application's documents directory.
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }
}
