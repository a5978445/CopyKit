//
//  CopyBundleCovertible.swift
//  CopyKit
//
//  Created by 李腾芳 on 2020/4/27.
//  Copyright © 2020 HSBC Holdings plc. All rights reserved.
//

import Cocoa

protocol CopyBundleCovertible {
    static var shared: Self { get }
  //  static func shared() -> Self
    func asBundle() -> Bundle
}
