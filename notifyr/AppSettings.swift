//
//  AppSettings.swift
//  notifyr
//
//  Created by Klein on 2015-02-21.
//  Copyright (c) 2015 Nelson Narciso. All rights reserved.
//

import UIKit

class AppSettings: NSObject {
  
    
    let kUserDefaultsKeyDeviceToken = "deviceToken";
    let kUserDefaultsKeySentDeviceTokenToApi = "sentDeviceTokenToApi"
    
    //MARK: deviceToken
    func deviceToken(deviceToken: String) -> String{
        
        return "";
    }
    
    func setDeviceToken(deviceToken: String) {
        
        
    }
    
    //MARK: sentDeviceTokenToApi
    func sentDeviceTokenToApi()->Bool{
        
        return true;
    }
    
    func setSentDeviceTokenToApi(sentDeviceToken: Bool)
    {
        
    }
    
}
