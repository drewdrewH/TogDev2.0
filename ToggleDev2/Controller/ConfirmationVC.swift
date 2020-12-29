//
//  ConfirmationVC.swift
//  ToggleDev2
//
//  Created by Walid Rafei on 12/24/20.
//

import UIKit

class ConfirmationVC: UIViewController {

    //MARK: - variables
    private var confirmationCode: [String] = []
    
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - IB Actions
    @IBAction func resendCodeTapped(_ sender: UIButton) {
        
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
                
                // pop view controller back 2 VCs (login screen)
                self.popBack(3)
                print("user finished inputting code \(codeInput)")
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
    
    func popBack(_ nb: Int) {
        if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            guard viewControllers.count < nb else {
                self.navigationController?.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
                return
            }
        }
    }
    
}
