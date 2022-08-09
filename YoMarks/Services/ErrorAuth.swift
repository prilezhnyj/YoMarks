//
//  ErrorAuth.swift
//  YoMarks
//
//  Created by Максим Боталов on 08.08.2022.
//

import Foundation

import Foundation

enum ErrorAuth {
    case notField
    case invalidEmail
    case passwordNotMatched
    case invalidPassword
    case unknownError
    case serverError
    case userError
}

extension ErrorAuth: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notField:
            return NSLocalizedString("Fill in all the fields.", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Invalid mail format.", comment: "")
        case .passwordNotMatched:
            return NSLocalizedString("Passwords don't match.", comment: "")
        case .unknownError:
            return NSLocalizedString("Unknown error.", comment: "")
        case .serverError:
            return NSLocalizedString("Server error.", comment: "")
        case .userError:
            return NSLocalizedString("User error.", comment: "")
        case .invalidPassword:
            return NSLocalizedString("The password format is incorrect.", comment: "")
        }
    }
}
