//
//  LoggerFactory.swift
//  NatsysTemplate1
//
//  Created by amglobal on 4/27/19.
//  Copyright © 2019 Natsys. All rights reserved.
//

import Foundation
import CocoaLumberjack

class LoggerFactory {
    
    #if DEBUG
    static let defaultLogLevel: DDLogLevel = DDLogLevel.all
    #else
    static let defaultLogLevel: DDLogLevel = DDLogLevel.warning
    #endif
    
    
    static func initLogging() {
        DDLog.add(DDTTYLogger.sharedInstance, with: defaultLogLevel)
        DDLog.add(DDASLLogger.sharedInstance, with: defaultLogLevel)
    }
    
    
}
