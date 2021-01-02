//
//  ViewController.swift
//  ToggleDev2
//
//  Created by Walid Rafei on 12/23/20.
//

import UIKit

class LoginVC: UIViewController {
    //MARK: - IBoutlets
    @IBOutlet weak var usernameTextField: UITextField! {
        didSet {
            setIcon(textField: usernameTextField, imageName: "person.fill")
            usernameTextField.setPlaceHolder(for: usernameTextField, with: "Username")
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            setIcon(textField: passwordTextField, imageName: "lock.fill")
            
            passwordTextField.setPlaceHolder(for: passwordTextField, with: "Password")
        }
    }
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: RoundButton!
    @IBOutlet weak var userNameBorder: UIView!
    @IBOutlet weak var passwordBorder: UIView!
    
    
    //MARK: - variables
    private let sessionManager = SessionManager()
    
    //MARK: - view life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        disableLoginButton()
        addTargetToTextFields()
    }
    
    //MARK: - action outlets
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        dismissKeyboard()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        dismissKeyboard()
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        sessionManager.signIn(username: username, password: password) {[weak self] result in
            switch result {
            case .success(let signInResult):
                if !signInResult.isSignedIn {
                    self?.goToConfirmSignUp(username: username, password: password)
                }
            case .failure(let error):
                self?.handleError(errorDescription: error.errorDescription)
            }
        }
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        dismissKeyboard()
        performSegue(withIdentifier:"goToSignUpScreen" , sender: self)
    }
}

//MARK: - Helpers

extension LoginVC {
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setIcon(textField: UITextField, imageName: String) {
        textField.tintColor = UIColor.lightGray
        textField.setLeftIcon(UIImage(systemName: imageName)!)
    }
    
    private func goToConfirmSignUp(username: String, password: String) {
        DispatchQueue.main.async {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ConfirmationVC") as? ConfirmationVC
            vc?.username = username
            vc?.password = password
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    private func disableLoginButton() {
        loginButton.backgroundColor = .lightGray
        loginButton.isEnabled = false
    }
    
    private func enableLoginButton() {
        loginButton.backgroundColor = #colorLiteral(red: 0.2588235294, green: 0.8705882353, blue: 0.8823529412, alpha: 1)
        loginButton.isEnabled = true
    }
    
    private func addTargetToTextFields() {
        [usernameTextField, passwordTextField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let username = usernameTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
        else {
            disableLoginButton()
            return
        }
        enableLoginButton()
    }
}

//MARK: - UITextFieldDelegate
extension LoginVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        if textField == usernameTextField {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionFlipFromLeft) {
                self.userNameBorder.backgroundColor = #colorLiteral(red: 0.2588235294, green: 0.8705882353, blue: 0.8823529412, alpha: 1)
            }
        } else {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionFlipFromLeft) {
                self.passwordBorder.backgroundColor = #colorLiteral(red: 0.2588235294, green: 0.8705882353, blue: 0.8823529412, alpha: 1)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == usernameTextField) {
            self.userNameBorder.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            self.passwordBorder.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        dismissKeyboard()
        return false
    }
}

