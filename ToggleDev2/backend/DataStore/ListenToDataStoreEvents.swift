//
//  ListenToDataStoreEvents.swift
//  ToggleDev2
//
//  Created by Walid Rafei on 1/5/21.
//

import Foundation
import Amplify
import AmplifyPlugins

enum DataStoreState {
    case ready
    case notReady
}
class ListenToDataStoreEvents {
    private var unsubscribeToken: UnsubscribeToken? = nil;
    var currentState: DataStoreState = .notReady
    
    func listenToDataStoreUpdates() {
        unsubscribeToken = Amplify.Hub.listen(to: .dataStore) {[weak self] event in
            switch event.eventName {
            //data is ready in the local store and synced from the cloud
            case HubPayload.EventName.DataStore.ready:
                DispatchQueue.main.async {
                    self?.currentState = .ready
                    NotificationCenter.default.post(name: Notification.Name("DataStoreReady"), object: nil)
                }
            default:
                break
            }
        }
    }
}
