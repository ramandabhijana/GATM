//
//  MyProfile.swift
//  GATM
//
//  Created by Abhijana Agung Ramanda on 22/07/20.
//  Copyright © 2020 Abhijana Agung Ramanda. All rights reserved.
//

import UIKit

struct MyProfile {
    static let stateLoginKey = "state"
    static let firstNameKey = "first name"
    static let lastNameKey = "last name"
    static let nationalityKey = "nationality"
    static let photoKey = "photo"
    
    static var isLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: stateLoginKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: stateLoginKey)
        }
    }
    
    static var firstName: String {
        get {
            return UserDefaults.standard.string(forKey: firstNameKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: firstNameKey)
        }
    }
    
    static var lastName: String {
        get {
            return UserDefaults.standard.string(forKey: lastNameKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: lastNameKey)
        }
    }
    
    static var nationality: String {
        get {
            return UserDefaults.standard.string(forKey: nationalityKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: nationalityKey)
        }
    }
    
    static var photo: Data {
        get {
            let defaultImageData = UIImage(named: "User")!.pngData()!
            return UserDefaults.standard.data(forKey: photoKey)
                ?? defaultImageData
        }
        set {
            UserDefaults.standard.set(newValue, forKey: photoKey)
        }
    }
    
    static func deteleAll() -> Bool {
        if let domain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: domain)
            synchronize()
            return true
        } else {
            return false
        }
    }
    
    static func synchronize() {
        UserDefaults.standard.synchronize()
    }
    
}
