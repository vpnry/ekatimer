// ios/Runner/AppDelegate.swift  — widget action data store
//
// Add these three methods to your AppDelegate class.
// (Keep your existing AppDelegate code; this is an additive snippet.)

// MARK: - Widget action data store

private var _widgetActionData: [String: Any]? = nil

func setWidgetActionData(_ data: [String: Any]) {
    _widgetActionData = data
}

/// Returns the stored data and CLEARS it.
/// Called by the native channel handler for "getWidgetAction".
func getAndClearWidgetActionData() -> [String: Any]? {
    defer { _widgetActionData = nil }
    return _widgetActionData
}

/// Returns the stored data WITHOUT clearing it.
/// Called by the native channel handler for "peekWidgetAction".
/// Allows Dart to inspect flags (e.g. fromAlarm) before the full
/// handleWidgetAction call consumes the payload via getWidgetAction.
func peekWidgetActionData() -> [String: Any]? {
    return _widgetActionData
}
