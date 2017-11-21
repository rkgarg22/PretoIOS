
import UIKit
import MapKit

class customAnnotationClass: NSObject,MKAnnotation {

    var title: String?
    var coordinate: CLLocationCoordinate2D
    var referenceIndex: Int?
    
    init(title: String, coordinate: CLLocationCoordinate2D, referenceIndex: Int) {
        self.title = title
        self.coordinate = coordinate
        self.referenceIndex = referenceIndex
    }

}
