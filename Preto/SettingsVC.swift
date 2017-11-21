
import UIKit

class SettingsVC: UIViewController,UITableViewDataSource,UITableViewDelegate,unRegisterFirebaseTokenServiceAlamofire {
    
    @IBOutlet var emailLabel:UILabel!
    @IBOutlet var settingsTableView:UITableView!
    @IBOutlet var bannerImageView: UIImageView!
    var bannerLaddingUrl = String()
    var settingsArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailLabel.text = userDefault.value(forKey: USER_DEFAULT_emailId_Key) as? String
    }
    
    override func viewWillAppear(_ animated: Bool) {
        settingsArray = [NSLocalizedString("privacyPolicy", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "settings array text"), NSLocalizedString("termsConditions", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "settings array text"), NSLocalizedString("help", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "settings array text"), NSLocalizedString("contactUs", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "settings array text"), NSLocalizedString("selectLanguage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "settings array text"), NSLocalizedString("logout", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "settings array text")]
        settingsTableView.reloadData()
        updateBannerImage()
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
    
    
    //MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let settingTextLabel = cell.viewWithTag(1) as! UILabel
        settingTextLabel.text = settingsArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var Obj = UIViewController()
        switch indexPath.row {
        case 0:
            if getCurrentLanguage() == "en" {
                Obj = self.storyboard?.instantiateViewController(withIdentifier: "privacyPolicyEnglishVc") as! PrivacyPolicyEnglishVC
                self.navigationController?.pushViewController(Obj, animated: true)
            }
            else{
                Obj = self.storyboard?.instantiateViewController(withIdentifier: "privacyPolicyVc") as! PrivacyPolicyVC
                self.navigationController?.pushViewController(Obj, animated: true)
            }
            
        case 1:
            if getCurrentLanguage() == "en" {
                Obj = self.storyboard?.instantiateViewController(withIdentifier: "termsAndConditionsEnglishVc") as! TermsAndConditionsEnglishVC
                self.navigationController?.pushViewController(Obj, animated: true)
            }
            else{
                Obj = self.storyboard?.instantiateViewController(withIdentifier: "termsConditionsVc") as! TermsConditionsVC
                self.navigationController?.pushViewController(Obj, animated: true)
            }
            
        case 2:
            Obj = self.storyboard?.instantiateViewController(withIdentifier: "helpVc") as! HelpVC
            self.navigationController?.pushViewController(Obj, animated: true)
            
        case 3:
            Obj = self.storyboard?.instantiateViewController(withIdentifier: "contactUsVc") as! ContactUsVC
            self.navigationController?.pushViewController(Obj, animated: true)
            
        case 4:
            Obj = self.storyboard?.instantiateViewController(withIdentifier: "selectLanguageVc") as! SelectLanguageVC
            self.navigationController?.pushViewController(Obj, animated: true)
            
        case 5:
            let alert = UIAlertController(title: nil, message: NSLocalizedString("logOutMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown in alert when user log out"), preferredStyle: .alert)
            let noButton = UIAlertAction(title: "No", style: .cancel)
            { (UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }
            
            let yesButton = UIAlertAction(title: "Yes", style: .default )
            { (UIAlertAction) in
                //self.hitUnRegisterTokenApi()
                self.logOut()
            }
            
            alert.addAction(yesButton)
            alert.addAction(noButton)
            
            self.present(alert, animated: true, completion: nil)
            
        default:
            break
        }
    }
    
    // MARK: api hitting methods
    
    func hitUnRegisterTokenApi()  {
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.showActivityIndicatorView()
            self.view.isUserInteractionEnabled = false
            AlamofireIntegration.sharedInstance.unRegisterFirebaseTokenServiceDelegate = self
            AlamofireIntegration.sharedInstance.unregisterFirebaseToken(getLoginUserId())
        }
        else{
            showAlert(self, message: NSLocalizedString("internetConnectivityMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when internet is not connected"), title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
    }
    
    // MARK: api response methods
    
    func unRegisterFirebaseTokenResult(_ result:AnyObject){
        applicationDelegate.hideActivityIndicatorView()
        self.view.isUserInteractionEnabled = true
        if (result.value(forKey: "success") as! Bool){
            logOut()
        }
        else{
            showAlert(self, message: result.value(forKey: "error")as! String, title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
    }
    
    func unRegisterFirebaseTokenError(){
        applicationDelegate.hideActivityIndicatorView()
        self.view.isUserInteractionEnabled = true
        showAlert(self, message: NSLocalizedString("serverFailureResponseMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when server response is failure"), title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
    }
    
    //MARK: Custom Methods
    
    func logOut() {
        var firebaseToken = ""
        
        // fetching firebaseToken from userdefault if not nil
        if userDefault.value(forKey: USER_DEFAULT_FireBaseToken) != nil {
            firebaseToken = userDefault.value(forKey: USER_DEFAULT_FireBaseToken) as! String
        }
        
        // Clearing NSUserDefault
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        
        // re-saving firebase token if previous exist
        if firebaseToken != "" {
            userDefault.set(firebaseToken, forKey: USER_DEFAULT_FireBaseToken)
        }
        
        //  Clearing AppDelegate Arrays and objects
        
        applicationDelegate.latitude = Double()
        applicationDelegate.longitude = Double()
        
        
        // moving to startup screen
        let selectLanguageVcObj = self.storyboard?.instantiateViewController(withIdentifier: "selectLanguageVc") as! SelectLanguageVC
        var vcArray = (applicationDelegate.window?.rootViewController as! UINavigationController).viewControllers
        vcArray.removeAll()
        vcArray.append(selectLanguageVcObj)
        (applicationDelegate.window?.rootViewController as! UINavigationController).setViewControllers(vcArray, animated: false)
        
    }
    
    func updateBannerImage() {
        let imageUrlString = getBannerImageUrl()
        print(imageUrlString)
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
