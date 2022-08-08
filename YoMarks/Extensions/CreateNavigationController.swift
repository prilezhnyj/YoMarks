//
//  CreateNavigationController.swift
//  YoMarks
//
//  Created by Максим Боталов on 08.08.2022.
//

import UIKit

func createNavigationController(viewController vc: UIViewController) -> UINavigationController {
    let navigationController = UINavigationController(rootViewController: vc)
    navigationController.navigationBar.prefersLargeTitles = true
    navigationController.modalPresentationStyle = .fullScreen
    navigationController.modalTransitionStyle = .coverVertical
    return navigationController
}
