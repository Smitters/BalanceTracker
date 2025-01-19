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
    private(set) lazy var persistenceManager: PersistanceManager = CoreDataManager.shared
    private(set) lazy var balanceService: BalanceService = {
        MobileBalanceService(
            persistanceManager: persistenceManager,
            keyValueStorage: keyValueStorage,
            analytics: analyticsService)
    }()
    private(set) lazy var bitcoinRateService: BitcoinRateService = {
        MobileBitcoinRateService(
            requestExecutor: requestExecutor,
            analytics: analyticsService,
            timer: MobileRepeatableTimer(),
            keyValueStorage: keyValueStorage)
    }()
}
