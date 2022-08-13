//
//  AuthTransitionProtocol.swift
//  YoMarks
//
//  Created by Максим Боталов on 08.08.2022.
//

import Foundation
import FirebaseAuth

// Protocol for more convenient and intelligent navigation between authorization controllers.
protocol AuthTransitionProtocol: AnyObject {
    func delegatePushSignUpVC()
    func delegatePushSignInVC()
    func delegatePushTaskVC(for user: User)
}
