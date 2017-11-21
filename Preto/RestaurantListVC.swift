
import UIKit
import GoogleMaps

protocol makeSearchViewVisible {
    func goBackAndMakeSearchViewVisible()
}

class RestaurantListVC: UIViewController,UITableViewDataSource,UITableViewDelegate,getRestaurantsListServiceAlamofire, markLikeServiceAlamofire,favouriteStatus, UITextFieldDelegate, GMSMapViewDelegate,getDictionaryBack {
    
    
    @IBOutlet weak var toOpenWithLabel: UILabelFontSize!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var restaurantsTableView:UITableView!
    @IBOutlet var footerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var footerActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var categoryImageView: UIImageView!
    @IBOutlet var topImageView: UIImageView!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchView: UIView!
    @IBOutlet var topImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var wazeAndAppleMapView: UIView!
    @IBOutlet var listButton: UIButton!
    @IBOutlet var mapButton: UIButton!
    @IBOutlet var bannerImageView: UIImageView!
    var bannerLaddingUrl = String()
    
    
    var restaurantsArray = NSMutableArray()
    var mapArray = NSArray()
    var parametersDict = [String:Any]()
    var offset = 1
    var isRestaurantTableUpdating = false
    var refreshControl = UIRefreshControl()
    var refresh = false
    var searchText = ""
    var currentRow = Int()
    var isComingFromFilters = false
    var restaurantDictionary = NSDictionary()
    var isSearchTextfieldUpdated = false
    
    var delegate:makeSearchViewVisible!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTextFieldChangeObserver()
        restaurantsTableView.tableFooterView = UIView()
        setCategoriesImage()
        hitGetRestaurantsListApi()
        self.mapView.delegate = self
        if (UIScreen.main.bounds.height == 568){
            self.restaurantsTableView.rowHeight = 160
        }
        else if (UIScreen.main.bounds.height == 667){
            self.restaurantsTableView.rowHeight = 175
        }
        
