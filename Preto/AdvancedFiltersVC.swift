
import UIKit

protocol getDictionaryBack {
    func combinedDictionary(dict:[String:Any])
}

class AdvancedFiltersVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabelFontSize!
    @IBOutlet weak var openNowLabel: UILabelFontSize!
    @IBOutlet weak var averageCostLabel: UILabelFontSize!
    @IBOutlet weak var fromLabel: UILabelFontSize!
    @IBOutlet weak var toLabel: UILabelFontSize!
    @IBOutlet weak var categoryLabel: UILabelFontSize!
    @IBOutlet weak var breakfastLabel: UILabelFontSize!
    @IBOutlet weak var lunchLabel: UILabelFontSize!
    @IBOutlet weak var dinnerLabel: UILabelFontSize!
    @IBOutlet weak var preOrderLabel: UILabelFontSize!
    @IBOutlet weak var snacksLabel: UILabelFontSize!
    @IBOutlet weak var othersLabel: UILabelFontSize!
    @IBOutlet weak var typeOfFoodLabel: UILabelFontSize!
    
    
    @IBOutlet weak var americanaLabel: UILabelFontSize!
    @IBOutlet weak var crepesLabel: UILabelFontSize!
    @IBOutlet weak var arabeLabel: UILabelFontSize!
    @IBOutlet weak var cubanaLabel: UILabelFontSize!
    @IBOutlet weak var brasileraLabel: UILabelFontSize!
    @IBOutlet weak var signatureCuisineLabel: UILabelFontSize!
    @IBOutlet weak var meatsLabel: UILabelFontSize!
    @IBOutlet weak var espanolaLabel: UILabelFontSize!
    @IBOutlet weak var cateringLabel: UILabelFontSize!
    @IBOutlet weak var FrancesaLabel: UILabelFontSize!
    @IBOutlet weak var ChinaLabel: UILabelFontSize!
    @IBOutlet weak var fusionLabel: UILabelFontSize!
    @IBOutlet weak var griegaLabel: UILabelFontSize!
    @IBOutlet weak var mexicanaLabel: UILabelFontSize!
    @IBOutlet weak var hamburgersLabel: UILabelFontSize!
    @IBOutlet weak var orientalLabel: UILabelFontSize!
    @IBOutlet weak var heladosLabel: UILabelFontSize!
    @IBOutlet weak var otrosLabel: UILabelFontSize!
    @IBOutlet weak var indiaLabel: UILabelFontSize!
    @IBOutlet weak var panaderiaLabel: UILabelFontSize!
    @IBOutlet weak var insumosLabel: UILabelFontSize!
    @IBOutlet weak var ParrillaLabel: UILabelFontSize!
    @IBOutlet weak var internationalLabel: UILabelFontSize!
    @IBOutlet weak var peruvianLabel: UILabelFontSize!
    @IBOutlet weak var italianLabel: UILabelFontSize!
    @IBOutlet weak var fishAndShellFishLabel: UILabelFontSize!
    @IBOutlet weak var japoneseLabel: UILabelFontSize!
    @IBOutlet weak var pizzaLabel: UILabelFontSize!
    @IBOutlet weak var mediterraneanLabel: UILabelFontSize!
    @IBOutlet weak var fastLabel: UILabelFontSize!
    @IBOutlet weak var reposteraiLabel: UILabelFontSize!
    @IBOutlet weak var thaiLabel: UILabelFontSize!
    @IBOutlet weak var healthyLabel: UILabelFontSize!
    @IBOutlet weak var typicalLabel: UILabelFontSize!
    @IBOutlet weak var sandwichLabel: UILabelFontSize!
    @IBOutlet weak var vegetarianLabel: UILabelFontSize!
    @IBOutlet weak var sushiLabel: UILabelFontSize!
    @IBOutlet weak var vietnamaLabel: UILabelFontSize!
    
    
    
    @IBOutlet weak var arrangeByLikesLabel: UILabelFontSize!
    @IBOutlet weak var deliveryLabel: UILabelFontSize!
    @IBOutlet weak var toGoLabel: UILabelFontSize!
    @IBOutlet weak var PaymentMethodLabel: UILabelFontSize!
    @IBOutlet weak var cashLabel: UILabelFontSize!
    @IBOutlet weak var sodexoLabel: UILabelFontSize!
    @IBOutlet weak var debitCardLabel: UILabelFontSize!
    @IBOutlet weak var bigPassLabel: UILabelFontSize!
    @IBOutlet weak var creditCardLabel: UILabelFontSize!
    @IBOutlet weak var suppliesLabel: UILabelFontSize!
    @IBOutlet weak var okButton: UIButtonCustomClass!
    
    
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var homesButton: UIButton!
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var takeAwayButton: UIButton!
    @IBOutlet weak var foodTypeViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var foodTypesView: UIView!
    @IBOutlet weak var typeOfFoodViewBottomLineLabel: UILabel!
    
    var categoriesArray = [String]()
    var foodTypeArray = [String]()
    var paymentTypeArray = [String]()
    var parametersDict = [String:Any]()
    var delegate: getDictionaryBack!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        titleLabel.text = NSLocalizedString("titleLabelText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        openNowLabel.text = NSLocalizedString("openNowText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        averageCostLabel.text = NSLocalizedString("averageCostTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        fromLabel.text = NSLocalizedString("from", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        toLabel.text = NSLocalizedString("to", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        categoryLabel.text = NSLocalizedString("categoryText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "category text")
        
        breakfastLabel.text = NSLocalizedString("breakFast", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "categoryName").capitalized
        
        lunchLabel.text = NSLocalizedString("lunch", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "categoryName").capitalized
        
        dinnerLabel.text = NSLocalizedString("dinner", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "categoryName").capitalized
        
        preOrderLabel.text = NSLocalizedString("preOrder", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "categoryName").capitalized
        
        snacksLabel.text = NSLocalizedString("snacks", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "categoryName").capitalized
        
        othersLabel.text = NSLocalizedString("supplies", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type Of payment").capitalized
        
        typeOfFoodLabel.text = NSLocalizedString("typesOfFoodText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        
        
        
        
        americanaLabel.text = NSLocalizedString("americanaText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        crepesLabel.text = NSLocalizedString("crepesText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        arabeLabel.text = NSLocalizedString("arabeText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        cubanaLabel.text = NSLocalizedString("cubanaText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        brasileraLabel.text = NSLocalizedString("brasileraText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        signatureCuisineLabel.text = NSLocalizedString("signatureCuisineText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        meatsLabel.text = NSLocalizedString("meatsText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        espanolaLabel.text = NSLocalizedString("espanolaText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        cateringLabel.text = NSLocalizedString("cateringText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        FrancesaLabel.text = NSLocalizedString("FrancesaText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        ChinaLabel.text = NSLocalizedString("ChinaText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        fusionLabel.text = NSLocalizedString("fusionText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        griegaLabel.text = NSLocalizedString("griegaText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        mexicanaLabel.text = NSLocalizedString("mexicanaText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        hamburgersLabel.text = NSLocalizedString("hamburgersText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        orientalLabel.text = NSLocalizedString("orientalText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        heladosLabel.text = NSLocalizedString("heladosText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        otrosLabel.text = NSLocalizedString("otrosText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        indiaLabel.text = NSLocalizedString("indiaText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        panaderiaLabel.text = NSLocalizedString("panaderiaText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        insumosLabel.text = NSLocalizedString("insumosText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        ParrillaLabel.text = NSLocalizedString("ParrillaText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        internationalLabel.text = NSLocalizedString("internationalText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        peruvianLabel.text = NSLocalizedString("peruvianText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        italianLabel.text = NSLocalizedString("italianText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        fishAndShellFishLabel.text = NSLocalizedString("fishAndShellFishText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        japoneseLabel.text = NSLocalizedString("japoneseText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        pizzaLabel.text = NSLocalizedString("pizzaText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        mediterraneanLabel.text = NSLocalizedString("mediterraneanText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        fastLabel.text = NSLocalizedString("fastText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        reposteraiLabel.text = NSLocalizedString("reposteraiText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        thaiLabel.text = NSLocalizedString("thaiText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        healthyLabel.text = NSLocalizedString("healthyText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        typicalLabel.text = NSLocalizedString("typicalText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        sandwichLabel.text = NSLocalizedString("sandwichText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        vegetarianLabel.text = NSLocalizedString("vegetarianText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        sushiLabel.text = NSLocalizedString("sushiText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        vietnamaLabel.text = NSLocalizedString("vietnamaText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        
        
        
        
        
        
        arrangeByLikesLabel.text = NSLocalizedString("arrangeByNoLikesText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        deliveryLabel.text = NSLocalizedString("deliveryText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        toGoLabel.text = NSLocalizedString("togoText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text")
        
        PaymentMethodLabel.text = NSLocalizedString("paymentMethodText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "payment method text")
        
        cashLabel.text = NSLocalizedString("cashText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "payment method")
        
        sodexoLabel.text = NSLocalizedString("sodexoText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "payment method")
        
        debitCardLabel.text = NSLocalizedString("debitCardText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "payment method")
        
        bigPassLabel.text = NSLocalizedString("bigPassText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "payment method")
        
        creditCardLabel.text = NSLocalizedString("creditCardText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "payment method")
        
        okButton.setTitle(NSLocalizedString("okButtonText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "payment method"), for: .normal)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barStyle = .default
        toolbar.tintColor = UIColor.white
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target:self, action:#selector(AdvancedFiltersVC.doneButtonTapped))
        doneButton.tintColor = UIColor.black
        toolbar.items = [doneButton]
        textField.inputAccessoryView = toolbar
        return true
    }
    
    func doneButtonTapped() {
        self.view.endEditing(true)
    }
    
    //MARK: UIButton actions
    
    @IBAction func backButton(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applyButton(_ sender: UIButton) {
        if valid() {
            // moving to restaurants list screen
            let restaurantListVcObj = self.storyboard?.instantiateViewController(withIdentifier: "restaurantListVc") as! RestaurantListVC
            if parametersDict.count != 0 {
                self.parametersDict["filters"] = getFiltersdict()
                self.delegate.combinedDictionary(dict: parametersDict)
                self.navigationController?.popViewController(animated: true)
            }
            else{
                let parameters = [
                    "userID": getLoginUserId(),
                    "searchText": "",
                    "catID": "",
                    "language": getCurrentLanguage(),
                    "offset": 1,
                    "latitude": applicationDelegate.latitude,
                    "longitude": applicationDelegate.longitude,
                    "filters": getFiltersdict()
                    ] as [String : Any]
                restaurantListVcObj.parametersDict = parameters
                restaurantListVcObj.isComingFromFilters = true
                self.navigationController?.pushViewController(restaurantListVcObj, animated: true)
            }
            
        }
    }
    
    @IBAction func scheduleAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func categoryAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        print(String(describing: sender.tag))
        updateCategoryArray(categoryId: String(describing: sender.tag))
    }
    
    @IBAction func typeOfFoodHeaderAction(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            foodTypeViewHeightConstraint.constant = 0
            typeOfFoodViewBottomLineLabel.isHidden = false
            for item in foodTypesView.subviews {
                item.isHidden = true
            }
        }
        else{
            sender.isSelected = true
            foodTypeViewHeightConstraint.constant = 720
            typeOfFoodViewBottomLineLabel.isHidden = true
            for item in foodTypesView.subviews {
                item.isHidden = false
            }
        }
    }
    
    @IBAction func foodTypeAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        switch sender.tag {
        case 1:
            updateFoodTypeArray(foodType: NSLocalizedString("americanaText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 2:
            updateFoodTypeArray(foodType: NSLocalizedString("crepesText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 3:
            updateFoodTypeArray(foodType: NSLocalizedString("arabeText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 4:
            updateFoodTypeArray(foodType: NSLocalizedString("cubanaText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 5:
            updateFoodTypeArray(foodType: NSLocalizedString("brasileraText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 6:
            updateFoodTypeArray(foodType: NSLocalizedString("signatureCuisineText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 7:
            updateFoodTypeArray(foodType: NSLocalizedString("meatsText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 8:
            updateFoodTypeArray(foodType: NSLocalizedString("espanolaText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 9:
            updateFoodTypeArray(foodType: NSLocalizedString("cateringText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 10:
            updateFoodTypeArray(foodType: NSLocalizedString("FrancesaText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 11:
            updateFoodTypeArray(foodType: NSLocalizedString("ChinaText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 12:
            updateFoodTypeArray(foodType: NSLocalizedString("fusionText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 13:
            updateFoodTypeArray(foodType: NSLocalizedString("griegaText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 14:
            updateFoodTypeArray(foodType: NSLocalizedString("mexicanaText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 15:
            updateFoodTypeArray(foodType: NSLocalizedString("hamburgersText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 16:
            updateFoodTypeArray(foodType: NSLocalizedString("orientalText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 17:
            updateFoodTypeArray(foodType: NSLocalizedString("heladosText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 18:
            updateFoodTypeArray(foodType: NSLocalizedString("otrosText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 19:
            updateFoodTypeArray(foodType: NSLocalizedString("indiaText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 20:
            updateFoodTypeArray(foodType: NSLocalizedString("panaderiaText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 21:
            updateFoodTypeArray(foodType: NSLocalizedString("insumosText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 22:
            updateFoodTypeArray(foodType: NSLocalizedString("ParrillaText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 23:
            updateFoodTypeArray(foodType: NSLocalizedString("internationalText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 24:
            updateFoodTypeArray(foodType: NSLocalizedString("peruvianText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 25:
            updateFoodTypeArray(foodType: NSLocalizedString("italianText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 26:
            updateFoodTypeArray(foodType: NSLocalizedString("fishAndShellFishText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 27:
            updateFoodTypeArray(foodType: NSLocalizedString("japoneseText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 28:
            updateFoodTypeArray(foodType: NSLocalizedString("pizzaText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 29:
            updateFoodTypeArray(foodType: NSLocalizedString("mediterraneanText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 30:
            updateFoodTypeArray(foodType: NSLocalizedString("fastText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 31:
            updateFoodTypeArray(foodType: NSLocalizedString("reposteraiText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 32:
            updateFoodTypeArray(foodType: NSLocalizedString("thaiText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 33:
            updateFoodTypeArray(foodType: NSLocalizedString("healthyText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 34:
            updateFoodTypeArray(foodType: NSLocalizedString("typicalText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 35:
            updateFoodTypeArray(foodType: NSLocalizedString("sandwichText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 36:
            updateFoodTypeArray(foodType: NSLocalizedString("vegetarianText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 37:
            updateFoodTypeArray(foodType: NSLocalizedString("sushiText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        case 38:
            updateFoodTypeArray(foodType: NSLocalizedString("vietnamaText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "type of food"))
            
        default:
            break
        }
    }
    
    @IBAction func homeAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func takeAwayAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func likesAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func wayToPayAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        switch sender.tag {
        case 1:
            updatePaymentTypeArray(paymentType: NSLocalizedString("cashText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "payment method"))
            
        case 2:
            updatePaymentTypeArray(paymentType: NSLocalizedString("sodexoText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "payment method"))
            
        case 3:
            updatePaymentTypeArray(paymentType: NSLocalizedString("debitCardText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "payment method"))
            
        case 4:
            updatePaymentTypeArray(paymentType: NSLocalizedString("bigPassText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "payment method"))
            
        case 5:
            updatePaymentTypeArray(paymentType: NSLocalizedString("creditCardText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "payment method"))
            
            
        default:
            break
        }
    }
    
    func getFiltersdict() -> NSDictionary {
        let dict:NSDictionary = [
            "isOpen": scheduleButton.isSelected ? 1 : 0,
            "fromPrice": fromTextField.text ?? "",
            "toPrice": toTextField.text ?? "",
            "typeOfFood": foodTypeArray.joined(separator: "|"),
            "isMostLikedOne": likesButton.isSelected ? 1 : 0,
            "isDeliveryOn": homesButton.isSelected ? 1 : 0,
            "isPreOrder": takeAwayButton.isSelected ? 1 : 0,
            "paymentMethods": paymentTypeArray.joined(separator: "|"),
            "categories": categoriesArray.joined(separator: "|")
        ]
        return dict
    }
    
    func updateCategoryArray(categoryId:String) {
        if let index = categoriesArray.index(of: categoryId) {
            categoriesArray.remove(at: index)
        }
        else{
            categoriesArray.append(categoryId)
        }
    }
    
    func updateFoodTypeArray(foodType:String) {
        if let index = foodTypeArray.index(of: foodType) {
            foodTypeArray.remove(at: index)
        }
        else{
            foodTypeArray.append(foodType)
        }
    }
    
    func updatePaymentTypeArray(paymentType:String) {
        if let index = paymentTypeArray.index(of: paymentType) {
            paymentTypeArray.remove(at: index)
        }
        else{
            paymentTypeArray.append(paymentType)
        }
    }
    
    func valid() -> Bool {
        var isvalid: Bool=true
        
        let fromAmount = fromTextField.text?.trimmingCharacters(in: .whitespaces)
        let toAmount = toTextField.text?.trimmingCharacters(in: .whitespaces)
        
        if fromAmount!.characters.count == 0 && toAmount!.characters.count != 0 {
            isvalid = false
            showAlert(self, message: NSLocalizedString("invalidRange", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "invalid range text"),title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
        else if fromAmount!.characters.count != 0 && toAmount!.characters.count == 0 {
            isvalid = false
            showAlert(self, message: NSLocalizedString("invalidRange", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "invalid range text"),title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
        }
        else if fromAmount!.characters.count != 0 && toAmount!.characters.count != 0 {
            if ((Int(toAmount!))! < (Int(fromAmount!))!) {
                isvalid = false
                fromTextField.text = ""
                toTextField.text = ""
                showAlert(self, message: NSLocalizedString("invalidRange", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "invalid range text"),title: NSLocalizedString("errorAlertTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "error title"))
            }
        }
        return isvalid
    }
    
    
    
    
    
}
