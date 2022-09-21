//
//  NetworkClient.swift
//  Checkout3DSTest
//
//  Created by Alexander Shchegryaev on 21/09/2022.
//

import Foundation

enum HTTPMethod: String {
    case connect = "CONNECT"
    case delete = "DELETE"
    case get = "GET"
    case head = "HEAD"
    case options = "OPTIONS"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
    case trace = "TRACE"
}

enum HTTPParameters {
    case json(Data)
}

struct HTTPRequest {
    let path: String
    let method: HTTPMethod
    let parameters: HTTPParameters?
}

enum NetworkError: Error {
    case apiError
}

protocol NetworkClient {
    func performRequest<T: Decodable>(
        request: HTTPRequest,
        completion: @escaping (Result<T, Error>) -> Void
    )
}

final class MainNetworkClient: NetworkClient {
    private let apiURL = URL(string: "https://integrations-cko.herokuapp.com")!
    
    func performRequest<T: Decodable>(
        request: HTTPRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let url = apiURL.appendingPathComponent(request.path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        if let parameters = request.parameters {
            switch parameters {
            case .json(let data):
                urlRequest.httpBody = data
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }
        
        func callCompletionOnMainThread(_ result: Result<T, Error>) {
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = URLSession.shared.dataTask(
            with: urlRequest,
            completionHandler: { data, response, error in
                guard let data = data,
                      let statusCode = (response as? HTTPURLResponse)?.statusCode,
                      statusCode < 300,
                      error == nil else {
                    callCompletionOnMainThread(.failure(error ?? NetworkError.apiError))
                    return
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let result = try decoder.decode(T.self, from: data)
                    callCompletionOnMainThread(.success(result))
                } catch {
                    print("APIERROR", error)
                    callCompletionOnMainThread(.failure(error))
                }
            }
        )
        task.resume()
    }
}

extension NetworkClient {
    func json<T: Encodable>(_ object: T) -> HTTPParameters? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(object) else {
            return nil
        }
        return .json(data)
    }
}
