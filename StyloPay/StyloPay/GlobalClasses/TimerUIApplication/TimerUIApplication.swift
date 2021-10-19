import Foundation
import UIKit

 extension NSNotification.Name {
     public static let TimeOutUserInteraction: NSNotification.Name = NSNotification.Name(rawValue: "TimeOutUserInteraction")
   }


  class TimerUIApplication: UIApplication{

  static let ApplicationDidTimoutNotification = "AppTimout"

  // The timeout in seconds for when to fire the idle timer.
   let timeoutInSeconds: TimeInterval = 5//15 * 60

      var idleTimer: Timer?

  // Listen for any touch. If the screen receives a touch, the timer is reset.
  override func sendEvent(_ event: UIEvent) {
     super.sendEvent(event)
   // print("3")
  if idleTimer != nil {
     self.resetIdleTimer()
 }

    if let touches = event.allTouches {
       for touch in touches {
        if touch.phase == UITouch.Phase.began {
            self.resetIdleTimer()
         }
     }
  }
}
 // Resent the timer because there was user interaction.
func resetIdleTimer() {
  if let idleTimer = idleTimer {
    // print("1")
     idleTimer.invalidate()
 }

      idleTimer = Timer.scheduledTimer(timeInterval: timeoutInSeconds, target: self, selector: #selector(self.idleTimerExceeded), userInfo: nil, repeats: false)
  }

    // If the timer reaches the limit as defined in timeoutInSeconds, post this notification.
    @objc func idleTimerExceeded() {
      print("Time Out")

   NotificationCenter.default.post(name:Notification.Name.TimeOutUserInteraction, object: nil)

     //Go Main page after 15 second

        Global.showAlert(withMessage: "Session Time Out! Click on 'OK' to authenticate", setTwoButton: false, setFirstButtonTitle: "OK", setSecondButtonTitle: "", handler: { (action) in
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
   appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
   let yourVC = mainStoryboard.instantiateViewController(withIdentifier: "BiometricViewController") as! BiometricViewController
  appDelegate.window?.rootViewController = yourVC
  appDelegate.window?.makeKeyAndVisible()
        })

   }
}
