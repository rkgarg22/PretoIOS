
import UIKit
import CoreData

class CoreDataWrapper: NSObject {
    
    static let sharedInstance = CoreDataWrapper()
    private override init() {} //This prevents others from using the default '()' initializer for this class.
    
    //    func isEmailExist(entityName:String, predicateFromatString:String, predicateValueString:String) -> Bool {
    //        let managedObjectContext = applicationDelegate.persistentContainer.viewContext
    //        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
    //        fetchRequest.predicate = NSPredicate(format: "\(predicateFromatString) == %@", predicateValueString)
    //        var fetchedData = [NSManagedObject]()
    //        do{
    //            fetchedData = try managedObjectContext.fetch(fetchRequest)
    //            print(fetchedData)
    //        }
    //        catch let error as NSError{
    //            print(error)
    //        }
    //
    //        if fetchedData.count != 0 {
    //            return true
    //        }
    //        else{
    //            return false
    //        }
    //    }
    //
    //    func getFavouriteCoursesList() -> [NSManagedObject] {
    //        let managedObjectContext = applicationDelegate.persistentContainer.viewContext
    //        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteCourses")
    //        var fetchedData = [NSManagedObject]()
    //        do{
    //            fetchedData = try managedObjectContext.fetch(fetchRequest)
    //            print(fetchedData)
    //        }
    //        catch let error as NSError{
    //            print(error)
    //        }
    //        return fetchedData
    //    }
    //
    //    func isCourseExistInFavourite(entityName:String, predicateFromatString:String, predicateValueString:String) -> Bool {
    //        let managedObjectContext = applicationDelegate.persistentContainer.viewContext
    //        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
    //        fetchRequest.predicate = NSPredicate(format: "\(predicateFromatString) == %@", predicateValueString)
    //        var fetchedData = [NSManagedObject]()
    //        do{
    //            fetchedData = try managedObjectContext.fetch(fetchRequest)
    //            print(fetchedData)
    //        }
    //        catch let error as NSError{
    //            print(error)
    //        }
    //
    //        if fetchedData.count != 0 {
    //            return true
    //        }
    //        else{
    //            return false
    //        }
    //    }
    //
    //    func deleteCourse(courseId:String) {
    //        let managedObjectContext = applicationDelegate.persistentContainer.viewContext
    //        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteCourses")
    //        fetchRequest.predicate = NSPredicate(format: "course_id == %@", courseId)
    //        var fetchedData = [NSManagedObject]()
    //        do{
    //            fetchedData = try managedObjectContext.fetch(fetchRequest)
    //            print(fetchedData)
    //        }
    //        catch let error as NSError{
    //            print(error)
    //        }
    //        if fetchedData.count != 0 {
    //            managedObjectContext.delete(fetchedData[0])
    //            do{
    //                try managedObjectContext.save()
    //            }
    //            catch let error as NSError{
    //                print(error)
    //            }
    //        }
    //    }
    //
    //    func isUserExist(entityName:String, emailPredicateFromatString:String, emailPredicateValueString:String, passwordPredicateFromatString:String, passwordPredicateValueString:String) -> String {
    //        let managedObjectContext = applicationDelegate.persistentContainer.viewContext
    //        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
    //        fetchRequest.predicate = NSPredicate(format: "\(emailPredicateFromatString) == %@ And \(passwordPredicateFromatString) == %@", emailPredicateValueString, passwordPredicateValueString )
    //        var fetchedData = [NSManagedObject]()
    //        var ssid = ""
    //        do{
    //            fetchedData = try managedObjectContext.fetch(fetchRequest)
    //            print(fetchedData)
    //        }
    //        catch let error as NSError{
    //            print(error)
    //        }
    //
    //        if fetchedData.count != 0 {
    //            let user = fetchedData[0] as! Users
    //            ssid = user.ssid!
    //        }
    //        return ssid
    //    }
    //
    //    func getUserImage(userId:String) -> UIImage {
    //        let managedObjectContext = applicationDelegate.persistentContainer.viewContext
    //        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Users")
    //        fetchRequest.predicate = NSPredicate(format: "ssid == %@", userId)
    //        do{
    //            let fetchedData = try managedObjectContext.fetch(fetchRequest)
    //            if fetchedData.count != 0 {
    //                let user = fetchedData[0] as! Users
    //                if let imageData = user.profilePicture {
    //                    if let image = UIImage(data: imageData as Data){
    //                        return image
    //                    }
    //                }
    //            }
    //        }
    //        catch let error as NSError{
    //            print(error)
    //        }
    //        return UIImage(named: "profile")!
    //    }
    //
    //    func getUserData(userId:String) -> (String,String,String) {
    //        let managedObjectContext = applicationDelegate.persistentContainer.viewContext
    //        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Users")
    //        fetchRequest.predicate = NSPredicate(format: "ssid == %@", userId)
    //        do{
    //            let fetchedData = try managedObjectContext.fetch(fetchRequest)
    //            if fetchedData.count != 0 {
    //                let user = fetchedData[0] as! Users
    //                let firstname = user.firstName ?? ""
    //                let lastName = user.lastName ?? ""
    //                let email = user.emailId ?? ""
    //                return (firstname,lastName,email)
    //            }
    //        }
    //        catch let error as NSError{
    //            print(error)
    //        }
    //        return ("","","")
    //    }
    //
    //    func saveUserImage(userId:String, imagedata:Data) {
    //        let managedObjectContext = applicationDelegate.persistentContainer.viewContext
    //        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Users")
    //        fetchRequest.predicate = NSPredicate(format: "ssid == %@", userId)
    //        do{
    //            let fetchedData = try managedObjectContext.fetch(fetchRequest)
    //            if fetchedData.count != 0 {
    //                let user = fetchedData[0] as! Users
    //                user.profilePicture = imagedata as NSData
    //                do{
    //                    try managedObjectContext.save()
    //                }
    //                catch let error as NSError{
    //                    print("error is \(error)")
    //                }
    //            }
    //        }
    //        catch let error as NSError{
    //            print(error)
    //        }
    //    }
    //
    //    func updatePassword(userId:String, pin:String) {
    //        let managedObjectContext = applicationDelegate.persistentContainer.viewContext
    //        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Users")
    //        fetchRequest.predicate = NSPredicate(format: "ssid == %@", userId)
    //        do{
    //            let fetchedData = try managedObjectContext.fetch(fetchRequest)
    //            if fetchedData.count != 0 {
    //                let user = fetchedData[0] as! Users
    //                user.pin = pin
    //                do{
    //                    try managedObjectContext.save()
    //                }
    //                catch let error as NSError{
    //                    print("error is \(error)")
    //                }
    //            }
    //        }
    //        catch let error as NSError{
    //            print(error)
    //        }
    //    }
    
