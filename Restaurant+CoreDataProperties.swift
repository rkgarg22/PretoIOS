//
//  Restaurant+CoreDataProperties.swift
//  
//
//  Created by apple on 17/09/17.
//
//

import Foundation
import CoreData


extension Restaurant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest<Restaurant>(entityName: "Restaurant")
    }

    @NSManaged public var restID: Int16
    @NSManaged public var restName: String?
    @NSManaged public var typeOfFood: NSObject?
    @NSManaged public var restDescription: String?
    @NSManaged public var isHomeDeliveryAvailable: String?
    @NSManaged public var paymentMethod: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var address: String?
    @NSManaged public var category: String?
    @NSManaged public var images: String?
    @NSManaged public var isFavourite: Int16
    @NSManaged public var likesCount: Int16
    @NSManaged public var other: NSObject?
    @NSManaged public var menu: String?
    @NSManaged public var lattitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var isActive: String?
    @NSManaged public var operatingHours: NSObject?
    @NSManaged public var distance: Int64
    @NSManaged public var histroy: String?
    @NSManaged public var priceFrom: String?
    @NSManaged public var priceTo: String?
    @NSManaged public var registered_date: String?
    @NSManaged public var web_url: String?
    @NSManaged public var instagram_account: String?
    @NSManaged public var color: Int16
    @NSManaged public var isLiked: Int16
    @NSManaged public var serviceStatus: String?
    @NSManaged public var servicePhone: String?
    @NSManaged public var language: String?

}
