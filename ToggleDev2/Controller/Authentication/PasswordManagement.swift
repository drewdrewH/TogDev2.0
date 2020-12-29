//
//  PasswordManagement.swift
//  ToggleDev2
//
//  Created by Niko  on 12/28/20.
//

import Foundation
import Amplify
import AmplifyPlugins

class PasswordManagement {
    /*
     * @Param: username that wants to reset the password
     * function should call confirmResetPassword to send an email to the user.
     */
    func resetPassword(username: String) {
        Amplify.Auth.resetPassword(for: username) { result in
            do {
                let resetResult = try result.get()
                switch resetResult.nextStep {
                case .confirmResetPasswordWithCode(let deliveryDetails, let info):
                    print("Confirm reset password with code send to - \(deliveryDetails) \(String(describing: info))")
                case .done:
                    print("Reset completed")
                }
            } catch {
                print("Reset password failed with error \(error)")
            }
        }
    }
    
    /*
     * @param: username
     * @param: newPassword
     * @param: confirmationCode
     * Confirm the reset password after the code is sent. Be careful here with
     * app session (e.g. if the user force quits the app -> need to be handled).
     */
    func confirmResetPassword(
        username: String,
        newPassword: String,
        confirmationCode: String
    ) {
        Amplify.Auth.confirmResetPassword(
            for: username,
            with: newPassword,
            confirmationCode: confirmationCode
        ) { result in
            switch result {
            case .success:
                print("Password reset confirmed")
            case .failure(let error):
                print("Reset password failed with error \(error)")
            }
        }
    }
    
    /*
     @Param: oldPassword
     @Param: newPassword
     This is called if the user is signed in and wants to change his/her password.
     */
    func changePassword(oldPassword: String, newPassword: String) {
        Amplify.Auth.update(oldPassword: oldPassword, to: newPassword) { result in
            switch result {
            case .success:
                print("Change password succeeded")
            case .failure(let error):
                print("Change password failed with error \(error)")
            }
        }
    }
}

