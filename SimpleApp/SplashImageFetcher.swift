import Foundation

enum SplashImageFetcherError: Error {
    case invalidUrl
    case invalidResponse
}

private struct SearchResultRaw: Codable {
    let results: [SplashImage]
}

class SplashImageFetcher: SplashImageFetcherProtocol {
    func searchImages(
        query: String,
        page: Int,
        perPage: Int,
        completion: @escaping (Result<[SplashImage], Error>) -> Void
    ) {
        guard let url = URL(string: "https://api.unsplash.com/search/photos?client_id=MxOiALvazpGTiQgIDZe0MLr0FTFZar4Qc91adXaSGAE&query=\(query)&page=\(page)&per_page=\(perPage)") else {
            completion(.failure(SplashImageFetcherError.invalidUrl))
            return
        }

        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(SplashImageFetcherError.invalidResponse))
                }
                return
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            do {
                let result = try decoder.decode(SearchResultRaw.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result.results))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
