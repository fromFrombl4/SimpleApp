// Generated using Sourcery 1.2.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

@testable import SimpleApp














class FetcherProtocolMock: FetcherProtocol {

    //MARK: - loadItems

    var loadItemsOffsetLimitCompletionCallsCount = 0
    var loadItemsOffsetLimitCompletionCalled: Bool {
        return loadItemsOffsetLimitCompletionCallsCount > 0
    }
    var loadItemsOffsetLimitCompletionReceivedArguments: (offset: Int, limit: Int, completion: (Result<[Post], ManagerError>) -> Void)?
    var loadItemsOffsetLimitCompletionReceivedInvocations: [(offset: Int, limit: Int, completion: (Result<[Post], ManagerError>) -> Void)] = []
    var loadItemsOffsetLimitCompletionClosure: ((Int, Int, @escaping (Result<[Post], ManagerError>) -> Void) -> Void)?

    func loadItems(
        offset: Int,
        limit: Int,
        completion: @escaping (Result<[Post], ManagerError>) -> Void
    ) {
        loadItemsOffsetLimitCompletionCallsCount += 1
        loadItemsOffsetLimitCompletionReceivedArguments = (offset: offset, limit: limit, completion: completion)
        loadItemsOffsetLimitCompletionReceivedInvocations.append((offset: offset, limit: limit, completion: completion))
        loadItemsOffsetLimitCompletionClosure?(offset, limit, completion)
    }

}
