import IOKit.ps
import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let batteryChannel = FlutterMethodChannel(name: "com.pdp/battery",
                                              binaryMessenger: controller.binaryMessenger)
    batteryChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in

      guard call.method == "getBatteryLevel" else {
        result(FlutterMethodNotImplemented)
        return
      }
      self?.receiveBatteryLevel(result: result)
    })

    override func awakeFromNib() {

      self.setFrame(windowFrame, display: true)

      let batteryChannel = FlutterMethodChannel(
        name: "com.pdp/battery",
        binaryMessenger: flutterViewController.engine.binaryMessenger)
      batteryChannel.setMethodCallHandler { (call, result) in
        // This method is invoked on the UI thread.
        // Handle battery messages.
      }

      RegisterGeneratedPlugins(registry: flutterViewController)

      super.awakeFromNib()
    }
  }

  private func getBatteryLevel() -> Int? {
    let info = IOPSCopyPowerSourcesInfo().takeRetainedValue()
    let sources: Array<CFTypeRef> = IOPSCopyPowerSourcesList(info).takeRetainedValue() as Array
    if let source = sources.first {
      let description =
        IOPSGetPowerSourceDescription(info, source).takeUnretainedValue() as! [String: AnyObject]
      if let level = description[kIOPSCurrentCapacityKey] as? Int {
        return level
      }
    }
    return nil
  }

}
