
import UIKit

class RegistrationVC: UIViewController,signupServiceAlamofire {
    
    
    @IBOutlet weak var acceptPrivacyAndTermsLabel:UILabel!
    @IBOutlet weak var acceptLabel:UILabel!
    @IBOutlet weak var alreadHaveAccountButton:UIButton!
    @IBOutlet weak var registerButton:UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var nameTextField: UITextFieldCustomClass!
    @IBOutlet var emailTextField: UITextFieldCustomClass!
    //@IBOutlet var confirmEmailTextField: UITextFieldCustomClass!
    @IBOutlet var passwordTextField: UITextFieldCustomClass!
    @IBOutlet var checkBoxButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameTextField.placeholder = NSLocalizedString("nameTextField", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "textfield placeholder text")
        nameTextField.placeholderColor = blueAppThemeColor
        
        emailTextField.placeholder = NSLocalizedString("emailTextField", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "textfield placeholder text")
        emailTextField.placeholderColor = blueAppThemeColor
        
        //confirmEmailTextField.placeholder = NSLocalizedString("confirmEmailTextField", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "textfield placeholder text")
        //confirmEmailTextField.placeholderColor = blueAppThemeColor
        
        passwordTextField.placeholder = NSLocalizedString("password", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "textfield placeholder text")
         passwordTextField.placeholderColor = blueAppThemeColor
        
        acceptPrivacyAndTermsLabel.text = NSLocalizedString("acceptTermsAndPrivacy", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "accept terms label")
        
        acceptLabel.text = NSLocalizedString("acceptButtonText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "button text")
        
        alreadHaveAccountButton.setTitle(NSLocalizedString("alreadyHaveAccount", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "already have account button"), for: .normal)
        
        registerButton.setTitle(NSLocalizedString("registerButtonText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: " button text"), for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        applicationDelegate.hideActivityIndicatorView()
    }
    
    //MARK: dismissing keyboard on pressing return key
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    // MARK: Keyboard notifications methods
    
    func keyboardWillShow(_ sender: Notification) {
        let info: NSDictionary = sender.userInfo! as NSDictionary
        let value: NSValue = info.value(forKey: UIKeyboardFrameBeginUserInfoKey) as! NSValue
        let keyboardSize: CGSize = value.cgRectValue.size
        let keyBoardHeight = keyboardSize.height
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyBoardHeight
        self.scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(_ sender: Notification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    
    //MARK: validations on textField
    
    func validateEmail(_ enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    func valid() -> Bool {
        var isvalid: Bool=true
        
        let trimmedname = nameTextField.text?.trimmingCharacters(in: .whitespaces)
        let trimmedEmail = emailTextField.text?.trimmingCharacters(in: .whitespaces)
        let trimmedPassword = passwordTextField.text?.trimmingCharacters(in: .whitespaces)
        
        if trimmedname!.characters.count == 0 {
            isvalid = false
            nameTextField.text = ""
            showAlert(self, message: NSLocalizedString("signUpVc.NameFieldEmptyAlertMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when name field is empty"),title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
        else if trimmedEmail!.characters.count == 0 {
            isvalid = false
            emailTextField.text = ""
            showAlert(self, message: NSLocalizedString("emailFieldEmptyAlertMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when email field is empty"),title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
        else if( validateEmail(trimmedEmail!) == false){
            isvalid = false
            showAlert(self, message: NSLocalizedString("signUpVc.InvalidEmailAlertMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when email is of invalid format"),title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
//        else if confirmEmailTextField.text != emailTextField.text {
//            isvalid = false
//            showAlert(self, message: NSLocalizedString("confirmEmailErrorMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when confirm email field is incorrect"),title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
//        }
        else if trimmedPassword!.characters.count == 0 {
            isvalid = false
            passwordTextField.text = ""
            showAlert(self, message: NSLocalizedString("passwordFieldEmptyAlertMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when password field is empty"),title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
        else if !checkBoxButton.isSelected {
            isvalid = false
            showAlert(self, message: NSLocalizedString("signUpVc.checkPrivacyPolicyMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown privacy policy is uncheck"),title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
        return isvalid
    }
    
    //MARK: UIButton actions
    
    @IBAction func signupButtonAction(_ sender: AnyObject) {
        if valid(){
            self.view.endEditing(true)
            if(applicationDelegate.isConnectedToNetwork == true){
                let name = nameTextField.text!.trimmingCharacters(in: .whitespaces)
                let email = emailTextField.text!.trimmingCharacters(in: .whitespaces)
                let password = passwordTextField.text!.trimmingCharacters(in: .whitespaces)
                let firebaseToken = (userDefault.value(forKey: USER_DEFAULT_FireBaseToken)) as? String ?? ""
                
                let parameters = [
                    "name": name,
                    "emailID": email,
                    "password": password,
                    "facebookID" : "",
                    "profilePicUrl": "",
                    "firebaseTokenId": firebaseToken,
                    "deviceType": deviceType
                ]
                userDefault.set(false, forKey: USER_DEFAULT_SocialMediaLogin_Key)
                callRegistrationApi(parameters: parameters)
            }
            else{
                showAlert(self, message: NSLocalizedString("internetConnectivityMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when internet is not connected"), title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
            }
        }
    }
    
    
    @IBAction func backButton(_ sender: AnyObject) {
        self.view.endEditing(true)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkBoxButtonAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        self.checkBoxButton.isSelected = !self.checkBoxButton.isSelected
    }
    
    @IBAction func privacyPolicyButton(_ sender: AnyObject) {
        if getCurrentLanguage() == "en" {
            let Obj = self.storyboard?.instantiateViewController(withIdentifier: "privacyPolicyEnglishVc") as! PrivacyPolicyEnglishVC
            self.navigationController?.pushViewController(Obj, animated: true)
        }
        else{
            let Obj = self.storyboard?.instantiateViewController(withIdentifier: "privacyPolicyVc") as! PrivacyPolicyVC
            self.navigationController?.pushViewController(Obj, animated: true)
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
            
            getTwoStepBack()
            
//            // moving to home screen
//            let homeVcObj = self.storyboard?.instantiateViewController(withIdentifier: "homeVc") as! HomeVC
//            self.navigationController?.pushViewController(homeVcObj, animated: true)
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
    
    // MARK: Custom Methods
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(RegistrationVC.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegistrationVC.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func getTwoStepBack() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
    }
}
