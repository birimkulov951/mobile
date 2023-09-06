import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin
import io.flutter.plugin.common.PluginRegistry

object FlutterLocalNotificationPluginRegistrant {
  fun registerWith(registry: PluginRegistry) {
    if (alreadyRegisteredWith(registry)) {
      return
    }
    FlutterLocalNotificationsPlugin.registerWith(registry
      .registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"))
  }

  private fun alreadyRegisteredWith(registry: PluginRegistry): Boolean {
    val key = FlutterLocalNotificationPluginRegistrant::class.java.canonicalName
    if (registry.hasPlugin(key)) {
      return true
    }
    registry.registrarFor(key)
    return false
  }
}