        // adding pull down refresh control
        self.refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("pullToRefersh", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "list text"))
        self.refreshControl.addTarget(self, action: #selector(RestaurantListVC.refresh(_:)), for: UIControlEvents.valueChanged)
        self.restaurantsTableView?.addSubview(self.refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listButton.setTitle(NSLocalizedString("list", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "list text"), for: .normal)
        mapButton.setTitle(NSLocalizedString("map", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "map text"), for: .normal)
        toOpenWithLabel.text = NSLocalizedString("toOpenWith", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "toOpenWith text")
        cancelButton.setTitle(NSLocalizedString("cancel", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "cancel text"), for: .normal)
        updateBannerImage()
    }
    
    // MARK: handling top pull down refresh
    
    func refresh(_ sender:AnyObject) {
        if(applicationDelegate.isConnectedToNetwork){
            self.offset = 1
            self.refresh = true
            hitGetRestaurantsListApi()
        }
        else{
            let alert = UIAlertController(title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"), message: NSLocalizedString("internetConnectivityMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when internet is not connected"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("alert.okButtonTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"), style: .default, handler: { (UIAlertAction) in
                self.refreshControl.endRefreshing()
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: dismissing keyboard on pressing return key
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let searchText = textField.text?.trimmingCharacters(in: .whitespaces)
        if (searchText != "") {
            self.refresh = true
            hitGetRestaurantsListApi()
        }
        searchView.isHidden = true
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchView.isHidden = true
        self.view.endEditing(true)
    }
    
    //MARK: UIButton actions
    
    @IBAction func backButton(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func homeButtonAction(_ sender: AnyObject) {
        for controller in (self.navigationController?.viewControllers)! {
            if controller.isKind(of: HomeVC.self){
                _ = self.navigationController?.popToViewController(controller, animated: true)
            }
        }
    }
    
    @IBAction func searchViewBackButtonAction(_ sender: UIButton) {
        searchView.isHidden = true
        searchTextField.text = ""
        self.view.endEditing(true)
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        searchView.isHidden = false
    }
    
    @IBAction func searchViewSearchButtonAction(_ sender: UIButton) {
        searchView.isHidden = true
        self.view.endEditing(true)
        self.refresh = true
        hitGetRestaurantsListApi()
    }
    
    @IBAction func filterButton(_ sender: AnyObject) {
        if isComingFromFilters {
            _ = self.navigationController?.popViewController(animated: true)
        }
        else{
            let advancedFiltersVcObj = self.storyboard?.instantiateViewController(withIdentifier: "advancedFiltersVc") as! AdvancedFiltersVC
            advancedFiltersVcObj.parametersDict = self.parametersDict
            advancedFiltersVcObj.delegate = self
            self.navigationController?.pushViewController(advancedFiltersVcObj, animated: true)
        }
    }
    
    func combinedDictionary(dict:[String:Any]) {
        self.parametersDict = dict
        self.refresh = true
        hitGetRestaurantsListApi()
    }
    
    @IBAction func listButtonAction(_ sender: UIButton) {
        mapView.isHidden = true
        topImageViewHeightConstraint.constant = 120
        listButton.isSelected = true
        mapButton.isSelected = false
    }
    
    @IBAction func mapButtonAction(_ sender: UIButton) {
        if !mapButton.isSelected {
            mapView.isHidden = false
            topImageViewHeightConstraint.constant = 0
            mapButton.isSelected = true
            listButton.isSelected = false
            if mapArray.count == 0 {
                hitGetRestaurantsListApiForMapView()
            }
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
    
    func hitGetRestaurantsListApiForMapView() {
        if applicationDelegate.isConnectedToNetwork {
            self.parametersDict["offset"] = 0
            applicationDelegate.showActivityIndicatorView()
            self.view.isUserInteractionEnabled = false
            AlamofireIntegration.sharedInstance.getRestaurantsListServiceDelegate = self
            AlamofireIntegration.sharedInstance.getRestaurantsList(self.parametersDict)
        }
    }
    
    @IBAction func jungleboxButton(_ sender: UIButton) {
        let instagramVcObj = self.storyboard?.instantiateViewController(withIdentifier: "instagramVc") as! InstagramVC
        if bannerLaddingUrl == "" {
            instagramVcObj.instagramUrl = jungleBoxUrl
        }else{
            instagramVcObj.instagramUrl = bannerLaddingUrl
        }
        self.navigationController?.pushViewController(instagramVcObj, animated: true)
    }
    
    func hitGetRestaurantsListApi() {
        if applicationDelegate.isConnectedToNetwork {
            if isSearchTextfieldUpdated {
                self.parametersDict["searchText"] = searchTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
            }
            self.parametersDict["offset"] = self.offset
            applicationDelegate.showActivityIndicatorView()
            self.view.isUserInteractionEnabled = false
            AlamofireIntegration.sharedInstance.getRestaurantsListServiceDelegate = self
            AlamofireIntegration.sharedInstance.getRestaurantsList(self.parametersDict)
        }
        else{
            self.restaurantsArray = CoreDataWrapper.sharedInstance.getSavedRestaurants(categoryName: getCategoryName())
            if self.restaurantsArray.count != 0 {
                self.mapArray = self.restaurantsArray
                restaurantsTableView.reloadData()
                updateMap()
            }
            else{
                showAlert(self, message: NSLocalizedString("internetConnectivityMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when internet is not connected"), title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
            }
        }
    }
    
    func callMarkLikeApi(restId:String) {
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.showActivityIndicatorView()
            self.view.isUserInteractionEnabled = false
            AlamofireIntegration.sharedInstance.markLikeServiceDelegate = self
            AlamofireIntegration.sharedInstance.markLike(userID: getLoginUserId(), restID: restId)
        }
        else{
            showAlert(self, message: NSLocalizedString("internetConnectivityMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when internet is not connected"), title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
        
    }
    
    //MARK: Api's result
    
    func getRestaurantsListResult(_ result:AnyObject){
        applicationDelegate.hideActivityIndicatorView()
        self.view.isUserInteractionEnabled = true
        footerViewHeightConstraint.constant = 0
        footerActivityIndicator.stopAnimating()
        isRestaurantTableUpdating = false
        refreshControl.endRefreshing()
        
        if (result.value(forKey: successKey) as! Bool){
            if listButton.isSelected {
                
                if refresh {
                    restaurantsArray.removeAllObjects()
                    restaurantsTableView.reloadData()
                    refresh = false
                }
                
                let dataArray = result.value(forKey: "result") as! NSArray
                for item in dataArray {
                    let dict = item as! NSDictionary
                    let mutableDict = dict.mutableCopy()
                    restaurantsArray.add(mutableDict)
                    CoreDataWrapper.sharedInstance.addRestaurant(dict: mutableDict as! NSMutableDictionary)
                }
                
                var indexPathsArray = [IndexPath]()
                for i in 0..<dataArray.count {
                    let indexPath = IndexPath(row: (restaurantsArray.count-dataArray.count+i), section: 0)
                    indexPathsArray.append(indexPath)
                }
                // updating tableview
                restaurantsTableView.beginUpdates()
                restaurantsTableView.insertRows(at: indexPathsArray, with: .fade)
                restaurantsTableView.endUpdates()
            }
            else{
                mapArray = result.value(forKey: "result") as! NSArray
                updateMap()
            }
        }
        else{
            //restaurantsArray.removeAllObjects()
            //restaurantsTableView.reloadData()
            let alert = UIAlertController(title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"), message: result.value(forKey: errorKey)as? String, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                alert.dismiss(animated: true, completion: nil)
                if self.restaurantsArray.count  == 0 {
                    if self.parametersDict["catID"] as! String == "" {
                        if self.parametersDict["searchText"] as! String != "" {
                            self.delegate.goBackAndMakeSearchViewVisible()
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }))
            present(alert, animated: true, completion: nil)
            
            //showAlert(self, message: result.value(forKey: errorKey)as! String, title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
    }
    
    func getRestaurantsListError() {
        applicationDelegate.hideActivityIndicatorView()
        self.view.isUserInteractionEnabled = true
        footerViewHeightConstraint.constant = 0
        footerActivityIndicator.stopAnimating()
        isRestaurantTableUpdating = false
        refreshControl.endRefreshing()
        self.refresh = false
        showAlert(self, message: NSLocalizedString("serverFailureResponseMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when server response is failure"), title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
    }
    
    func markLikeResult(_ result:AnyObject) {
        applicationDelegate.hideActivityIndicatorView()
        self.view.isUserInteractionEnabled = true
        if (result.value(forKey: successKey) as! Bool){
            let isLike = result.value(forKey: "result") as? Bool ?? false
            let isLikeNumberValue = isLike ? 1:0
            let currentDict = restaurantsArray[self.currentRow] as! NSMutableDictionary
            let currentLikesCount = (currentDict.value(forKey: "likesCount") as? NSNumber)?.intValue ?? 0
            
            if isLikeNumberValue == 1 {
                let newLikeCount = currentLikesCount + 1
                currentDict.setValue(newLikeCount, forKey: "likesCount")
            }
            else{
                let newLikeCount = currentLikesCount - 1
                currentDict.setValue(newLikeCount, forKey: "likesCount")
            }
            
            currentDict.setValue(isLikeNumberValue, forKey: "isLiked")
            let indexPath = IndexPath(row: self.currentRow, section: 0)
            restaurantsTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        else{
            showAlert(self, message: result.value(forKey: errorKey)as! String, title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
    }
    
    func markLikeError(){
        applicationDelegate.hideActivityIndicatorView()
        self.view.isUserInteractionEnabled = true
        showAlert(self, message: NSLocalizedString("serverFailureResponseMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when server response is failure"), title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
    }
    
    
    //MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantListTableViewCell
        let currentDict = restaurantsArray[indexPath.row] as! NSMutableDictionary
        cell.setData(dict:currentDict)
        cell.distanceButton.tag = indexPath.row
        cell.distanceButton.addTarget(self, action: #selector(RestaurantListVC.distanceButtonAction(_:)), for: .touchUpInside)
        
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(RestaurantListVC.likeButtonAction(_:)), for: .touchUpInside)
        return cell
    }
    
    func likeButtonAction(_ sender: UIButton) {
        if userDefault.bool(forKey: USER_DEFAULT_LOGIN_CHECK_Key) {
            self.currentRow = sender.tag
            let currentDict = restaurantsArray[sender.tag] as! NSMutableDictionary
            let restId = (currentDict.value(forKey: "restID") as AnyObject).stringValue
            callMarkLikeApi(restId: restId!)
        }
        else {
            moveToSelectLoginMethodScreen(reference:self)
        }
    }
    
    func distanceButtonAction(_ sender: UIButton) {
        let currentDict = restaurantsArray[sender.tag] as! NSMutableDictionary
        let directionVcObj = self.storyboard?.instantiateViewController(withIdentifier: "directionVc") as! DirectionVC
        directionVcObj.restaurantDataDict = currentDict
        self.navigationController?.pushViewController(directionVcObj, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentDict = restaurantsArray[indexPath.row] as! NSMutableDictionary
        // moving to restaurants detail screen
        let restaurantDetailVcObj = self.storyboard?.instantiateViewController(withIdentifier: "restaurantDetailVc") as! RestaurantDetailVC
        restaurantDetailVcObj.restaurantDataDict = currentDict
        restaurantDetailVcObj.favouriteDelegate = self
        self.navigationController?.pushViewController(restaurantDetailVcObj, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (applicationDelegate.isConnectedToNetwork) {
            if indexPath.row == ((self.offset)*20) {
                if (!isRestaurantTableUpdating) {
                    footerViewHeightConstraint.constant = 30
                    footerActivityIndicator.startAnimating()
                    self.offset += 1
                    hitGetRestaurantsListApi()
                    isRestaurantTableUpdating = true
                }
            }
        }
    }
    
    //MARK: Other Methods
    
    func setCategoriesImage() {
        let catId = parametersDict["catID"] as! String
        switch catId {
        case "11":
            categoryImageView.image = UIImage(named: "breakfastSmallIcon")
            topImageView.image = UIImage(named: "breakfastBG")
            categoryLabel.text = NSLocalizedString("breakFast", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "categoryName")
            
        case "13":
            categoryImageView.image = UIImage(named: "lunchFoodIcon")
            topImageView.image = UIImage(named: "lunchBG")
            categoryLabel.text = NSLocalizedString("lunch", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "categoryName")
            
        case "15":
            categoryImageView.image = UIImage(named: "dinnerFoodIcon")
            topImageView.image = UIImage(named: "dinnerBG")
            categoryLabel.text = NSLocalizedString("dinner", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "categoryName")
            
        case "19":
            categoryImageView.image = UIImage(named: "preOrderFoodIcon")
            topImageView.image = UIImage(named: "preOrderBG")
            categoryLabel.text = NSLocalizedString("preOrder", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "categoryName")
            
        case "17":
            categoryImageView.image = UIImage(named: "snacksSmallIcon")
            topImageView.image = UIImage(named: "snacksBG")
            categoryLabel.text = NSLocalizedString("snacks", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "categoryName")
            
        case "21":
            categoryImageView.image = UIImage(named: "othersFoodIcon")
            topImageView.image = UIImage(named: "othersBG")
            categoryLabel.text = NSLocalizedString("supplies", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "categoryName")
            
        case "23":
            categoryImageView.image = UIImage(named: "nearYouFoodIcon")
            topImageView.image = UIImage(named: "nearYouBG")
            categoryLabel.text = NSLocalizedString("nearYou", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "categoryName")
            
        default:
            categoryImageView.image = UIImage(named: "circularSearchIcon")
            topImageView.image = UIImage(named: "restListBackground")
            categoryLabel.text = searchText
        }
    }
    
    func getCategoryName() -> String {
        let catId = parametersDict["catID"] as! String
        switch catId {
        case "11":
            return NSLocalizedString("breakFast", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "categoryName")
            
        case "13":
            return NSLocalizedString("lunch", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "categoryName")
            
        case "15":
            return NSLocalizedString("dinner", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "categoryName")
            
        case "19":
            return NSLocalizedString("preOrder", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "categoryName")
            
        case "17":
            return NSLocalizedString("snacks", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "categoryName")
            
        case "21":
            return NSLocalizedString("supplies", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "categoryName")
            
        case "23":
            return NSLocalizedString("nearYou", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "categoryName")
            
        default:
            return ""
        }
    }
    
    func maintainLikeStatus(status:Bool, count:Int) {
        let isLikeNumberValue = status ? 1:0
        let currentDict = restaurantsArray[self.currentRow] as! NSMutableDictionary
        currentDict.setValue(isLikeNumberValue, forKey: "isLiked")
        currentDict.setValue(count, forKey: "likesCount")
        let indexPath = IndexPath(row: self.currentRow, section: 0)
        restaurantsTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: Google maps delegate
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker){
        let dict = marker.userData as! NSDictionary
        self.restaurantDictionary = dict
        wazeAndAppleMapView.isHidden = false
    }
    
    func updateMap() {
        if applicationDelegate.latitude != 0 && applicationDelegate.longitude != 0 {
            let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: applicationDelegate.latitude, longitude: applicationDelegate.longitude, zoom: 15.0)
            self.mapView.camera = camera
        }
        else{
            if let firstDict = mapArray[0] as? NSDictionary {
                if let latitude = (firstDict.value(forKey: "lattitude") as AnyObject).doubleValue {
                    if let longitude = (firstDict.value(forKey: "longitude") as AnyObject).doubleValue {
                        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
                        self.mapView.camera = camera
                    }
                }
            }
        }
        self.mapView.mapType = .normal
        
        
        // Adding user marker on map
        
        var locationMarker1: GMSMarker!
        
        let location1 = CLLocationCoordinate2D(latitude: Double(applicationDelegate.latitude), longitude: Double(applicationDelegate.longitude))
        
        locationMarker1 = GMSMarker(position: location1)
        locationMarker1.icon = UIImage(named: "userMapIcon")
        locationMarker1.map = self.mapView
        
        
        // Adding restaurants markers on map
        
        for item in mapArray {
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
    
    func addTextFieldChangeObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(RestaurantListVC.searchTextFieldUpdated(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    func searchTextFieldUpdated(_ sender: Notification) {
        isSearchTextfieldUpdated = true
    }
    
    func updateBannerImage() {
        let imageUrlString = getBannerImageUrl()
        if let url = URL(string: imageUrlString) {
            print(url)
            if UIApplication.shared.canOpenURL(url) {
                bannerImageView.sd_setImage(with: url)
            }
        }
    }
    
    func getBannerImageUrl() -> String {
        let randomNumberString = NSString(string: (applicationDelegate.randomString(length: 1)))
        let randomNumber = randomNumberString.integerValue
        if let object = applicationDelegate.jungleBoxImagesArray.at(index: randomNumber) {
            if let urlDict = object as? NSDictionary {
                let urlString = urlDict.value(forKey: "imgUrl") as? String ?? ""
                bannerLaddingUrl = urlDict.value(forKey: "url") as? String ?? ""
                return urlString
            }
        }
        return ""
    }
    
    
    
    
}
