//
//  UIResponder+.swift
//  SimpleWeatherCheck
//
//  Created by BAE on 2/3/25.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: handler)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func showAlert(title: String, message: String, btnTitle: String, handler: ((UIAlertAction) -> Void)? ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: btnTitle, style: .default, handler: handler)
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
}
