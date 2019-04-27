//
//  InternetConnectionHelper.swift
//  NatsysTemplate1
//
//  Created by amglobal on 4/27/19.
//  Copyright © 2019 Natsys. All rights reserved.
//

import Foundation
import CocoaLumberjack
import SwiftSpinner


class InternetConnectionHelper {
    
    
    static let sharedInstance = InternetConnectionHelper()
    
    
    private init () {
    }
    
    
    // Flag that tracks internet connectivity
    var internetIsConnected:Bool = true
    
    
    /// Display message to user stating connection to internet is unavailable
    static func displayNoConnectivityMessage() {
        DDLogDebug("GlobalHelper - displayNoConnectivityMessage: Will display no connectivity message.")
        SwiftSpinner.setTitleFont(UIFont(name: "Futura", size: 18.0))
        SwiftSpinner.show(delay: 0.1, title: "Unable to contact servers, please check your internet connection and try again.")
    }
    
    /// Display message to user stating site is not responding
    static func displaySiteIsDownMessage() {
        DDLogDebug("GlobalHelper - displayNoConnectivityMessage: Will display site down message.")
        SwiftSpinner.setTitleFont(UIFont(name: "Futura", size: 18.0))
        SwiftSpinner.show(delay: 0.1, title: "Unable to contact servers. Please try again later.")
    }
    
    
    
    /// check if Internet connection is available.
    /// do this check before sending any url requests
    static func isInternetConnectionAvailable() -> Bool {
        if (Network.reachability?.isConnectedToNetwork)!  {
            DDLogDebug("GlobalHelper - isInternetConnectionAvailable:  Internet is connected")
            return true
        } else {
            DDLogDebug("GlobalHelper - isInternetConnectionAvailable: Internet is disconncted")
            return false
        }
    }
    
    
    
    
    /// Method to track when internet connectivity changes status from Connected to Not Connected and vice-versa
    /// An observer has been specified in the AppDelegate method 'didFinishLaunchingWithOptions'
    /// -parameter: notification
    @objc  func updateConnectivityStatus (_ notification: NSNotification) {
        
        DDLogDebug("GlobalHelper - updateConnectivityStatus: Received notification.")
        
        guard let status = Network.reachability?.status else {
            return
        }
        
        switch status {
            
        case .unreachable:
            // self.internetIsConnected = false
            DDLogDebug("GlobalHelper - Notified that Internet is NOT Connected")
            //GlobalHelper.displayNoConnectivityMessage()
            InternetConnectionHelper.displayNoConnectivityMessage()
            
        default:
            //self.internetIsConnected = true
            DDLogDebug("GlobalHelper - Notified that Internet is Connected")
            //SwiftSpinnerHelper.hideSpinner()
        }
        
    } // end func
    
    
    
    
    
} // end class