    func addRestaurant(dict:NSMutableDictionary) {
        if let restId = (dict.value(forKey: "restID") as? NSNumber)?.int16Value {
            let managedObjectContext = applicationDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Restaurant")
            fetchRequest.predicate = NSPredicate(format: "restID == %d", restId)
            var fetchedData = [NSManagedObject]()
            do{
                fetchedData = try managedObjectContext.fetch(fetchRequest)
                print(fetchedData)
            }
            catch let error as NSError{
                print(error)
            }
            
            if fetchedData.count != 0 {
                let object = fetchedData[0] as! Restaurant
                saveObject(object: object, dict: dict)
            }
            else{
                // add
                let entity = NSEntityDescription.entity(forEntityName: "Restaurant", in: managedObjectContext)
                let object = Restaurant(entity: entity!, insertInto: managedObjectContext)
                saveObject(object: object, dict: dict)
            }
        }
        else{
            return
        }
    }
    
    func saveObject(object:Restaurant, dict:NSMutableDictionary) {
        let managedObjectContext = applicationDelegate.persistentContainer.viewContext
        object.restID = (dict.value(forKey: "restID") as! NSNumber).int16Value
        
        if let isFavorite = (dict.value(forKey: "isFavourite") as? NSNumber)?.int16Value {
            object.isFavourite = isFavorite
        }
        else{
            return
        }
        
        if let typeOfFood = dict.value(forKey: "typeOfFood") as? NSArray {
            object.typeOfFood = typeOfFood
        }
        else{
            return
        }
        
        if let likesCount = (dict.value(forKey: "likesCount") as? NSNumber)?.int16Value {
            object.likesCount = likesCount
        }
        else{
            return
        }
        
        if let other = dict.value(forKey: "other") as? NSArray {
            object.other = other
        }
        else{
            return
        }
        
        if let operatingHours = dict.value(forKey: "operatingHours") as? NSArray {
            object.operatingHours = operatingHours
        }
        else{
            return
        }
        
        if let distance = (dict.value(forKey: "distance") as? NSNumber)?.int64Value {
            object.distance = distance
        }
        else{
            return
        }
        
        if let color = (dict.value(forKey: "color") as? NSNumber)?.int16Value {
            object.color = color
        }
        else{
            return
        }
        
        if let isLiked = (dict.value(forKey: "isLiked") as? NSNumber)?.int16Value {
            object.isLiked = isLiked
        }
        else{
            return
        }
        
        
        object.restName = dict.value(forKey: "restName") as? String ?? ""
        object.restDescription = dict.value(forKey: "description") as? String ?? ""
        object.isHomeDeliveryAvailable = dict.value(forKey: "isHomeDeliveryAvailable") as? String ?? ""
        object.paymentMethod = dict.value(forKey: "paymentMethod") as? String ?? ""
        object.phoneNumber = dict.value(forKey: "phoneNumber") as? String ?? ""
        object.address = dict.value(forKey: "address") as? String ?? ""
        let category = dict.value(forKey: "category") as? String ?? ""
        
        if category != "" {
            object.category = category
        }
        else{
            return
        }
        
        object.images = dict.value(forKey: "images") as? String ?? ""
        object.menu = dict.value(forKey: "menu") as? String ?? ""
        object.lattitude = dict.value(forKey: "lattitude") as? String ?? ""
        object.longitude = dict.value(forKey: "longitude") as? String ?? ""
        object.isActive = dict.value(forKey: "isActive") as? String ?? ""
        object.histroy = dict.value(forKey: "histroy") as? String ?? ""
        object.priceFrom = dict.value(forKey: "priceFrom") as? String ?? ""
        object.priceTo = dict.value(forKey: "priceTo") as? String ?? ""
        object.registered_date = dict.value(forKey: "registered_date") as? String ?? ""
        object.web_url = dict.value(forKey: "web_url") as? String ?? ""
        object.instagram_account = dict.value(forKey: "instagram_account") as? String ?? ""
        object.serviceStatus = dict.value(forKey: "serviceStatus") as? String ?? ""
        object.servicePhone = dict.value(forKey: "servicePhone") as? String ?? ""
        object.language = getCurrentLanguage()
        
        do{
            try managedObjectContext.save()
            
        }
        catch let error as NSError{
            print(error)
        }
    }
    
