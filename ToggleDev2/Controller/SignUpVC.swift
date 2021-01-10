//
//  SignUpViewController.swift
//  ToggleDev2
//
//  Created by Walid Rafei on 12/23/20.
//

import UIKit

class SignUpVC: UIViewController {
    //MARK: - IBOutlets
    var user: User?
    @IBOutlet weak var userNameTextField: UITextField! {
        didSet {
            setIcon(textField: userNameTextField, imageName: "person.fill")
            userNameTextField.setPlaceHolder(for: userNameTextField, with: "Username")

        }
    }
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            setIcon(textField: emailTextField, imageName: "envelope.badge.fill")
            emailTextField.setPlaceHolder(for: emailTextField, with: "Email")
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            setIcon(textField: passwordTextField, imageName: "lock.fill")
            passwordTextField.setPlaceHolder(for: passwordTextField, with: "Password")
        }
    }
    @IBOutlet weak var confirmPasswordTextField: UITextField! {
        didSet {
            setIcon(textField: confirmPasswordTextField, imageName: "lock.fill")
            confirmPasswordTextField.setPlaceHolder(for: confirmPasswordTextField, with: "Confirm Password")
        }
    }
        
    @IBOutlet weak var userNameBorder: UIView!
    @IBOutlet weak var emailBorder: UIView!
    @IBOutlet weak var passwordBorder: UIView!
    @IBOutlet weak var confirmPasswordBorder: UIView!
    @IBOutlet weak var signUpButton: RoundButton!
    
    //MARK: - variables
    private let sessionManager = SessionManager()
        
    //MARK: - view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        disableSignUpButton()
        addTargetToTextFields()
    }

    //MARK: - IB Actions
    @IBAction func backgroundTapped(_ sender: Any) {
        dismissKeyboard()
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        dismissKeyboard()
        let username = userNameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let email = emailTextField.text ?? ""
        
        validateUserInput()
        sessionManager.signUp(username: username, password: password, email: email) {[weak self] result in
            switch result {
            case.success(let authStep):
                if case let .confirmUser(deliveryDetails, _) = authStep {
                    print("Delivery details \(String(describing: deliveryDetails))")
                    DispatchQueue.main.async {
                        self?.goToConfirmSignUp(username: username, password: password)
                    }
                }
            case .failure(let error):
                self?.handleError(errorDescription: error.errorDescription)
            }
        }
    }
    
    @IBAction func backToLoginTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - Helpers
extension SignUpVC {
    private func dismissKeyboard() {
        view.endEditing(true)
    }
        
    private func setIcon(textField: UITextField, imageName: String) {
        textField.tintColor = UIColor.lightGray
        textField.setLeftIcon(UIImage(systemName: imageName)!)
    }
    
    private func addTargetToTextFields() {
        [userNameTextField, emailTextField, passwordTextField, confirmPasswordTextField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
    }
    
    private func disableSignUpButton() {
        signUpButton.backgroundColor = .lightGray
        signUpButton.isEnabled = false
    }
    
    private func enableSignUpButton() {
        signUpButton.backgroundColor = #colorLiteral(red: 0.2588235294, green: 0.8705882353, blue: 0.8823529412, alpha: 1)
        signUpButton.isEnabled = true
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let username = userNameTextField.text, !username.isEmpty,
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty,
            let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty
        
        else {
            disableSignUpButton()
            return
        }
        enableSignUpButton()
    }
    
    private func validateUserInput() {
        if passwordTextField.text != confirmPasswordTextField.text {
            self.handleError(errorDescription: "passwords do not match.")
        } else if passwordTextField.text?.count ?? 0 < 8 {
            self.handleError(errorDescription: "password must be at least 8 characters")
        }
    }
    
    private func goToConfirmSignUp(username: String, password: String) {
        DispatchQueue.main.async {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ConfirmationVC") as? ConfirmationVC
            vc?.username = username
            vc?.password = password
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}

//MARK: - Text Field Delegate
extension SignUpVC: UITextFieldDelegate {
    
    private func animateTextField(for textField: UIView) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionFlipFromLeft) {
            textField.backgroundColor = #colorLiteral(red: 0.2588235294, green: 0.8705882353, blue: 0.8823529412, alpha: 1)
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        
        switch textField {
        case userNameTextField:
            animateTextField(for: userNameBorder)
        case emailTextField:
            animateTextField(for: emailBorder)
        case passwordTextField:
            animateTextField(for: passwordBorder)
        default:
            animateTextField(for: confirmPasswordBorder)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case userNameTextField:
            userNameBorder.backgroundColor = .white
        case emailTextField:
            emailBorder.backgroundColor = .white
        case passwordTextField:
            passwordBorder.backgroundColor = .white
        default:
            confirmPasswordBorder.backgroundColor = .white
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        dismissKeyboard()
        return false
    }
}
