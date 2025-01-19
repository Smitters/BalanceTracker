//
//  ServicesAssembler.swift
//  TransactionsTestTask
//
//

/// Services Assembler is used for Dependency Injection
struct ServicesAssembler {
    private(set) lazy var keyValueStorage = UserDefaultsKeyValueStorage()
    private(set) lazy var requestExecutor: RequestExecutor = MobileRequestExecutor()
    private(set) lazy var analyticsService: AnalyticsService = AnalyticsServiceImpl()
    private(set) lazy var bitcoinRateService: BitcoinRateService = {
        MobileBitcoinRateService(
            requestExecutor: requestExecutor,
            analytics: analyticsService,
            timer: MobileRepeatableTimer(),
            keyValueStorage: keyValueStorage)
    }()
}
