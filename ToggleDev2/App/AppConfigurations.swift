//
//  AppConfigurations.swift
//  ToggleDev2
//
//  Created by Walid Rafei on 1/1/21.
//

import Foundation
import UIKit
import Amplify
import AmplifyPlugins
import AVKit
class AppConfigurations {
    
    //MARK: - amplify
    func configureAmplify() {
       do {
           let models = AmplifyModels()
           try Amplify.add(plugin: AWSCognitoAuthPlugin())
           try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: models))
           try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: models))
           try Amplify.add(plugin: AWSS3StoragePlugin())
           
           try Amplify.configure()
           print("Amplify configured with auth plugin")
       } catch {
           print("Failed to initialize Amplify with \(error)")
       }
    }
    
    //MARK: - Audio
    func configureAudio() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback)
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
    
    //MARK: - Auth state
    func listenToAuthState() {
        let sessionUpdates = ListenToSessionUpdates()
        sessionUpdates.listenToUpdates()
    }
    
    //MARK: - Data Store
    func listenToDataStoreEvents() {
        let dataStoreEvents = ListenToDataStoreEvents()
        dataStoreEvents.listenToDataStoreUpdates()
    }
}
