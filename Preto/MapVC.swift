
import UIKit
import MapKit
import GoogleMaps

class MapVC: UIViewController,getRestaurantsListServiceAlamofire, GMSMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var writeYourLocationButton: UIButtonCustomClass!
    @IBOutlet weak var toOpenWithLabel: UILabelFontSize!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var searchView: UIView!
    @IBOutlet var wazeAndAppleMapView: UIView!
    @IBOutlet var searchTextField: UITextField!
    
    var restaurantsArray = NSArray()
    var restaurantDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        callGetRestaurantsListApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        writeYourLocationButton.setTitle(NSLocalizedString("writeYourLocation", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "map title text"), for: .normal)
        toOpenWithLabel.text = NSLocalizedString("toOpenWith", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "toOpenWith text")
        cancelButton.setTitle(NSLocalizedString("cancel", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "cancel text"), for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        applicationDelegate.hideActivityIndicatorView()
        self.view.endEditing(true)
    }
    
    //MARK: dismissing keyboard on pressing return key
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: UIButton actions
    
    @IBAction func backButton(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func homeButtonAction(_ sender: AnyObject) {
        for controller in (self.navigationController?.viewControllers)! {
            if controller.isKind(of: HomeVC.self){
                self.navigationController?.popToViewController(controller, animated: true)
            }
        }
    }
    
    @IBAction func enterLocationAction(_ sender: AnyObject) {
        searchView.isHidden = false
    }
    
    @IBAction func searchViewBackButtonAction(_ sender: UIButton) {
        searchView.isHidden = true
    }
    
    @IBAction func searchViewSearchButtonAction(_ sender: UIButton) {
        if searchTextField.text?.trimmingCharacters(in: .whitespaces) != "" {
            callGetRestaurantsListApi()
        }
    }
    
    @IBAction func wazeAction(_ sender: UIButton) {
        if let latitude = (restaurantDictionary.value(forKey: "lattitude") as AnyObject).doubleValue {
            if let longitude = (restaurantDictionary.value(forKey: "longitude") as AnyObject).doubleValue {
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
        if let latitude = (restaurantDictionary.value(forKey: "lattitude") as AnyObject).doubleValue {
            if let longitude = (restaurantDictionary.value(forKey: "longitude") as AnyObject).doubleValue {
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
    
    
    //MARK: Api's hitting methods
    
    func callGetRestaurantsListApi() {
        let parameters = [
            "userID": getLoginUserId(),
            "searchText": searchTextField.text ?? "",
            "catID": "",
            "language": getCurrentLanguage(),
            "offset": 0,
            "latitude": applicationDelegate.latitude,
            "longitude": applicationDelegate.longitude,
            "filters": getFiltersdict()
            ] as [String : Any]
        
        applicationDelegate.showActivityIndicatorView()
        self.view.isUserInteractionEnabled = false
        AlamofireIntegration.sharedInstance.getRestaurantsListServiceDelegate = self
        AlamofireIntegration.sharedInstance.getRestaurantsList(parameters)
    }
    
    func getFiltersdict() -> NSDictionary {
        let dict:NSDictionary = [
            "isOpen": 0,
            "fromPrice": "",
            "toPrice": "",
            "typeOfFood": "",
            "isMostLikedOne": 0,
            "isDeliveryOn": 0,
            "isPreOrder": 0,
            "paymentMethods": "",
            "categories": ""
        ]
        return dict
    }
    
    //MARK: Api's result
    
    func getRestaurantsListResult(_ result:AnyObject){
        applicationDelegate.hideActivityIndicatorView()
        self.view.isUserInteractionEnabled = true
        if (result.value(forKey: successKey) as! Bool){
            restaurantsArray = result.value(forKey: "result") as! NSArray
            if restaurantsArray.count != 0 {
                updateMap()
            }
        }
        else{
            showAlert(self, message: result.value(forKey: errorKey)as! String, title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
    }
    
    func getRestaurantsListError(){
        applicationDelegate.hideActivityIndicatorView()
        self.view.isUserInteractionEnabled = true
        showAlert(self, message: NSLocalizedString("serverFailureResponseMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when server response is failure"), title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
    }
    
    // MARK: Google maps delegate
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker){
        let dict = marker.userData as! NSDictionary
        self.restaurantDictionary = dict
        wazeAndAppleMapView.isHidden = false
    }
    
    // MARK: Custom methods
    
    func updateMap() {
        if let firstDict = restaurantsArray[0] as? NSDictionary {
            if let latitude = (firstDict.value(forKey: "lattitude") as AnyObject).doubleValue {
                if let longitude = (firstDict.value(forKey: "longitude") as AnyObject).doubleValue {
                    
                    let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 10.0)
                    self.mapView.camera = camera
                    self.mapView.mapType = .normal
                }
            }
        }
        
        
        // Adding user marker on map
        
        var locationMarker1: GMSMarker!
        
        let location1 = CLLocationCoordinate2D(latitude: Double(applicationDelegate.latitude), longitude: Double(applicationDelegate.longitude))
        
        locationMarker1 = GMSMarker(position: location1)
        locationMarker1.icon = UIImage(named: "userMapIcon")
        locationMarker1.map = self.mapView
        
        
        // Adding restaurants markers on map
        
        for item in restaurantsArray {
            let dict = item as! NSDictionary
            if let latitude = (dict.value(forKey: "lattitude") as AnyObject).doubleValue {
                if let longitude = (dict.value(forKey: "longitude") as AnyObject).doubleValue {
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let locationMarker = GMSMarker(position: location)
                    locationMarker.icon = UIImage(named: "restaurantIcon")
                    
                    let restaurantName = dict.value(forKey: "restName") as? String
                    let htmlDecodedName = convertHtmlStringToPlainString(htmlString: restaurantName!)
                    locationMarker.title = htmlDecodedName
                    
                    
                    let restaurantAddress = dict.value(forKey: "address") as? String
                    let htmlDecodedAddress = convertHtmlStringToPlainString(htmlString: restaurantAddress!)
                    locationMarker.snippet = htmlDecodedAddress
                    
                    
                    
                    locationMarker.map = self.mapView
                    locationMarker.userData = dict
                }
            }
        }
    }
    
    
}

