//
//  DataManager.swift
//  ACL
//
//  Created by RGND on 13/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class DataManager: NSObject {

    static var shared: DataManager {
        return DataManager()
    }
    
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: "token")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "token")
            UserDefaults.standard.synchronize()
        }
    }
    var userName: String? {
          get {
              return UserDefaults.standard.string(forKey: "username")
          }
          set {
              UserDefaults.standard.set(newValue, forKey: "username")
              UserDefaults.standard.synchronize()
          }
      }
    
    
    var userId: String? {
        get {
            return UserDefaults.standard.string(forKey: "userId")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userId")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    
    var userEmailAddress: String? {
        get {
            return UserDefaults.standard.string(forKey: "userEmailAddress")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userEmailAddress")
            UserDefaults.standard.synchronize()
        }
    }
    
    var keepLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "keepLoggedIn")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "keepLoggedIn")
            UserDefaults.standard.synchronize()
        }
    }
    
    var isGuestUser: Bool {
          get {
              return UserDefaults.standard.bool(forKey: "isGuestUser")
          }
          set {
              UserDefaults.standard.set(newValue, forKey: "isGuestUser")
              UserDefaults.standard.synchronize()
          }
      }
    
    var myJournalPasscode: String? {
        get {
            return UserDefaults.standard.string(forKey: "myJournalPasscode")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "myJournalPasscode")
            UserDefaults.standard.synchronize()
        }
    }
    
    var isACLAccount: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isACLAccount")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isACLAccount")
            UserDefaults.standard.synchronize()
        }
    }
    

    
    var password: String? {
        get {
            return UserDefaults.standard.string(forKey: "userpassword")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userpassword")
            UserDefaults.standard.synchronize()
        }
    }
    
    
    func clear() {
        self.token = nil
        self.userId = nil
        self.userEmailAddress = nil
        self.myJournalPasscode = nil
        self.isACLAccount = false
        self.isGuestUser = false
        self.password = nil
        UserDefaults.standard.removeObject(forKey: reminderKey)
        UserDefaults.standard.synchronize()
    }
}
