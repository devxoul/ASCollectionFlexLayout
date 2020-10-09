project:
	xcodegen generate
	pod install || pod install --repo-update --verbose
