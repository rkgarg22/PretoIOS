//
//  UITextViewFontSize.swift
//  Preto
//
//  Created by Apple on 27/08/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class UITextViewFontSize: UITextView {

    override func awakeFromNib() {
        changeSize()
    }
    
    fileprivate func changeSize() {
        let currentSize = self.font!.pointSize
        if (UIScreen.main.bounds.height == 667){
            self.font = self.font!.withSize(currentSize-3)
        }
        else if (UIScreen.main.bounds.height == 568){
            self.font = self.font!.withSize(currentSize-5)
        }
    }


}
