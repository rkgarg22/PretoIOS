
import UIKit
import MapKit

class HomeVC: UIViewController, UITextFieldDelegate, getJungleBoxBannerServiceAlamofire,makeSearchViewVisible {
    
    @IBOutlet weak var breakFastLabel: UILabelFontSize!
    @IBOutlet weak var lunchLabel: UILabelFontSize!
    @IBOutlet weak var dinnerLabel: UILabelFontSize!
    @IBOutlet weak var preOrderLabel: UILabelFontSize!
    @IBOutlet weak var snacksLabel: UILabelFontSize!
    @IBOutlet weak var suppliesLabel: UILabelFontSize!
    @IBOutlet weak var nearYouLabel: UILabelFontSize!
    @IBOutlet var mapSearchTextField: UITextFieldCustomClass!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchView: UIView!
    @IBOutlet var bannerImageView: UIImageView!
    var bannerLaddingUrl = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hitJungleBoxImagesApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        breakFastLabel.text = NSLocalizedString("breakFast", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "categoryName").uppercased()
        lunchLabel.text = NSLocalizedString("lunch", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "categoryName").uppercased()
        dinnerLabel.text = NSLocalizedString("dinner", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "categoryName").uppercased()
        preOrderLabel.text = NSLocalizedString("preOrder", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "categoryName").uppercased()
        snacksLabel.text = NSLocalizedString("snacks", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "categoryName").uppercased()
        suppliesLabel.text = NSLocalizedString("supplies", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type Of payment").uppercased()
        nearYouLabel.text = NSLocalizedString("nearYou", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "categoryName").uppercased()
        mapSearchTextField.text = ""
        mapSearchTextField.placeholder = NSLocalizedString("writeYourLocation", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "map title text")
        mapSearchTextField.placeholderColor = blueAppThemeColor
        updateBannerImage()
    }
    
    //MARK: dismissing keyboard on pressing return key
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if searchTextField.text?.trimmingCharacters(in: .whitespaces) != "" || mapSearchTextField.text?.trimmingCharacters(in: .whitespaces) != "" {
            moveToRestaurantListScreen(catId: 0)
        }
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    //MARK: UIButton actions
    
    @IBAction func categoryButton(_ sender: UIButton) {
        let catId = sender.tag
        mapSearchTextField.text = ""
        searchTextField.text = ""
        moveToRestaurantListScreen(catId: catId)
    }
    
    @IBAction func settingButton(_ sender: UIButton) {
        if userDefault.bool(forKey: USER_DEFAULT_LOGIN_CHECK_Key) {
            let settingsVcObj = self.storyboard?.instantiateViewController(withIdentifier: "settingsVc") as! SettingsVC
            self.navigationController?.pushViewController(settingsVcObj, animated: true)
        }
        else {
            moveToSelectLoginMethodScreen(reference:self)
        }
    }
    
    @IBAction func favouriteButton(_ sender: UIButton) {
        if userDefault.bool(forKey: USER_DEFAULT_LOGIN_CHECK_Key) {
            let favouriteRestaurantsVcObj = self.storyboard?.instantiateViewController(withIdentifier: "favouriteRestaurantsVc") as! FavouriteRestaurantsVC
            self.navigationController?.pushViewController(favouriteRestaurantsVcObj, animated: true)
        }
        else {
            moveToSelectLoginMethodScreen(reference:self)
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
    
    @IBAction func downArrowButtonAction(_ sender: UIButton) {
        if mapSearchTextField.text?.trimmingCharacters(in: .whitespaces) != "" {
            // let mapVcObj = self.storyboard?.instantiateViewController(withIdentifier: "mapVc") as! MapVC
            // self.navigationController?.pushViewController(mapVcObj, animated: true)
            moveToRestaurantListScreen(catId: 0)
        }
    }
    
    @IBAction func searchViewBackButtonAction(_ sender: UIButton) {
        searchView.isHidden = true
        searchTextField.text = ""
        self.view.endEditing(true)
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        searchTextField.text = ""
        searchView.isHidden = false
    }
    
    @IBAction func searchViewSearchButtonAction(_ sender: UIButton) {
        if searchTextField.text?.trimmingCharacters(in: .whitespaces) != "" {
            moveToRestaurantListScreen(catId: 0)
        }
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
    
    func moveToRestaurantListScreen(catId:Int) {
        var catIdString = String(describing:catId)
        if catId == 0 {
            catIdString = ""
        }
        let restaurantListVcObj = self.storyboard?.instantiateViewController(withIdentifier: "restaurantListVc") as! RestaurantListVC
        let parameters = [
            "searchText": searchTextField.text!,
            "address": mapSearchTextField.text!,
            "userID": getLoginUserId(),
            "catID": catIdString,
            "language": getCurrentLanguage(),
            "offset": 1,
            "latitude": applicationDelegate.latitude,
            "longitude": applicationDelegate.longitude,
            "filters": getFiltersdict()
            ] as [String : Any]
        restaurantListVcObj.parametersDict = parameters
        restaurantListVcObj.delegate = self
        self.searchView.isHidden = true
        self.navigationController?.pushViewController(restaurantListVcObj, animated: true)
    }
    
    //MARK: Api's hitting methods
    
    func hitJungleBoxImagesApi() {
        if applicationDelegate.isConnectedToNetwork {
            //applicationDelegate.showActivityIndicatorView()
            //self.view.isUserInteractionEnabled = false
            AlamofireIntegration.sharedInstance.getJungleBoxBannerServiceDelegate = self
            AlamofireIntegration.sharedInstance.getJungleBoxImages()
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
    
    
    func goBackAndMakeSearchViewVisible() {
        self.searchView.isHidden = false
    }
    
    
    
}
