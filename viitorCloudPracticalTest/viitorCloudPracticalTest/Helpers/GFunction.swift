//
//  GFunction.swift
//  viitorCloudPracticalTest
//
//  Created by apple on 24/03/22.
//

import UIKit

enum TextFiledType {
    case name
    case email
    case phone
    case gender
    case password
    case emailPhone
}

class GFunction: NSObject {
    
    static let shared = GFunction()
    
    override init() {
        super.init()
    }
    
    internal func showAlert(title: String? , message: String? , controller: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
    internal func setRootViewController(){
        let tabView = TabbarView()
        UIApplication.shared.windows.first?.rootViewController = tabView
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    internal func createTextfiled(type: TextFiledType, placeHodler: String) -> UITextField{
        let textFiled = UITextField()
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        textFiled.placeholder = placeHodler
        textFiled.font = .preferredFont(forTextStyle: .body)
        textFiled.textColor = .black
        textFiled.borderStyle = .roundedRect
        textFiled.layer.borderColor = UIColor.lightGray.cgColor
        
        switch type {
        case .email:
            textFiled.keyboardType = .emailAddress
        case .password:
            textFiled.keyboardType = .default
            textFiled.isSecureTextEntry = true
        case .phone:
            textFiled.keyboardType = .phonePad
        default:
            textFiled.keyboardType = .default
        }
        
        return textFiled
    }
}
