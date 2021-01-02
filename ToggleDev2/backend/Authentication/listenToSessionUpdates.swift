//
//  listenToSessionUpdates.swift
//  ToggleDev2
//
//  Created by Andrew  on 12/28/20.
//

import Foundation
import Amplify
import AmplifyPlugins

class listenToSessionUpdates {
    
    // this should not be type optional probably, will figure out later.
    private var unsubscribeToken: UnsubscribeToken? = nil;
    
    func listenToUpdates() {
        unsubscribeToken = Amplify.Hub.listen(to: .auth) { payload in
            switch payload.eventName {
            case HubPayload.EventName.Auth.signedIn:
                self.makeRootView(storyboardID: "HomeFeedScreen")
                print("User signed in (from listener)")
                

            case HubPayload.EventName.Auth.sessionExpired:
                self.makeRootView(storyboardID: "LoginScreen")
                print("Session expired (from listener)")
                // Re-authenticate the user

            case HubPayload.EventName.Auth.signedOut:
                self.makeRootView(storyboardID: "LoginScreen")
                print("User signed out (from listener)")

            default:
                break
            }
        }
    }
    
    private func makeRootView(storyboardID: String) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        DispatchQueue.main.async {
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: storyboardID)
            UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseIn) {
                UIApplication.shared.windows.first?.rootViewController = viewController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
        }
    }
}
