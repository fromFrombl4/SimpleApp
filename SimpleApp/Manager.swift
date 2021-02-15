import Foundation

class Manager {
    static let shared = Manager()
    private init() {
        array = Array(repeating: 0, count: 100)
        for i in 0..<array.count {
            array[i] = i
        }
    }
    private var array: [Int]

    func loadItems(
        offset: Int,
        limit: Int,
        completion: @escaping ([Int]) -> Void
    ) {
        var result: [Int] = []
        let lastElement = min(array.count, offset + limit)
        for i in offset..<lastElement {
            result.append(array[i])
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(900)) {
            completion(result)
        }
    }
}
