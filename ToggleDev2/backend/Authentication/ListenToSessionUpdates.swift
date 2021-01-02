//
//  listenToSessionUpdates.swift
//  ToggleDev2
//
//  Created by Andrew  on 12/28/20.
//

import Foundation
import Amplify
import AmplifyPlugins

class ListenToSessionUpdates {
    
    // this should not be type optional probably, will figure out later.
    private var unsubscribeToken: UnsubscribeToken? = nil;
    
    func listenToUpdates() {
        unsubscribeToken = Amplify.Hub.listen(to: .auth) { payload in
            switch payload.eventName {
            case HubPayload.EventName.Auth.signedIn:
                self.makeRootView(ViewControllerID: "HomeFeedScreen")
                print("User signed in (from listener)")
                

            case HubPayload.EventName.Auth.sessionExpired:
                self.makeRootView(ViewControllerID: "LoginScreen")
                print("Session expired (from listener)")
                // Re-authenticate the user

            case HubPayload.EventName.Auth.signedOut:
                self.makeRootView(ViewControllerID: "LoginScreen")
                print("User signed out (from listener)")

            default:
                break
            }
        }
    }
    
    private func makeRootView(ViewControllerID: String) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
                return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerID)

            window.rootViewController = vc
            let options: UIView.AnimationOptions = .curveEaseInOut
            let duration: TimeInterval = 0.5
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion:
            { _ in })
        }
    }
}