    func getSavedFavouriteRestaurants() -> NSMutableArray {
        let managedObjectContext = applicationDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Restaurant")
        
        fetchRequest.predicate = NSPredicate(format: "language == %@ And isFavourite == %i", getCurrentLanguage(), 1)
        
        let dataArray = NSMutableArray()
        do{
            let fetchedData = try managedObjectContext.fetch(fetchRequest)
            if fetchedData.count != 0 {
                for item in fetchedData {
                    var keyArray = [String]()
                    for key in item.entity.attributesByName.keys{
                        keyArray.append(key)
                    }
                    let dict:NSDictionary = item.dictionaryWithValues(forKeys: keyArray) as NSDictionary
                    let mutableDict = dict.mutableCopy()
                    dataArray.add(mutableDict as! NSMutableDictionary)
                }
            }
        }
        catch let error as NSError{
            print(error)
        }
        return dataArray
    }
    
    func getSavedRestaurants(categoryName:String) -> NSMutableArray {
        let managedObjectContext = applicationDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Restaurant")
        
        fetchRequest.predicate = NSPredicate(format: "language == %@ And category contains[c] %@", getCurrentLanguage(), categoryName)
        
        let dataArray = NSMutableArray()
        do{
            let fetchedData = try managedObjectContext.fetch(fetchRequest)
            if fetchedData.count != 0 {
                for item in fetchedData {
                    var keyArray = [String]()
                    for key in item.entity.attributesByName.keys{
                        keyArray.append(key)
                    }
                    let dict:NSDictionary = item.dictionaryWithValues(forKeys: keyArray) as NSDictionary
                    let mutableDict = dict.mutableCopy()
                    dataArray.add(mutableDict as! NSMutableDictionary)
                }
            }
        }
        catch let error as NSError{
            print(error)
        }
        return dataArray
    }
    
    
    
    
    
    
}








