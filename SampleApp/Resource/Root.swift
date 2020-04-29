import UIKit
struct Strings {
	enum Root: String {
		case age = "age"
		case noneGiven = "none given"
		case name = "Name"
		case enabled = "Enabled"
		case group = "Group"

		func localized() -> String {
			return bundle().localizedString(forKey: rawValue, value: nil, table: "Root")
		}

		func bundle() -> Bundle {
			return CopyBundleProvider.shared.asBundle()
		}
	}
}
