import Foundation

class Manager {
    static let shared = Manager()
    private init() {
        array = Array<Int>.init(repeating: 0, count: 100)
        for i in 0..<array.count {
            array[i] = i
        }
    }
    var array: Array<Int>

    func loadItems(
        offset: Int,
        limit: Int,
        completion: @escaping ([Int]) -> Void
    ) {
        //offset = 1, limit = 2
        var result = [Int]()
        var lastElement = min(array.count, offset + limit)
        for i in offset..<lastElement {
            result.append(array[i])
        }
        if limit < 0 {
            print("Limit should be greater than 0")
        }
        completion(result)
    }
}

