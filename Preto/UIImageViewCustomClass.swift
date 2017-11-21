//
//  UIImageViewCustomClass.swift
//  SureshotGPS
//
//  Created by Piyush Gupta on 8/31/16.
//  Copyright © 2016 Piyush Gupta. All rights reserved.
//

import UIKit

@IBDesignable class UIImageViewCustomClass: UIImageView {

    @IBInspectable var cornerRadius:CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable var borderWidth:CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor:UIColor {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue.cgColor }
    }
    
//    private var _round = false
//    @IBInspectable var round: Bool {
//        get {
//            return self._round
//        }
//        set {
//            _round = newValue
//            makeRound(frame.size.width)
//        }
//        
//    }
//    
////    override internal var frame: CGRect {
////        get {
////            return frame
////        }
////        set {
////            frame = newValue
////            print(newValue)
////            makeRound()
////        }
////    }
//
//     func makeRound(width:CGFloat) {
//        if self.round == true {
//            self.clipsToBounds = true
//            print(self.frame)
//            self.layer.cornerRadius = width*0.5
//            print(self.layer.cornerRadius)
//        }
//        else {
//            self.layer.cornerRadius = 0
//        }
//    }
//
    

}
