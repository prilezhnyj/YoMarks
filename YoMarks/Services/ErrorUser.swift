//
//  ErrorUser.swift
//  YoMarks
//
//  Created by Максим Боталов on 11.08.2022.
//

import Foundation

enum UserError {
    case cannotGedUserInfo
}

extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .cannotGedUserInfo: return NSLocalizedString("Данные о пользователе не найдены", comment: "")
        }
    }
}
