
import UIKit
import GoogleMaps

class FavouriteRestaurantsVC: UIViewController ,UITableViewDataSource,UITableViewDelegate,getFavouriteRestaurantsListServiceAlamofire, markLikeServiceAlamofire, favouriteStatus, GMSMapViewDelegate, getJungleBoxBannerServiceAlamofire {
    
    @IBOutlet weak var toOpenWithLabel: UILabelFontSize!
    @IBOutlet weak var titleLabel: UILabelFontSize!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var restaurantsTableView:UITableView!
    @IBOutlet var footerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var footerActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var topImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var wazeAndAppleMapView: UIView!
    @IBOutlet var listButton: UIButton!
    @IBOutlet var mapButton: UIButton!
    @IBOutlet var categoryImageView: UIImageView!
    @IBOutlet var bannerImageView: UIImageView!
    var bannerLaddingUrl = String()
    
    var restaurantsArray = NSMutableArray()
    var mapArray = NSArray()
    var offset = 1
    var isRestaurantTableUpdating = false
    var refreshControl = UIRefreshControl()
    var refresh = false
    var currentRow = Int()
    var restaurantDictionary = NSDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantsTableView.tableFooterView = UIView()
        hitGetFavouriteRestaurantsListApi()
        self.mapView.delegate = self
        if (UIScreen.main.bounds.height == 568){
            self.restaurantsTableView.rowHeight = 160
        }
        else if (UIScreen.main.bounds.height == 667){
            self.restaurantsTableView.rowHeight = 175
        }
        
