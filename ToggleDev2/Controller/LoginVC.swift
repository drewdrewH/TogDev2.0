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
    //MARK: - view life cycle
    private let sessionManager = SessionManager()
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
    }
    
    //MARK: - action outlets
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        dismissKeyboard()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        dismissKeyboard()
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        sessionManager.signIn(username: username, password: password)
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        dismissKeyboard()
        performSegue(withIdentifier:"goToSignUpScreen" , sender: self)
    }
    
    @IBAction func forgotpasswordTapped(_ sender: UIButton) {
    }
    
    
    //MARK: - helpers
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setIcon(textField: UITextField, imageName: String) {
        textField.tintColor = UIColor.lightGray
        textField.setLeftIcon(UIImage(systemName: imageName)!)
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

