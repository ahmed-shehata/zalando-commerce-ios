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
            messageController.setToRecipients(["support+cffaf505af80456e87bab4511fd5187d@feedback.hockeyapp.net"])
            messageController.setMessageBody(self.getDeviceInfo(), isHTML: false)
            messageController.mailComposeDelegate = self

            if let data = self.getAttachment() {
                messageController.addAttachmentData(data, mimeType: "image/jpeg", fileName: "Bug")
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

    private func getDeviceInfo() -> String {
        let device = UIDevice.currentDevice()
        return "\n\n\n-------------\n\(device.modelName)\n\(device.systemName) \(device.systemVersion)"
    }

    private func getAttachment() -> NSData? {
        guard let windowRect = self.window?.bounds else { return nil }

        UIGraphicsBeginImageContext(windowRect.size)

        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        CGContextFillRect(ctx, windowRect)
        self.window?.layer.renderInContext(ctx)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(viewImage, 1.0)

        UIGraphicsEndImageContext()

        return imageData
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
