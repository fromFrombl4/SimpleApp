import Foundation

// sourcery: AutoMockable
protocol FetcherProtocol {
    func loadItems(
        offset: Int,
        limit: Int,
        completion: @escaping (Result<[Post], ManagerError>) -> Void
    )
}
