//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import UIKit
import MessageUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MFMailComposeViewControllerDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        BuddyBuildSDK.setup()
        AppSetup.configure()

        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationUserDidTakeScreenshotNotification,
                                                                object: nil,
                                                                queue: NSOperationQueue.mainQueue()) { notification in
            let messageController = MFMailComposeViewController()
            messageController.setSubject("Bug Bashing")
            messageController.mailComposeDelegate = self

            if let windowRect = self.window?.bounds {
                UIGraphicsBeginImageContext(windowRect.size)

                if let ctx = UIGraphicsGetCurrentContext() {
                    CGContextFillRect(ctx, windowRect)
                    self.window?.layer.renderInContext(ctx)
                    let viewimage = UIGraphicsGetImageFromCurrentImageContext()
                    let imageData = UIImageJPEGRepresentation(viewimage, 1.0)

                    if let data = imageData {
                        messageController.addAttachmentData(data, mimeType: "image/jpeg", fileName: "Bug")
                    }
                }

                UIGraphicsEndImageContext()
            }

            let rootVC = UIApplication.sharedApplication().keyWindow?.rootViewController
            rootVC?.dismissViewControllerAnimated(true, completion: nil)
            rootVC?.presentViewController(messageController, animated: true, completion: nil)
        }

        return true
    }

    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

}
