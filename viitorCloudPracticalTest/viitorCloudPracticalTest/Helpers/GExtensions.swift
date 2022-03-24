//
//  GExtensions.swift
//  viitorCloudPracticalTest
//
//  Created by apple on 24/03/22.
//

import UIKit

extension UIViewController{
    
    func showLoader(status: String, isForDuration:Bool,isIndicator: Bool) {
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: nil, message: status, preferredStyle: .alert)

            if isIndicator{
                let indicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 44, height: 50))
                indicator.startAnimating()

                alert.view.addSubview(indicator)
            }
            self.present(alert, animated: true, completion: nil)
        }
        
        if isForDuration{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                
                if self == nil{
                    return
                }
                self!.dismissLoader()
            }
        }
    }
    
    func dismissLoader(completion: (() -> Void)? = nil){
        DispatchQueue.main.async { [weak self] in
            
            if self == nil{
                return
            }
            
            self!.dismiss(animated: true) {
                if completion != nil{
                    completion!()
                }
            }
        }
    }
}

