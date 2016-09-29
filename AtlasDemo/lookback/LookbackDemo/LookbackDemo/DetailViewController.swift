import UIKit

/*
    This view controller demos how you can start recording programmatically, configure settings for a custom recording,
    and getting access to the recording after it has completed.
*/
class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    var recordingSession : LookbackRecordingSession? = nil
    var presentHere : UIViewController!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        // Configure custom recording options
        let options = LookbackRecordingOptions()
        options.afterRecording = .RecordingUpload // don't let user preview recording before uploading
        options.cameraEnabled = false
        options.microphoneEnabled = true
        
        // Once recording ends (and thus upload starts), the URL to the recording will be available.
        // Here we can let user share their experience using a standard share sheet.
        options.onStartedUpload = { (destinationURL: NSURL!, sessionStartedAt: NSDate!) -> Void in
            print("An automatic recording finished to \(destinationURL)", terminator: "")
            let shareSheet = UIActivityViewController(activityItems:[destinationURL], applicationActivities:nil)
            self.presentHere.presentViewController(shareSheet, animated: true, completion: nil)
        }
        
        // And now we can start recording!
        recordingSession = Lookback.sharedLookback().startRecordingWithOptions(options)
        
        // We can give the recording a custom name. If we had enabled Preview, the user could then further customize this name.
        recordingSession!.name = "Automatic recording at \(NSDate())"
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        presentHere = self.navigationController
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.recordingSession?.stopRecording()
    }


    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

