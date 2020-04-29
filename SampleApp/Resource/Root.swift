//  Created by 李腾芳 on 2020/4/28.
//  本文件由Copy Kit 自动生成，切勿手动编辑
//

import UIKit 

struct Strings {
	enum Root: String {
		case group = "Group"
		case enabled = "Enabled"
		case age = "age"
		case noneGiven = "none given"
		case name = "Name"

		func localized() -> String {
			return bundle().localizedString(forKey: rawValue, value: nil, table: "Root")
		}

		func bundle() -> Bundle {
			return CopyBundleProvider.shared.asBundle()
		}
	}
}
