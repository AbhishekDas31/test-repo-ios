//
//  main.swift
//  StyloPay
//
//  Created by Abhishek das on 19/10/21.
//  Copyright © 2021 Anmol Aggarwal. All rights reserved.
//

import Foundation
import UIKit

UIApplicationMain(     CommandLine.argc,     UnsafeMutableRawPointer(CommandLine.unsafeArgv)         .bindMemory(             to: UnsafeMutablePointer<Int8>.self,             capacity: Int(CommandLine.argc)),     NSStringFromClass(TimerUIApplication.self), NSStringFromClass(AppDelegate.self) )
