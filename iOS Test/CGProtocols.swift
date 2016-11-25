//
//  CGProtocols.swift
//  iOS Test
//
//  Created by Tejas  Nikumbh on 25/11/16.
//  Copyright © 2016 Castle. All rights reserved.
//

import Foundation

protocol Singleton: class {
    static var sharedInstance: Self { get }
}
