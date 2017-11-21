//
//  DirectionVC.swift
//  Preto
//
//  Created by apple on 15/08/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit
import GoogleMaps

class DirectionVC: UIViewController,getDirectionServiceAlamofire, GMSMapViewDelegate {
    
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var wazeAndAppleMapView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toOpenWithLabel: UILabelFontSize!
    
    var restaurantDataDict = NSDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        showInitialMap()
        self.mapView.delegate = self
        let restaurantName = restaurantDataDict.value(forKey: "restName") as? String ?? ""
        let htmlDecodedName = convertHtmlStringToPlainString(htmlString: restaurantName)
        titleLabel.text = htmlDecodedName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        toOpenWithLabel.text = NSLocalizedString("toOpenWith", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "toOpenWith text")
        cancelButton.setTitle(NSLocalizedString("cancel", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "cancel text"), for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        applicationDelegate.hideActivityIndicatorView()
    }
    
    func showInitialMap() {
        if(applicationDelegate.latitude != 0 && applicationDelegate.longitude != 0){
            let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: Double(applicationDelegate.latitude), longitude: Double(applicationDelegate.longitude), zoom: 15.0)
            self.mapView.camera = camera
            self.mapView.mapType = .normal
            
            
            if let restaurantLatitude = (restaurantDataDict.value(forKey: "lattitude") as AnyObject).doubleValue {
                if let restaurantLongitude = (restaurantDataDict.value(forKey: "longitude") as AnyObject).doubleValue {
                    
                    self.getDirections(destinationLatitude: restaurantLatitude, destinationLongitude: restaurantLongitude)
                    
                    // Adding markers on map
                    
                    var locationMarker1: GMSMarker!
                    var locationMarker2: GMSMarker!
                    
                    let location1 = CLLocationCoordinate2D(latitude: Double(applicationDelegate.latitude), longitude: Double(applicationDelegate.longitude))
                    
                    let location2 = CLLocationCoordinate2D(latitude: restaurantLatitude, longitude: restaurantLongitude)
                    locationMarker1 = GMSMarker(position: location1)
                    locationMarker2 = GMSMarker(position: location2)
                    
                    locationMarker1.icon = UIImage(named: "userMapIcon")
                    locationMarker2.icon = UIImage(named: "restaurantIcon")
                    
                    let restaurantName = restaurantDataDict.value(forKey: "restName") as? String ?? ""
                    let htmlDecodedName = convertHtmlStringToPlainString(htmlString: restaurantName)
                    locationMarker2.title = htmlDecodedName
                    
                    
                    let restaurantAddress = restaurantDataDict.value(forKey: "address") as? String ?? ""
                    let htmlDecodedAddress = convertHtmlStringToPlainString(htmlString: restaurantAddress)
                    locationMarker2.snippet = htmlDecodedAddress
                    
                    
                    locationMarker1.map = self.mapView
                    locationMarker2.map = self.mapView
                    
                }
            }
        }
    }
    
    func getDirections(destinationLatitude:Double, destinationLongitude:Double ) {
        if(applicationDelegate.latitude != 0 && applicationDelegate.longitude != 0){
            AlamofireIntegration.sharedInstance.getDirectionServiceDelegate = self
            AlamofireIntegration.sharedInstance.getDirections(originLatitude: applicationDelegate.latitude, originLongitude: applicationDelegate.longitude, destinationLatitude: destinationLatitude, destinationLongitude: destinationLongitude)
        }
        else{
            applicationDelegate.hideActivityIndicatorView()
        }
    }
    
    func getDirectionsResult(result:AnyObject){
        applicationDelegate.hideActivityIndicatorView()
        if result.value(forKey:"status") as! String == "OK" {
            let routesArray = result.value(forKey:"routes") as! NSArray
            let routeObject = routesArray[0] as! NSDictionary
            let overview = routeObject.value(forKey:"overview_polyline") as! NSDictionary
            
                let polylinePoints = overview.value(forKey:"points") as! String
                let path: GMSPath = GMSPath(fromEncodedPath: polylinePoints)!
                let polyLine = GMSPolyline(path: path)
                polyLine.strokeWidth = 3
                polyLine.map = self.mapView
            
            // Customizing polyline
            let styles = [GMSStrokeStyle.solidColor(.clear),
                          GMSStrokeStyle.solidColor(hexStringToUIColor(hex: "00198A"))]
            let lengths: [NSNumber] = [20, 40]
            
            polyLine.spans = GMSStyleSpans(polyLine.path!, styles, lengths,GMSLengthKind.rhumb)
        }
        else{
            showAlert(self, message: NSLocalizedString("directionsError", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "directions not found message"), title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
    }
    
    func getDirectionsError() {
        applicationDelegate.hideActivityIndicatorView()
    }
    
    // MARK: Google maps delegate
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker){
        wazeAndAppleMapView.isHidden = false
    }
    
    //MARK: UIButton actions
    
    @IBAction func backButton(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func wazeAction(_ sender: UIButton) {
        if let latitude = (restaurantDataDict.value(forKey: "lattitude") as AnyObject).doubleValue {
            if let longitude = (restaurantDataDict.value(forKey: "longitude") as AnyObject).doubleValue {
                if let url = URL(string: "waze://?ll=\(latitude),\(longitude)&navigate=yes") {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    else{
                        let itunesUrl = URL(string: wazeItunesUrl)
                        UIApplication.shared.open(itunesUrl!, options: [:], completionHandler: nil)
                    }
                }
            }
        }
        else{
            showAlert(self, message: NSLocalizedString("restaurantAddressNotFound", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "when restaurant lat long not valid or empty"), title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
    }
    
    @IBAction func googleMapAction(_ sender: UIButton) {
        if let latitude = (restaurantDataDict.value(forKey: "lattitude") as AnyObject).doubleValue {
            if let longitude = (restaurantDataDict.value(forKey: "longitude") as AnyObject).doubleValue {
                let url = URL(string: "http://maps.google.com/?saddr=\(applicationDelegate.latitude),\(applicationDelegate.longitude)&daddr=\(latitude),\(longitude)")
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
        }
        else{
            showAlert(self, message: NSLocalizedString("restaurantAddressNotFound", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "when restaurant lat long not valid or empty"), title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        wazeAndAppleMapView.isHidden = true
    }


}
