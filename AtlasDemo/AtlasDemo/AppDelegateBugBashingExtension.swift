import UIKit
import MessageUI
import AtlasUI
import AtlasSDK

extension AppDelegate: MFMailComposeViewControllerDelegate {
    func setupBugScreenshot() {
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

            let atlasUIViewController: AtlasUIViewController? = try? Atlas.provide()
            messageController.modalPresentationStyle = .OverFullScreen
            atlasUIViewController?.presentViewController(messageController, animated: true, completion: nil)
        }

    }

    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result {
        case MFMailComposeResultSent:
            dismissEmail(controller)
            showAlert("Bug report sent successfully")
            break
        case MFMailComposeResultFailed:
            showAlert("Cannot send your bug report")
            break
        default:
            dismissEmail(controller)
        }
    }

    private func showAlert(text: String) {
        let alert = UIAlertController(title: "Bug Bashing",
                                      message: text,
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        let atlasUIViewController: AtlasUIViewController? = try? Atlas.provide()
        atlasUIViewController?.presentViewController(alert, animated: true, completion: nil)
    }

    private func dismissEmail(controller: MFMailComposeViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
