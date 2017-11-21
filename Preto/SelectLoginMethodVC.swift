
import UIKit

class SelectLoginMethodVC: UIViewController,FacebookDelegate,signupServiceAlamofire {
    
    // localization outlet
    @IBOutlet weak var facebookLabel:UILabel!
    @IBOutlet weak var emailLabel:UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        facebookLabel.text = NSLocalizedString("FacebookButtonText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "button text")
        emailLabel.text = NSLocalizedString("mailButtonText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "button text")
    }
    
    @IBAction func facebookButtonAction(_ sender: Any) {
        FacebookIntegration.sharedInstance.delegate = self
        FacebookIntegration.sharedInstance.fbLogin(self)
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        let registrationVcObj = self.storyboard?.instantiateViewController(withIdentifier: "registrationVc") as! RegistrationVC
        self.navigationController?.pushViewController(registrationVcObj, animated: true)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        popController()
    }
    
    func popController() {
         _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Facebook api result
    
    func fbGraphApiData(_ dict:NSDictionary){
        if let emailAddress:String = dict.value(forKey: "email") as? String {
            let pictureDict = dict.value(forKey: "picture") as! NSDictionary
            let dataDict = pictureDict.value(forKey: "data") as! NSDictionary
            let url = dataDict.value(forKey: "url")
            
            let firebaseToken = (userDefault.value(forKey: USER_DEFAULT_FireBaseToken)) as? String ?? ""
            
            let parameters = [
                "name": dict.value(forKey: "first_name"),
                "emailID": emailAddress,
                "password": "",
                "facebookID" : dict.value(forKey: "id"),
                "profilePicUrl": url,
                "firebaseTokenId": firebaseToken,
                "deviceType": deviceType
            ]
            callRegistrationApi(parameters: parameters as! [String : String])
        }
        else{
            showAlert(self, message: NSLocalizedString("facebookEmailNotExist", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "fb button title"), title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
    }
    
    //MARK: Api's hitting methods
    
    func callRegistrationApi(parameters:[String:String]) {
        applicationDelegate.showActivityIndicatorView()
        self.view.isUserInteractionEnabled = false
        AlamofireIntegration.sharedInstance.signupServiceDelegate = self
        AlamofireIntegration.sharedInstance.signUp(parameters)
    }
    
    //MARK: Api's result
    
    func signUpResult(_ result:AnyObject){
        applicationDelegate.hideActivityIndicatorView()
        self.view.isUserInteractionEnabled = true
        if (result.value(forKey: successKey) as! Bool){
            let userDict = result.value(forKey: "userInfo") as! NSDictionary
            let userID = (userDict.value(forKey: "userID")as AnyObject).stringValue
            let emailID = userDict.value(forKey: "emailID") as? String ?? ""
            
            userDefault.set(emailID, forKey: USER_DEFAULT_emailId_Key)
            userDefault.setValue(userID, forKey: USER_DEFAULT_userId_Key)
            userDefault.set(true, forKey: USER_DEFAULT_LOGIN_CHECK_Key)
            
//            // moving to home screen
//            let homeVcObj = self.storyboard?.instantiateViewController(withIdentifier: "homeVc") as! HomeVC
//            self.navigationController?.pushViewController(homeVcObj, animated: true)
            popController()
        }
        else{
            showAlert(self, message: result.value(forKey: errorKey)as! String, title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
    }
    
    func signUpError(){
        applicationDelegate.hideActivityIndicatorView()
        self.view.isUserInteractionEnabled = true
        showAlert(self, message: NSLocalizedString("serverFailureResponseMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when server response is failure"), title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
    }
    
    
    
}
