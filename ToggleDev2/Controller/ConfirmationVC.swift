//
//  ConfirmationVC.swift
//  ToggleDev2
//
//  Created by Walid Rafei on 12/24/20.
//

import UIKit

class ConfirmationVC: UIViewController {
    var user : User?
    //MARK: - IB Outlets
    @IBOutlet weak var welcomeLabel: UILabel!
    
    //MARK: - variables
    private var confirmationCode: [String] = []
    let sessionManager = SessionManager()
    var username = "User"
    var password = "dummy"
    
    
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.text = "Hello \(username)"
    }
    
    //MARK: - IB Actions
    @IBAction func resendCodeTapped(_ sender: UIButton) {
        sessionManager.resendSignUpConfirmationCode(username: username) {[weak self] (result) in
            switch result {
            case .success(let deliveryDetails):
                self?.showSuccessMessage(successMessage: "an email was sent to \(deliveryDetails.destination)")
            case .failure(let error):
                self?.handleError(errorDescription: error.errorDescription)
            }
        }
    }
    
    @IBAction func numberTapped(_ sender: UIButton) {
        
        if let numValue = sender.currentTitle {
            if confirmationCode.count < 6 {
                confirmationCode.append(numValue)
                let indexToAppend = confirmationCode.count
                if let imgView = self.view.viewWithTag(indexToAppend) as? UIImageView {
                    imgView.image = UIImage(systemName: "circle.fill")
                }
            }
            
            if confirmationCode.count == 6 {
                let codeInput = confirmationCode.joined()
                confirmUserCode(code: codeInput)
                clearInput()
            }
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        let indexToRemove = confirmationCode.count
        if confirmationCode.count != 0 {
            confirmationCode.removeLast()
        }
        
        if let imgView = self.view.viewWithTag(indexToRemove) as? UIImageView {
            imgView.image = UIImage(systemName: "circle")
        }
    }
    
    //MARK: - Helpers
    private func clearInput() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.confirmationCode.removeAll()
            for imgIndex in 1...6 {
                if let imgView = self.view.viewWithTag(imgIndex) as? UIImageView {
                    imgView.image = UIImage(systemName: "circle")
                }
            }
        }
    }
    
    private func confirmUserCode(code: String) {
        sessionManager.confirmSignUp(for: username, with: code) {[weak self] (result) in
            switch result {
            case .success(let authSignUpResult):
                if authSignUpResult.isSignupComplete {
                    self?.signInUserAutomatically()
                }
            case .failure(let error):
                self?.handleError(errorDescription: error.errorDescription)
            }
        }
    }
    
    private func signInUserAutomatically() {
        sessionManager.signIn(username: username, password: password) {[weak self] result in
            switch result {
            case .success(let authSignInResult):
                if authSignInResult.isSignedIn {
                    let dataManager = DataManager()
                    self!.user = User(name: self!.username)
                    dataManager.createUser(user: self!.user!)
                    print("user is signed in")
                }
            case .failure(let error):
                self?.handleError(errorDescription: error.errorDescription)
            }
        }
    }
    
}
