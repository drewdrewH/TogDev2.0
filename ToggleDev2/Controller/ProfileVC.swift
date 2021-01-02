//
//  ProfileVC.swift
//  ToggleDev2
//
//  Created by Walid Rafei on 1/1/21.
//

import UIKit

class ProfileVC: UIViewController {
    
    //MARK: - variables
    let sessionManager = SessionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    //MARK: - IB outlets
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        sessionManager.signOutLocally() {[weak self] error in
            if let error = error {
                self?.handleError(errorDescription: error.errorDescription)
            }
        }
    }
    
}
