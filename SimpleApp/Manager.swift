import Foundation

class Manager {
    static let shared = Manager()
    private init() {}

    func loadItems(
        offset: Int,
        limit: Int,
        completion: @escaping ([Int]) -> Void
    ) {
        completion([])
    }
}
