//
//  currentSessionInfo.swift
//  ToggleDev2
//
//  Created by Andrew  on 12/28/20.
//

import Foundation
import Amplify
import AmplifyPlugins

class currentSessionInfo {
    func fetchCurrentAuthSession() {
        _ = Amplify.Auth.fetchAuthSession { result in
            switch result {
            case .success(let session):
                print("Is user signed in - \(session.isSignedIn)")
            case .failure(let error):
                print("Fetch session failed with error \(error)")
            }
        }
    }
    
    func fetchAttributes() {
        Amplify.Auth.fetchUserAttributes() { result in
            switch result {
            case .success(let attributes):
                print("User attributes - \(attributes)")
            case .failure(let error):
                print("Fetching user attributes failed with error \(error)")
            }
        }
    }
    
    /*
     * this method is used to update an existing attribute or insert a new attribute
     * assosciated with the current user
     */
    func updateAttribute() {
        Amplify.Auth.update(userAttribute: AuthUserAttribute(.phoneNumber, value: "+2223334444")) { result in
            do {
                let updateResult = try result.get()
                switch updateResult.nextStep {
                case .confirmAttributeWithCode(let deliveryDetails, let info):
                    print("Confirm the attribute with details send to - \(deliveryDetails) \(String(describing: info))")
                case .done:
                    print("Update completed")
                }
            } catch {
                print("Update attribute failed with error \(error)")
            }
        }
    }
    
    /*
     * some attributes need to be confirmed to be updated. This method should be called above
     * in updateAttribute() under .confirmAttributeWithCode()
     */
    func confirmAttribute() {
        Amplify.Auth.confirm(userAttribute: .email, confirmationCode: "390739") { result in
            switch result {
            case .success:
                print("Attribute verified")
            case .failure(let error):
                print("Update attribute failed with error \(error)")
            }
        }
    }
    
    /*
     * if the code expires for the confirmAttribute() function, call resendCode()
     */
    func resendCode() {
        Amplify.Auth.resendConfirmationCode(for: .email) { result in
            switch result {
            case .success(let deliveryDetails):
                print("Resend code send to - \(deliveryDetails)")
            case .failure(let error):
                print("Resend code failed with error \(error)")
            }
        }
    }
}
