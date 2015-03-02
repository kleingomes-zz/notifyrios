//
//  AppSettings.swift
//  notifyr
//
//  Created by Klein on 2015-02-21.
//  Copyright (c) 2015 Nelson Narciso. All rights reserved.
//

import UIKit

class AppSettings: NSObject {
    
    private let kUserDefaultsKeyDeviceToken = "deviceToken";
    private let kUserDefaultsKeySentDeviceTokenToApi = "sentDeviceTokenToApi"
    
    private var _deviceToken: String?
    
    var deviceToken: String? {
        
        get {
            if (_deviceToken == nil)
            {
                _deviceToken = NSUserDefaults.standardUserDefaults().stringForKey(kUserDefaultsKeyDeviceToken)
            }
            
            return _deviceToken;
        }
        
        set {
            if (_deviceToken == newValue) {
                return;
            }
            _deviceToken = newValue
            var userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults .setObject(_deviceToken, forKey: kUserDefaultsKeySentDeviceTokenToApi)
            userDefaults.synchronize()
        }
        
    }
    
    
    private var _sentDeviceTokenToApi: Bool?
    
    var sentDeviceTokenToApi: Bool {
        
        get {
            if (_sentDeviceTokenToApi == nil)
            {
                _sentDeviceTokenToApi = NSUserDefaults.standardUserDefaults().boolForKey(kUserDefaultsKeySentDeviceTokenToApi)
            }
            
            return _sentDeviceTokenToApi!;
        }
        
        set {
            if (_sentDeviceTokenToApi == newValue) {
                return;
            }
            _sentDeviceTokenToApi = newValue
            var userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults .setObject(_sentDeviceTokenToApi, forKey: kUserDefaultsKeySentDeviceTokenToApi)
            userDefaults.synchronize()
        }
        
    }
    
    
    class var sharedSettings : AppSettings {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : AppSettings? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = AppSettings()
        }
        return Static.instance!
    }
    

}
