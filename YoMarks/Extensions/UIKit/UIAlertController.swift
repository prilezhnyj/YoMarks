//
//  UIAlertController.swift
//  YoMarks
//
//  Created by Максим Боталов on 08.08.2022.
//

import UIKit

extension UIViewController {
    func showAlert(with title: String, and message: String?, complition: @escaping () -> Void = {}) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default) { _ in
            complition()
        }
        alertController.addAction(okayAction)
        present(alertController, animated: true)
    }
}
