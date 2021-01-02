//
//  SessionManager.swift
//  ToggleDev2
//
//  Created by Andrew  on 12/28/20.
//

import Foundation
import Amplify
import AmplifyPlugins


final class SessionManager {
    
    typealias AuthSignUpHandler = (Result<AuthSignUpStep, AuthError>) -> Void
    typealias AuthSignInHandler = (Result<AuthSignInResult, AuthError>) -> Void
    typealias confirmSignUpCodeHandler = (Result<AuthSignUpResult, AuthError>) -> Void
    typealias resendConfirmationCodeHandler = (Result<AuthCodeDeliveryDetails, AuthError>) -> Void
    typealias signOutHandler = (AuthError?) -> Void

    func signUp(username: String, password: String, email: String, completionHandler: @escaping AuthSignUpHandler) {
        
        let username = String(username.filter { !" \n\t\r".contains($0)}) // filter out white spaces
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
       
        Amplify.Auth.signUp(username: username, password: password, options: options) { result in
            switch result {
            case .success(let signUpResult):
                completionHandler(.success(signUpResult.nextStep))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    
    func confirmSignUp(for username: String, with confirmationCode: String, completionHandler: @escaping confirmSignUpCodeHandler) {
        let username = String(username.filter { !" \n\t\r".contains($0)}) // filter out white spaces
        Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { result in
            switch result {
            case .success(let result):
                completionHandler(.success(result))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    func resendSignUpConfirmationCode(username: String, completionHandler: @escaping resendConfirmationCodeHandler) {
        Amplify.Auth.resendSignUpCode(for: username) { result in
            switch result {
            case .success(let result):
                completionHandler(.success(result))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func signIn(username: String, password: String, completionHandler: @escaping AuthSignInHandler) {
        let username = String(username.filter { !" \n\t\r".contains($0)}) // filter out white spaces
        Amplify.Auth.signIn(username: username, password: password) {result in
            switch result {
            case .success(let result):
                completionHandler(.success(result))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func signOutLocally(completionHandler: @escaping signOutHandler ) {
        Amplify.Auth.signOut() {result in
            switch result {
            case .success:
                completionHandler(nil)
            case .failure(let error):
                completionHandler(error)
            }
        }
    }
}
