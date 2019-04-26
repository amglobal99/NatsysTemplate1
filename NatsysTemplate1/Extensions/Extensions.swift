//
//  Extensions.swift
//  NatsysTemplate1
//
//  Created by amglobal on 4/26/19.
//  Copyright © 2019 Natsys. All rights reserved.
//

import Foundation


func dispatch_after(_ seconds: Double, block: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds, execute: block)
}


