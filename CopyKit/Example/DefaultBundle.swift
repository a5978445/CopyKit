//
//  DefaultBundle.swift
//  CopyKit
//
//  Created by 李腾芳 on 2020/4/27.
//  Copyright © 2020 HSBC Holdings plc. All rights reserved.
//

import Cocoa

/// 用于演示的CopyBundleCovertible 实例
/// 在实际s实际的使用上应该监听，用户语言切换事件
/// 达到动态切换语言的效果
struct DefaultBundle: CopyBundleCovertible {
    static var shared: DefaultBundle = DefaultBundle()

    func asBundle() -> Bundle {
        return Bundle.main
    }
}
