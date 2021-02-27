import Foundation
@testable import SimpleApp

extension Post {
    static func mock(
        userId: Int = 1,
        id: Int = 1,
        title: String = "title",
        body: String = "body"
    ) -> Post {
        Post(
            userId: userId,
            id: id,
            title: title,
            body: body
        )
    }
}
