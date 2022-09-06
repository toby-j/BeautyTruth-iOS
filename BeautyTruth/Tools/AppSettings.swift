//
//  AppSettings.swift
//  BeautyTruth
//
//  Created by TobyDev on 30/08/2020.
//

import Foundation
import Combine

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

final class AppSettings: ObservableObject {
    private enum SettingKey: String {
        case username
        case emailNeedsConfirmation
    }
    
    let objectWillChange = ObservableObjectPublisher()
    
    @UserDefault(SettingKey.username.rawValue, defaultValue: "")
    var username: String {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault(SettingKey.emailNeedsConfirmation.rawValue, defaultValue: "")
    var emailNeedsConfirmation: String {
        willSet {
            objectWillChange.send()
        }
    }
}
