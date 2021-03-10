import Foundation

struct ImageURL: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct SplashImage: Codable {
    let id: String
    let width: Int
    let height: Int
    let color: String
    let altDescription: String?
    let urls: ImageURL
}

// sourcery: AutoMockable
protocol SplashImageFetcherProtocol {
    func searchImages(
        query: String,
        page: Int,
        perPage: Int,
        completion: @escaping (Result<[SplashImage], Error>) -> Void
    )
}
