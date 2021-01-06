//
//  DataStoreFunctions.swift
//  ToggleDev2
//
//  Created by Walid Rafei on 1/5/21.
//

import Foundation
import Amplify

class DataStoreFunctions {
    func clearDataStore() {
        Amplify.DataStore.clear { result in
            switch result {
            case .success:
                print("DataStore cleared")
            case .failure(let error):
                print("Error clearing DataStore: \(error)")
            }
        }
    }
    
    func startDataStoreSyncing() {
        Amplify.DataStore.start { result in
            switch result {
            case .success:
                print("DataStore started")
            case .failure(let error):
                print("Error starting DataStore: \(error)")
            }
        }
    }
    
    func stopDataStoreSyncing() {
        Amplify.DataStore.stop { result in
            switch result {
            case .success:
                print("DataStore stopped")
            case .failure(let error):
                print("Error stopping DataStore: \(error)")
            }
        }
    }
}
