
import UIKit

class ContactUsVC: UIViewController, contactUsServiceAlamofire, UITextViewDelegate {
    
    // localization outlet
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var sendButton:UIButton!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var phoneLabel:UILabel!
    @IBOutlet weak var emailLabel:UILabel!
    @IBOutlet weak var subjectLabel:UILabel!
    @IBOutlet weak var messageLabel:UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var nameTextField:UITextField!
    @IBOutlet var phoneNumberTextField:UITextField!
    @IBOutlet var emailTextField:UITextField!
    @IBOutlet var subjectTextField:UITextField!
    @IBOutlet var messageTextView:UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = NSLocalizedString("conatctUsTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "title text")
        sendButton.setTitle(NSLocalizedString("sendButtonText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "send button title"), for: .normal)
        nameLabel.text = NSLocalizedString("nameLabel", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "textfield placeholder label")
        phoneLabel.text = NSLocalizedString("phoneLabel", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "textfield placeholder label")
        emailLabel.text = NSLocalizedString("emailLabel", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "textfield placeholder label")
        subjectLabel.text = NSLocalizedString("subjectLabel", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "textfield placeholder label")
        messageLabel.text = NSLocalizedString("messageLabel", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "textfield placeholder label")
    }
    
    //MARK: dismissing keyboard on pressing return key
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        toolbar.barTintColor = UIColor.white
        toolbar.tintColor = UIColor.black
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target:self, action:#selector(ContactUsVC.doneButtonTapped))
        doneButton.tintColor = UIColor.black
        toolbar.items = [doneButton]
        textView.inputAccessoryView = toolbar
        return true
    }
    
    func doneButtonTapped() {
        self.view.endEditing(true)
    }
    
    //MARK: validations on textField
    
    func validateEmail(_ enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    func valid() -> Bool {
        var isvalid: Bool=true
        
        let trimmedName = nameTextField.text?.trimmingCharacters(in: .whitespaces)
        let trimmedPhoneNumber = phoneNumberTextField.text?.trimmingCharacters(in: .whitespaces)
        let trimmedEmail = emailTextField.text?.trimmingCharacters(in: .whitespaces)
        let trimmedSubject = subjectTextField.text?.trimmingCharacters(in: .whitespaces)
        let trimmedMessage = messageTextView.text?.trimmingCharacters(in: .whitespaces)
        
        if trimmedName!.characters.count == 0 {
            isvalid = false
            nameTextField.text = ""
            showAlert(self, message: NSLocalizedString("signUpVc.NameFieldEmptyAlertMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when name field is empty"),title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
        if trimmedPhoneNumber!.characters.count == 0 {
            isvalid = false
            phoneNumberTextField.text = ""
            showAlert(self, message: NSLocalizedString("phoneFieldEmptyAlertMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "",comment: " message shown when phone field is empty"),title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
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
        else if trimmedSubject!.characters.count == 0 {
            isvalid = false
            subjectTextField.text = ""
            showAlert(self, message: NSLocalizedString("subjectFieldEmptyAlertMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when subject field is empty"),title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
        else if trimmedMessage!.characters.count == 0 {
            isvalid = false
            messageTextView.text = ""
            showAlert(self, message: NSLocalizedString("messageFieldEmptyAlertMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when message field is empty"),title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
        return isvalid
    }
    
    //MARK: UIButton actions
    
    @IBAction func backButton(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendButton(_ sender: AnyObject) {
        if valid() {
            let parameters = [
                "name": nameTextField.text!,
                "userID": getLoginUserId(),
                "phone": phoneNumberTextField.text!,
                "email": emailTextField.text!,
                "subject": subjectTextField.text!,
                "message": messageTextView.text!
            ]
            callContactUsApi(parameters: parameters )
        }
    }
    
    //MARK: Api's hitting methods
    
    func callContactUsApi(parameters:[String:String]) {
        if applicationDelegate.isConnectedToNetwork {
            applicationDelegate.showActivityIndicatorView()
            self.view.isUserInteractionEnabled = false
            AlamofireIntegration.sharedInstance.contactUsServiceDelegate = self
            AlamofireIntegration.sharedInstance.contactUs(parameters)
        }
        else{
            showAlert(self, message: NSLocalizedString("internetConnectivityMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when internet is not connected"), title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
    }
    
    //MARK: Api's result
    
    func contactUsResult(result:AnyObject){
        applicationDelegate.hideActivityIndicatorView()
        self.view.isUserInteractionEnabled = true
        if (result.value(forKey: successKey) as! Bool){
            let alert = UIAlertController(title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"), message: NSLocalizedString("apiSuccessMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "success message shown after contact us api"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("alert.okButtonTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "OK button title in alert"), style: .default, handler: { (UIAlertAction) in
                _ = self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true, completion: nil)
        }
        else{
            showAlert(self, message: result.value(forKey: errorKey)as! String, title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
    }
    
    func contactUsError(){
        applicationDelegate.hideActivityIndicatorView()
        self.view.isUserInteractionEnabled = true
        showAlert(self, message: NSLocalizedString("serverFailureResponseMessage", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "message shown when server response is failure"), title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
    }
    
    
    // MARK: Custom Methods
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    
}
