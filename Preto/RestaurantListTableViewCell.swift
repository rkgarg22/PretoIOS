
import UIKit
import SDWebImage

class RestaurantListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var typeOfFoodLabel: UILabelFontSize!
    @IBOutlet weak var typeOfFoodTitleLabel: UILabelFontSize!
    @IBOutlet weak var AverageCostLabel: UILabelFontSize!
    @IBOutlet weak var AverageCostTitleLabel: UILabelFontSize!
    @IBOutlet var streetAddress:UILabel!
    @IBOutlet var typeOfFood:UILabel!
    @IBOutlet var priceRange:UILabel!
    @IBOutlet var likesCount:UILabel!
    @IBOutlet var likeButton:UIButton!
    @IBOutlet var isOpenLabel:UILabel!
    @IBOutlet var dotLabel:UILabel!
    @IBOutlet var distanceLabel:UILabel!
    @IBOutlet var restaurantNameLabel:UILabel!
    @IBOutlet var restaurantImageView:UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var distanceButton:UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(dict:NSMutableDictionary) {
        
        typeOfFoodTitleLabel.text = NSLocalizedString("typesOfFoodText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "filter screen text") + ":"
        AverageCostTitleLabel.text = NSLocalizedString("averageCostTitle", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "average cost text") + ":"
        
        
        let typeOfFoodArray = dict.value(forKey: "typeOfFood") as! NSArray
        if typeOfFoodArray.count != 0 {
             let firstElement = typeOfFoodArray[0] as? String
            typeOfFood.text = firstElement
        }
        
        let priceFrom = dict.value(forKey: "priceFrom") as? String ?? ""
        let priceTo = dict.value(forKey: "priceTo") as? String ?? ""
        priceRange.text = NSLocalizedString("fromText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "price range from text") + priceFrom + NSLocalizedString("toText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "price range To text") + priceTo

        let address = dict.value(forKey: "address") as? String ?? ""
        streetAddress.text = convertHtmlStringToPlainString(htmlString: address)
        
        let likeCount = dict.value(forKey: "likesCount") as? NSNumber ?? 0
        self.likesCount.text = String(describing: likeCount)
        
        
        let dotColor = dict.value(forKey: "color") as? NSNumber
        if dotColor == 0 {
            dotLabel.textColor = hexStringToUIColor(hex: redDotColourString)
            isOpenLabel.text =  NSLocalizedString("closed", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "closed text")
        }
        else if dotColor == 1 {
            dotLabel.textColor = hexStringToUIColor(hex: greenDotColourString)
            isOpenLabel.text =  NSLocalizedString("openText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "open text")
        }
        else{
            dotLabel.textColor = hexStringToUIColor(hex: greyDotColourString)
            isOpenLabel.text =  NSLocalizedString("noFixedTimeText", tableName: nil, bundle: applicationDelegate.languageBundle, value: "", comment: "no fixed time text")
        }
        
        
        let isLiked = (dict.value(forKey: "isLiked") as AnyObject).boolValue ?? false
        if isLiked {
            likeButton.isSelected = true
        }
        else{
            likeButton.isSelected = false
        }
        
        if let distance = (dict.value(forKey: "distance") as AnyObject).stringValue {
            let text = distance + " km."
            distanceLabel.text = text
        }
        
         let restaurantName = dict.value(forKey: "restName") as? String ?? ""
        restaurantNameLabel.text = convertHtmlStringToPlainString(htmlString: restaurantName)
        
        let imageUrlString = dict.value(forKey: "images") as? String ?? ""
        if let imageUrl = URL(string: imageUrlString) {
            self.activityIndicator.startAnimating()
            restaurantImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder.png"), options: .retryFailed, completed: { (UIImage, NSError, SDImageCacheType, NSURL) in
                self.activityIndicator.stopAnimating()
            })
        }
        
        
    }

}
