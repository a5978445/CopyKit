struct Strings {
	enum Copy: String {
		case age = "age"
		case enabled = "Enabled"
		case noneGiven = "none given"
		case group = "Group"
		case name = "Name"

		func localized() -> String {
			return bundle().localizedString(forKey: rawValue, value: nil, table: "copy")
		}

		func bundle() -> Bundle {
			return CopyBundleProvider.shared.asBundle()
		}
	}
}
