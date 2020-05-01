//  Created by 李腾芳 on 2020/4/28.
//  本文件由Copy Kit 自动生成，切勿手动编辑
//

import UIKit 

struct Strings {
	enum Home: String {
		case name = "Name"
		case age = "age"
		case helloWorld = "hello world"
		case group = "Group"
		case enabled = "Enabled"
		case noneGiven = "none given"

		func localized() -> String {
			return bundle().localizedString(forKey: rawValue, value: nil, table: "Home")
		}

		func bundle() -> Bundle {
			return CopyBundleProvider.shared.asBundle()
		}
	}
}
