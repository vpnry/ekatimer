/// Service that manages widget data for home screen widgets.
///
/// Widgets are now purely static shortcuts (15m, 30m, 1H, etc.) that
/// rely on intent extras passed at tap time, so no dynamic data updates
/// are needed. This service is kept as a minimal initializer for the
/// iOS App Group if required by the home_widget plugin.
class WidgetDataService {
  /// Must be called once at app startup before any widget operations.
  static Future<void> initialize() async {
    // Widgets are static shortcuts – no data updates needed.
  }
}