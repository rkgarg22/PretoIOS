
import UIKit

class LoginVC: UIViewController,loginServiceAlamofire {
    
    @IBOutlet weak var signInButton:UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var emailTextField: UITextFieldCustomClass!
    @IBOutlet var passwordTextField: UITextFieldCustomClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.placeholder = NSLocalizedString("emailTextField", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "textfield placeholder text")
        emailTextField.placeholderColor = blueAppThemeColor
        passwordTextField.placeholder = NSLocalizedString("password", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "textfield placeholder text")
        passwordTextField.placeholderColor = blueAppThemeColor
        signInButton.setTitle(NSLocalizedString("signinButton", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "button text"), for: .normal)
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
        
        let trimmedEmail = emailTextField.text?.trimmingCharacters(in: .whitespaces)
        let trimmedPassword = passwordTextField.text?.trimmingCharacters(in: .whitespaces)
        
        if trimmedEmail!.characters.count == 0 {
            isvalid = false
            emailTextField.text = ""
            showAlert(self, message: NSLocalizedString("emailFieldEmptyAlertMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when email field is empty"),title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
        else if( validateEmail(trimmedEmail!) == false){
            isvalid = false
            showAlert(self, message: NSLocalizedString("signUpVc.InvalidEmailAlertMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when email is of invalid format"),title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
        else if trimmedPassword!.characters.count == 0 {
            isvalid = false
            passwordTextField.text = ""
            showAlert(self, message: NSLocalizedString("passwordFieldEmptyAlertMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when password field is empty"),title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
        return isvalid
    }
    
    //MARK: UIButton actions
    
    @IBAction func loginButtonAction(_ sender: AnyObject) {
        if valid(){
            self.view.endEditing(true)
            if(applicationDelegate.isConnectedToNetwork){
                let firebaseToken = userDefault.value(forKey: USER_DEFAULT_FireBaseToken) as? String ?? ""
                let parameters = [
                    "emailID": emailTextField.text!.trimmingCharacters(in: .whitespaces),
                    "password": passwordTextField.text!.trimmingCharacters(in: .whitespaces),
                    "firebaseTokenId": firebaseToken,
                    "deviceType": deviceType
                ]
                userDefault.set(false, forKey: USER_DEFAULT_SocialMediaLogin_Key)
                callLoginApi(parameters: parameters)
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
    
    //MARK: Api's hitting methods
    
    func callLoginApi(parameters:[String:String]) {
        applicationDelegate.showActivityIndicatorView()
        self.view.isUserInteractionEnabled = false
        AlamofireIntegration.sharedInstance.loginServiceDelegate = self
        AlamofireIntegration.sharedInstance.login(parameters)
    }
    
    //MARK: Api's result
    
    func loginResult(_ result:AnyObject){
        applicationDelegate.hideActivityIndicatorView()
        self.view.isUserInteractionEnabled = true
        if (result.value(forKey: successKey) as! Bool){
            let userDict = result.value(forKey: "userInfo") as! NSDictionary
            let userID = (userDict.value(forKey: "userID")as AnyObject).stringValue
            let emailID = userDict.value(forKey: "emailID") as? String ?? ""
            
            userDefault.set(emailID, forKey: USER_DEFAULT_emailId_Key)
            userDefault.set(userID, forKey: USER_DEFAULT_userId_Key)
            userDefault.set(true, forKey: USER_DEFAULT_LOGIN_CHECK_Key) 
            
            getThreeStepBack()
//            // moving to home screen
//            let homeVcObj = self.storyboard?.instantiateViewController(withIdentifier: "homeVc") as! HomeVC
//            self.navigationController?.pushViewController(homeVcObj, animated: true)
        }
        else{
            showAlert(self, message: result.value(forKey: errorKey)as! String, title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
    }
    
    func loginError(){
        applicationDelegate.hideActivityIndicatorView()
        self.view.isUserInteractionEnabled = true
        showAlert(self, message: NSLocalizedString("serverFailureResponseMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when server response is failure"), title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
    }
    
    // MARK: Custom Methods
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func getThreeStepBack() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true);
    }
    
}
