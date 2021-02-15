import Foundation

enum ManagerError: Error {
    case timeout
}

class Manager {
    static let shared = Manager()
    private init() {
        array = Array(repeating: 0, count: 100)
        for i in 0..<array.count {
            array[i] = i
        }
    }
    private var array: [Int]

    /// for testing purpose range in 0...1
    internal var failureChance = 0.2

    func loadItems(
        offset: Int,
        limit: Int,
        completion: @escaping (Result<[Int], ManagerError>) -> Void
    ) {
        var result: [Int] = []
        let lastElement = min(array.count, offset + limit)
        for i in offset..<lastElement {
            result.append(array[i])
        }

        let random = Double.random(in: 0..<1)
        let timeout = random <= failureChance ? 2000 : 500

        DispatchQueue.main
            .asyncAfter(deadline: DispatchTime.now() + .milliseconds(timeout)) {
                switch random {
                case 0...self.failureChance:
                    completion(.failure(.timeout))
                default:
                    completion(.success(result))
                }
            }
    }
}
