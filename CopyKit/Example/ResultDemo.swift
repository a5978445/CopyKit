//
//  ResultDemo.swift
//  CopyKit
//
//  Created by 李腾芳 on 2020/4/27.
//  Copyright © 2020 HSBC Holdings plc. All rights reserved.
//

import Cocoa

/// 这是一个结果展示类，用于演示最终的结果
struct Strings {
    enum Copy: String {
        case homePageTitleLabel = "home_page_title_label"

        func localized() -> String {
            return bundle().localizedString(forKey: rawValue, value: nil, table: "copy")
        }

        func bundle() -> Bundle {
            return DefaultBundle.shared.asBundle()
        }
    }
}