        // adding pull down refresh control
        self.refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("pullToRefersh", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "list text"))
        self.refreshControl.addTarget(self, action: #selector(FavouriteRestaurantsVC.refresh(_:)), for: UIControlEvents.valueChanged)
        self.restaurantsTableView?.addSubview(self.refreshControl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listButton.setTitle(NSLocalizedString("list", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "list text"), for: .normal)
        mapButton.setTitle(NSLocalizedString("map", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "map text"), for: .normal)
        toOpenWithLabel.text = NSLocalizedString("toOpenWith", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "toOpenWith text")
        cancelButton.setTitle(NSLocalizedString("cancel", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "cancel text"), for: .normal)
        titleLabel.text = NSLocalizedString("favourite", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "favourite title text")
        
        updateBannerImage()
    }
    
    // MARK: handling top pull down refresh
    
    func refresh(_ sender:AnyObject) {
        if(applicationDelegate.isConnectedToNetwork){
            self.offset = 1
            self.refresh = true
            hitGetFavouriteRestaurantsListApi()
        }
        else{
            let alert = UIAlertController(title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"), message: NSLocalizedString("internetConnectivityMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when internet is not connected"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("alert.okButtonTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"), style: .default, handler: { (UIAlertAction) in
                self.refreshControl.endRefreshing()
            }))
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    //MARK: UIButton actions
    
    @IBAction func backButton(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func listButtonAction(_ sender: UIButton) {
        mapView.isHidden = true
        topImageViewHeightConstraint.constant = 120
        categoryImageView.isHidden = false
        listButton.isSelected = true
        mapButton.isSelected = false
    }
    
    @IBAction func mapButtonAction(_ sender: UIButton) {
        if !mapButton.isSelected {
            mapView.isHidden = false
            topImageViewHeightConstraint.constant = 1
            categoryImageView.isHidden = true
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
    
    func callMarkLikeApi(restId:String) {
        applicationDelegate.showActivityIndicatorView()
        self.view.isUserInteractionEnabled = false
        AlamofireIntegration.sharedInstance.markLikeServiceDelegate = self
        AlamofireIntegration.sharedInstance.markLike(userID: getLoginUserId(), restID: restId)
    }
    
    func hitJungleBoxImagesApi() {
        if applicationDelegate.isConnectedToNetwork {
            //applicationDelegate.showActivityIndicatorView()
            //self.view.isUserInteractionEnabled = false
            AlamofireIntegration.sharedInstance.getJungleBoxBannerServiceDelegate = self
            AlamofireIntegration.sharedInstance.getJungleBoxImages()
        }
    }
    
    func hitGetRestaurantsListApiForMapView() {
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.showActivityIndicatorView()
            self.view.isUserInteractionEnabled = false
            AlamofireIntegration.sharedInstance.getFavouriteRestaurantsListServiceDelegate = self
            AlamofireIntegration.sharedInstance.getFavouriteRestaurantsList(userID: getLoginUserId(), language: getCurrentLanguage(), latitude: applicationDelegate.latitude, longitude: applicationDelegate.longitude, offset: 0)
        }
    }
    
    func hitGetFavouriteRestaurantsListApi() {
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.showActivityIndicatorView()
            self.view.isUserInteractionEnabled = false
            AlamofireIntegration.sharedInstance.getFavouriteRestaurantsListServiceDelegate = self
            AlamofireIntegration.sharedInstance.getFavouriteRestaurantsList(userID: getLoginUserId(), language: getCurrentLanguage(), latitude: applicationDelegate.latitude, longitude: applicationDelegate.longitude, offset: self.offset)
        }
        else{
            self.restaurantsArray = CoreDataWrapper.sharedInstance.getSavedFavouriteRestaurants()
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
    
    //MARK: Api's result
    
    func getJungleBoxBannerResult(result:AnyObject){
        applicationDelegate.hideActivityIndicatorView()
        self.view.isUserInteractionEnabled = true
        if (result.value(forKey: successKey) as! Bool){
            applicationDelegate.jungleBoxImagesArray = result.value(forKey: resultKey) as! NSArray
            updateBannerImage()
        }
        else{
            showAlert(self, message: result.value(forKey: errorKey)as! String, title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
    }
    
    func getJungleBoxBannerError(){
        applicationDelegate.hideActivityIndicatorView()
        self.view.isUserInteractionEnabled = true
        showAlert(self, message: NSLocalizedString("serverFailureResponseMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when server response is failure"), title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
    }
    
    
    func getFavouriteRestaurantsListResult(_ result:AnyObject){
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
                    refresh = false
                }
                
                let dataArray = result.value(forKey: "result") as! NSArray
                for item in dataArray {
                    let dict = item as! NSDictionary
                    let mutableDict = dict.mutableCopy()
                    restaurantsArray.add(mutableDict)
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
            showAlert(self, message: result.value(forKey: errorKey)as! String, title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
    }
    
    func getFavouriteRestaurantsListError(){
        applicationDelegate.hideActivityIndicatorView()
        self.view.isUserInteractionEnabled = true
        footerViewHeightConstraint.constant = 0
        footerActivityIndicator.stopAnimating()
        isRestaurantTableUpdating = false
        refreshControl.endRefreshing()
        self.refresh = false
        showAlert(self, message: NSLocalizedString("serverFailureResponseMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when server response is failure"), title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
    }
    
    func markLikeResult(_ result:AnyObject){
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
        cell.distanceButton.addTarget(self, action: #selector(FavouriteRestaurantsVC.distanceButtonAction(_:)), for: .touchUpInside)
        
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(FavouriteRestaurantsVC.likeButtonAction(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func distanceButtonAction(_ sender: UIButton) {
        let currentDict = restaurantsArray[sender.tag] as! NSMutableDictionary
        let directionVcObj = self.storyboard?.instantiateViewController(withIdentifier: "directionVc") as! DirectionVC
        directionVcObj.restaurantDataDict = currentDict
        self.navigationController?.pushViewController(directionVcObj, animated: true)
    }
    
    func likeButtonAction(_ sender: UIButton) {
        self.currentRow = sender.tag
        let currentDict = restaurantsArray[sender.tag] as! NSMutableDictionary
        let restId = (currentDict.value(forKey: "restID") as AnyObject).stringValue
        callMarkLikeApi(restId: restId!)
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
                    hitGetFavouriteRestaurantsListApi()
                    isRestaurantTableUpdating = true
                }
            }
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
