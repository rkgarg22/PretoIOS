
import UIKit
import MessageUI

protocol favouriteStatus {
    func maintainLikeStatus(status:Bool, count:Int)
}

class RestaurantDetailVC: UIViewController,markLikeServiceAlamofire,markFavouriteServiceAlamofire,MFMailComposeViewControllerDelegate,getRestaurantDetailServiceAlamofire,UIScrollViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var informationLabel: UILabelFontSize!
    @IBOutlet weak var menuTitleLabel: UILabelFontSize!
    @IBOutlet weak var menuInternalTitleLabel: UILabelFontSize!
    @IBOutlet weak var addToFavouriteLabel: UILabelFontSize!
    @IBOutlet weak var instagramLabel: UILabelFontSize!
    @IBOutlet weak var typeOfFoodTitleLabel: UILabelFontSize!
    @IBOutlet weak var categoryLabel: UILabelFontSize!
    @IBOutlet weak var opensOnLabel: UILabelFontSize!
    @IBOutlet weak var averageCostLabel: UILabelFontSize!
    @IBOutlet weak var descriptionTitleLabel: UILabelFontSize!
    @IBOutlet weak var historyTitleLabel: UILabelFontSize!
    @IBOutlet weak var paymentMethodsLabel: UILabelFontSize!
    @IBOutlet weak var otherLabel: UILabelFontSize!
    @IBOutlet weak var websiteTitleLabel: UILabelFontSize!
    @IBOutlet weak var deliveryButtonLabel: UILabelFontSize!
    @IBOutlet weak var commentsButtonLabel: UILabelFontSize!
    @IBOutlet weak var callButtonLabel: UILabelFontSize!
    @IBOutlet weak var callRecommendViewTitleLabel: UILabelFontSize!
    @IBOutlet weak var callRecommendViewDetailLabel: UILabelFontSize!
    
    
    @IBOutlet weak var restaurantImageView:UIImageView!
    @IBOutlet weak var imageBorderView:UIView!
    @IBOutlet weak var gradientView:UIView!
    @IBOutlet weak var restaurantNameLabel:UILabel!
    @IBOutlet weak var registrationDateLabel:UILabel!
    @IBOutlet weak var typeOfFoodLabel:UILabel!
    @IBOutlet weak var categoriesLabel:UILabel!
    @IBOutlet weak var streetAddressLabel:UILabel!
    @IBOutlet weak var distanceLabel:UILabel!
    @IBOutlet weak var websiteLabel:UILabel!
    @IBOutlet weak var priceRangeLabel:UILabel!
    @IBOutlet weak var descriptionLabel:UILabel!
    @IBOutlet weak var historyLabel:UILabel!
    @IBOutlet weak var wayToPay:UILabel!
    @IBOutlet weak var others:UILabel!
    @IBOutlet weak var menuLabel:UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var infoView:UIView!
    @IBOutlet weak var menuView:UIView!
    @IBOutlet weak var totalLikesLabel:UILabel!
    @IBOutlet weak var totalFavouriteLabel:UILabel!
    @IBOutlet weak var likesButton:UIButton!
    @IBOutlet weak var favouriteButton:UIButton!
    @IBOutlet weak var infoButton:UIButton!
    @IBOutlet weak var menuButton:UIButton!
    @IBOutlet weak var dotLabel:UILabel!
    @IBOutlet weak var homeDeliveryButton:UIButton!
    @IBOutlet weak var phoneButton:UIButton!
    @IBOutlet weak var emailButton:UIButton!
    @IBOutlet weak var scheduleTableview:UITableView!
    @IBOutlet weak var scheduleTableviewHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var callRecommendView:UIView!
    @IBOutlet var isOpenLabel:UILabel!
    @IBOutlet weak var historyShowHideButton:UIButton!
    @IBOutlet weak var descriptionShowHideButton:UIButton!
    
    
    @IBOutlet  var infoViewBottomConstraint:NSLayoutConstraint!
    @IBOutlet  var menuViewBottomConstraint:NSLayoutConstraint!
    
    
    var restaurantDataDict = NSMutableDictionary()
    var detailIconsArray = NSArray()
    var previousIndexPath: IndexPath!
    var operatingHoursArray = NSArray()
    var favouriteDelegate:favouriteStatus!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGradientLayer()
        hitGetRestaurantDetailApi()
        menuViewBottomConstraint.isActive = false
        menuView.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        restaurantImageView.layer.cornerRadius = restaurantImageView.bounds.size.width/2
        imageBorderView.layer.cornerRadius = imageBorderView.bounds.size.width/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        informationLabel.text = NSLocalizedString("informationText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "information button text")
        
        menuTitleLabel.text = NSLocalizedString("menuText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "menu button text")
        
        addToFavouriteLabel.text = NSLocalizedString("addToFavoritesText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "add favorites button text")
        
        typeOfFoodTitleLabel.text = NSLocalizedString("typesOfFoodText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text") + ":"
        
        categoryLabel.text = NSLocalizedString("categoryText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "category text") + ":"
        
        opensOnLabel.text = NSLocalizedString("opensOnText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "opens on text") + ":"
        
        averageCostLabel.text = NSLocalizedString("averageCostTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "average cost text") + ":"
        
        descriptionTitleLabel.text = NSLocalizedString("descriptionText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "description text")
        
        historyTitleLabel.text = NSLocalizedString("historyText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "history text")
        
        paymentMethodsLabel.text = NSLocalizedString("paymentMethods", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "payment method text")
        
        otherLabel.text = NSLocalizedString("othersText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "others text")
        
        websiteTitleLabel.text = NSLocalizedString("websiteText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "website text")
        
        deliveryButtonLabel.text = NSLocalizedString("domicilioText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "delivery button text")
        
        commentsButtonLabel.text = NSLocalizedString("commentsText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "comments button text")
        
        callButtonLabel.text = NSLocalizedString("callText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "call button text")
        
        isOpenLabel.text =  NSLocalizedString("noFixedTimeText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "no fixed time text")
        
        menuInternalTitleLabel.text = NSLocalizedString("menuText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "menu button text")
        
        callRecommendViewTitleLabel.text = NSLocalizedString("callViewPopupTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "call popup view title")
        
        callRecommendViewDetailLabel.text = NSLocalizedString("callViewDetailTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "call popup view detail")
        
        
        // historyShowHideButton.setTitle(NSLocalizedString("showText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "show text"), for: .normal)
        
        //historyShowHideButton.setTitle(NSLocalizedString("hideText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "hide text"), for: .selected)
        
        //descriptionShowHideButton.setTitle(NSLocalizedString("showText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "show text"), for: .normal)
        
        //descriptionShowHideButton.setTitle(NSLocalizedString("hideText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "hide text"), for: .selected)
    }
    
    
    //MARK: UIButton actions
    
    @IBAction func descriptionShowHideButton(_ sender: AnyObject) {
        if descriptionLabel.text == "" {
            if applicationDelegate.isConnectedToNetwork{
                let description = restaurantDataDict.value(forKey: "description") as? String ?? ""
                descriptionLabel.text = convertHtmlStringToPlainString(htmlString: description)
            }
            else{
                let description = restaurantDataDict.value(forKey: "restDescription") as? String ?? ""
                descriptionLabel.text = convertHtmlStringToPlainString(htmlString: description)
            }
        }
        else{
            descriptionLabel.text = ""
        }
    }
    
    @IBAction func historyShowHideButton(_ sender: AnyObject) {
        if historyLabel.text == "" {
            let history = restaurantDataDict.value(forKey: "histroy") as? String ?? ""
            historyLabel.text = convertHtmlStringToPlainString(htmlString: history)
        }
        else{
            historyLabel.text = ""
        }
    }
    
    
    
    @IBAction func backButton(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func homesButtonAction(_ sender: AnyObject) {
        let phoneNumber = restaurantDataDict.value(forKey: "servicePhone") as? String ?? ""
        if let url = URL(string: "tel://\(phoneNumber)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func commentsButtonAction(_ sender: AnyObject) {
        if !MFMailComposeViewController.canSendMail() {
            showAlert(self, message: NSLocalizedString("noMailAccountAlertMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when no mail account is filled in device settings"), title: NSLocalizedString("noMailAccountAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "title shown in no mail alert"))
            return
        }
        else{
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients([mailRecipient])
            composeVC.setSubject(restaurantDataDict.value(forKey: "restName") as? String ?? "")
            composeVC.setMessageBody("", isHTML: false)
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    //MARK: MF mailcomposer method
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func phoneButtonAction(_ sender: AnyObject) {
        let phoneNumber = restaurantDataDict.value(forKey: "phoneNumber") as? String ?? ""
        if let url = URL(string: "tel://\(phoneNumber)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else{
            showAlert(self, message: NSLocalizedString("phoneNumberNotAvial", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"), title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
    }
    
    @IBAction func infoButtonAction(_ sender: AnyObject) {
        infoView.isHidden = false
        menuView.isHidden = true
        infoButton.isSelected = true
        menuButton.isSelected = false
        
        infoViewBottomConstraint.isActive = true
        menuViewBottomConstraint.isActive = false
    }
    
    @IBAction func menuButtonAction(_ sender: AnyObject) {
        infoView.isHidden = true
        menuView.isHidden = false
        menuButton.isSelected = true
        infoButton.isSelected = false
        
        menuViewBottomConstraint.isActive = true
        infoViewBottomConstraint.isActive = false
    }
    
    @IBAction func likeButtonAction(_ sender: AnyObject) {
        if userDefault.bool(forKey: USER_DEFAULT_LOGIN_CHECK_Key) {
        callMarkLikeApi()
        }
        else {
            moveToSelectLoginMethodScreen(reference:self)
        }
    }
    
    @IBAction func favouriteButtonAction(_ sender: AnyObject) {
        if userDefault.bool(forKey: USER_DEFAULT_LOGIN_CHECK_Key) {
        callMarkFavouriteApi()
        }
        else {
            moveToSelectLoginMethodScreen(reference:self)
        }
    }
    
    @IBAction func instagramButtonAction(_ sender: AnyObject) {
        if let instagramURLString = restaurantDataDict.value(forKey: "instagram_account") as? String {
            if instagramURLString != "" {
                let instagramVcObj = self.storyboard?.instantiateViewController(withIdentifier: "instagramVc") as! InstagramVC
                instagramVcObj.instagramUrl = instagramURLString
                self.navigationController?.pushViewController(instagramVcObj, animated: true)
            }
        }
    }
    
    @IBAction func homeButtonAction(_ sender: AnyObject) {
        for controller in (self.navigationController?.viewControllers)! {
            if controller.isKind(of: HomeVC.self){
                self.navigationController?.popToViewController(controller, animated: true)
            }
        }
    }
    
    @IBAction func mapButtonAction(_ sender: AnyObject) {
        let directionVcObj = self.storyboard?.instantiateViewController(withIdentifier: "directionVc") as! DirectionVC
        directionVcObj.restaurantDataDict = self.restaurantDataDict
        self.navigationController?.pushViewController(directionVcObj, animated: true)
    }
    
    @IBAction func closeButtonAction(_ sender: AnyObject) {
        callRecommendView.isHidden = true
    }
    
    //MARK: Api's hitting methods
    
    func callMarkLikeApi() {
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.showActivityIndicatorView()
            self.view.isUserInteractionEnabled = false
            AlamofireIntegration.sharedInstance.markLikeServiceDelegate = self
            AlamofireIntegration.sharedInstance.markLike(userID: getLoginUserId(), restID: (restaurantDataDict.value(forKey: "restID") as AnyObject).stringValue)
        }
        else{
            showAlert(self, message: NSLocalizedString("internetConnectivityMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when internet is not connected"), title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
    }
    
    func callMarkFavouriteApi() {
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.showActivityIndicatorView()
            self.view.isUserInteractionEnabled = false
            AlamofireIntegration.sharedInstance.markFavouriteServiceDelegate = self
            AlamofireIntegration.sharedInstance.markFavourite(userID: getLoginUserId(), restID: (restaurantDataDict.value(forKey: "restID") as AnyObject).stringValue)
        }
        else{
            showAlert(self, message: NSLocalizedString("internetConnectivityMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when internet is not connected"), title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
    }
    
    func hitGetRestaurantDetailApi() {
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.showActivityIndicatorView()
            self.view.isUserInteractionEnabled = false
            AlamofireIntegration.sharedInstance.getRestaurantDetailServiceDelegate = self
            AlamofireIntegration.sharedInstance.getRestuarantDetail(userID: getLoginUserId(), language: getCurrentLanguage(), restID: (restaurantDataDict.value(forKey: "restID") as AnyObject).stringValue, latitude: applicationDelegate.latitude, longitude: applicationDelegate.longitude)
        }
        else{
            updateUI()
        }
    }
    
    //MARK: Api's result
    
    func getRestaurantDetailResult(_ result:AnyObject) {
        applicationDelegate.hideActivityIndicatorView()
        self.view.isUserInteractionEnabled = true
        if (result.value(forKey: successKey) as! Bool){
            let resultDict = (result.value(forKey: "result") as! NSDictionary).mutableCopy()
            self.restaurantDataDict = resultDict as! NSMutableDictionary
            updateUI()
        }
        else{
            showAlert(self, message: result.value(forKey: errorKey)as! String, title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
    }
    
    func getRestaurantDetailError() {
        applicationDelegate.hideActivityIndicatorView()
        self.view.isUserInteractionEnabled = true
        showAlert(self, message: NSLocalizedString("serverFailureResponseMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when server response is failure"), title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
    }
    
    func markLikeResult(_ result:AnyObject){
        applicationDelegate.hideActivityIndicatorView()
        self.view.isUserInteractionEnabled = true
        if (result.value(forKey: successKey) as! Bool){
            let isLike = result.value(forKey: "result") as? Bool ?? false
            self.likesButton.isSelected = isLike
            
            if let currentLikeCount = Int(totalLikesLabel.text!) {
                if likesButton.isSelected {
                    let newLikeCount = currentLikeCount + 1
                    totalLikesLabel.text = String(describing: newLikeCount)
                }
                else{
                    let newLikeCount = currentLikeCount - 1
                    totalLikesLabel.text = String(describing: newLikeCount)
                }
            }
            favouriteDelegate.maintainLikeStatus(status: isLike, count: Int(totalLikesLabel.text!)!)
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
    
    func markFavouriteResult(_ result:AnyObject){
        applicationDelegate.hideActivityIndicatorView()
        self.view.isUserInteractionEnabled = true
        if (result.value(forKey: successKey) as! Bool){
            let isFavourite = result.value(forKey: "result") as? Bool ?? false
            self.favouriteButton.isSelected = isFavourite
        }
        else{
            showAlert(self, message: result.value(forKey: errorKey)as! String, title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
    }
    
    func markFavouriteError(){
        applicationDelegate.hideActivityIndicatorView()
        self.view.isUserInteractionEnabled = true
        showAlert(self, message: NSLocalizedString("serverFailureResponseMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when server response is failure"), title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
    }
    
    // MARK: Custom Methods
    
    func updateUI() {
        if let typeOfFoodArray = restaurantDataDict.value(forKey: "typeOfFood") as? NSArray {
            if typeOfFoodArray.count != 0 {
                let joinedString = typeOfFoodArray.componentsJoined(by: ", ")
                typeOfFoodLabel.text = joinedString
            }
        }
        
        self.operatingHoursArray = restaurantDataDict.value(forKey: "operatingHours") as! NSArray
        scheduleTableview.reloadData()
        
        wayToPay.text = restaurantDataDict.value(forKey: "paymentMethod") as? String
        
        let otherArray = restaurantDataDict.value(forKey: "other") as! NSArray
        if otherArray.count != 0 {
            let joinedString = otherArray.componentsJoined(by: "\n")
            others.text = joinedString
        }
        
        let isLiked = restaurantDataDict.value(forKey: "isLiked") as? Bool ?? false
        likesButton.isSelected = isLiked
        
        let isFavourite = restaurantDataDict.value(forKey: "isFavourite") as? Bool ?? false
        favouriteButton.isSelected = isFavourite
        
        
        let restaurantName = restaurantDataDict.value(forKey: "restName") as? String ?? ""
        let htmlDecodedName = convertHtmlStringToPlainString(htmlString: restaurantName)
        restaurantNameLabel.text = htmlDecodedName.uppercased()
        
        registrationDateLabel.text = NSLocalizedString("registeredSinceText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "call button text") + (restaurantDataDict.value(forKey: "registered_date") as? String ?? "")
        
        categoriesLabel.text = restaurantDataDict.value(forKey: "category") as? String
        
        let address = restaurantDataDict.value(forKey: "address") as? String ?? ""
        let htmlFormattedText = convertHtmlStringToPlainString(htmlString: address)
        streetAddressLabel.text = htmlFormattedText.replacingOccurrences(of: ",", with: "\n")
        
        if let distance = restaurantDataDict.value(forKey: "distance") as? NSNumber {
            let distanceString = String(describing:distance)
            distanceLabel.text = distanceString + " km."
        }
        
        //        if applicationDelegate.isConnectedToNetwork{
        //            let description = restaurantDataDict.value(forKey: "description") as? String ?? ""
        //            descriptionLabel.text = convertHtmlStringToPlainString(htmlString: description)
        //        }
        //        else{
        //            let description = restaurantDataDict.value(forKey: "restDescription") as? String ?? ""
        //            descriptionLabel.text = convertHtmlStringToPlainString(htmlString: description)
        //        }
        
        
        
        //        let history = restaurantDataDict.value(forKey: "histroy") as? String ?? ""
        //        historyLabel.text = convertHtmlStringToPlainString(htmlString: history)
        
        
        let priceFrom = restaurantDataDict.value(forKey: "priceFrom") as? String ?? ""
        let priceTo = restaurantDataDict.value(forKey: "priceTo") as? String ?? ""
        priceRangeLabel.text = NSLocalizedString("fromText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "price range from text") + priceFrom + NSLocalizedString("toText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "price range To text") + priceTo
        
        websiteLabel.text = restaurantDataDict.value(forKey: "web_url") as? String
        menuLabel.text = restaurantDataDict.value(forKey: "menu") as? String
        
        let imageUrlString = restaurantDataDict.value(forKey: "images") as? String ?? ""
        if let imageUrl = URL(string: imageUrlString) {
            self.activityIndicator.startAnimating()
            restaurantImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder.png"), options: .retryFailed, completed: { (UIImage, NSError, SDImageCacheType, NSURL) in
                self.activityIndicator.stopAnimating()
            })
        }
        
        let likesCount = restaurantDataDict.value(forKey: "likesCount") as? NSNumber ?? 0
        totalLikesLabel.text = String(describing: likesCount)
        
        let dotColor = restaurantDataDict.value(forKey: "color") as? NSNumber
        if dotColor == 0 {
            dotLabel.textColor = hexStringToUIColor(hex: redDotColourString)
            scheduleTableviewHeightConstraint.constant = scheduleTableview.contentSize.height
        }
        else if dotColor == 1 {
            dotLabel.textColor = hexStringToUIColor(hex: greenDotColourString)
            scheduleTableviewHeightConstraint.constant = scheduleTableview.contentSize.height
        }
        else{
            isOpenLabel.isHidden = false
            scheduleTableviewHeightConstraint.constant = 0
            dotLabel.textColor = hexStringToUIColor(hex: greyDotColourString)
            self.callRecommendView.isHidden = false
        }
        
        
        let serviceStatus = restaurantDataDict.value(forKey: "serviceStatus") as? String
        if serviceStatus == "yes" {
            self.deliveryButtonLabel.isHidden = false
            self.homeDeliveryButton.isHidden = false
        }
        
        
        let phoneNumberAvailable = restaurantDataDict.value(forKey: "phoneNumber") as? String ?? ""
        if phoneNumberAvailable != "" {
            if URL(string: "tel://\(phoneNumberAvailable)") != nil {
                self.phoneButton.isEnabled = true
            }
        }
        
        
        
        let emailAvailable = restaurantDataDict.value(forKey: "email") as? String
        if emailAvailable != "" {
            self.emailButton.isEnabled = true
        }
    }
    
    
    
    //// tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operatingHoursArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantScheduleTableViewCell
        let currentDict = self.operatingHoursArray[indexPath.row] as! NSDictionary
        cell.setData(dict: currentDict)
        return cell
    }
    
    // Custom
    
    func createGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.gradientView.bounds
        let firstColor = hexStringToUIColor(hex: "00198A").cgColor
        let secondColor = hexStringToUIColor(hex: "ADF3FB").cgColor
        gradientLayer.colors = [firstColor,secondColor]
        gradientLayer.locations = [0.0, 0.5]
        
        self.gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    
    
    
}
