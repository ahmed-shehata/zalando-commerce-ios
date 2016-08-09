//
//  Copyright © 2016 Zalando SE. All rights reserved.
//

import Foundation

@available( *, deprecated, message = "To be replaced by Atlas.configure")
final public class AtlasSDK: CustomStringConvertible {

    @available( *, deprecated, message = "To be replaced by AtlasError")
    public enum Status: Int {
        case SetupFromOptions = 3
        case SetupFromBundle = 2
        case NotInitialized = 1
        case ConfigurationOK = 0
        case InitFailed = -1
        case ConfigurationFailed = -2
    }

    internal static let sharedInstance = AtlasSDK()

    public private(set) var status: Status = .NotInitialized {
        didSet {
            AtlasLogger.logDebug("SDK Status changed:", status)
        }
    }

    public private(set) var options: Options = Options() {
        didSet {
            configure()
        }
    }

    public var description: String {
        return "\(self.dynamicType) (\(status)) { \(self.options) }"
    }

    internal var apiClient: APIClient?

    private var injector = Injector()
    private var configurator: Configurator?

    init(options: Options) {
        prepareConfiguration(status: .SetupFromOptions, options: options)
    }

    init(bundle: NSBundle = NSBundle.mainBundle()) {
        prepareConfiguration(status: .SetupFromBundle, options: Options(bundle: bundle))
    }

    func setup(options: Options) {
        self.status = .SetupFromOptions
        self.options = options
    }

    func register<T>(factory: Void -> T) {
        self.injector.register { factory() }
    }

    func updateOptions(block: Options -> Options) {
        let opts = block(self.options)
        self.setup(opts)
    }

    private func prepareConfiguration(status status: Status, options: Options) {
        self.status = status
        self.options = options
    }

    private func configure() {
        do {
            try options.validate()
            Localizer.initShared(self)

            requestConfigurator { result in
                switch result {
                case .failure(let error):
                    AtlasLogger.logError(error)
                    self.status = .InitFailed
                case .success(let config):
                    self.status = .ConfigurationOK
                    self.apiClient = APIClient(config: config)
                }
            }
        } catch let error {
            guard self.status != .SetupFromBundle else {
                self.status = .NotInitialized
                return
            }
            AtlasLogger.logError(error)
            self.status = .InitFailed
        }
    }

    private func requestConfigurator(completion: ConfigCompletion) {
        self.configurator = (try? self.injector.provide() as Configurator) ?? ConfigClient(options: self.options)

        self.configurator?.configure { result in
            completion(result)
        }
    }

}

extension AtlasSDK: Localizable {

    public var localizedStringsBundle: NSBundle {
        return NSBundle(forClass: AtlasSDK.self)
    }

    public var localeIdentifier: String {
        return options.interfaceLanguage
    }

}
