//
//  BaseService.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 12/7/24.
//

import Foundation

struct StringError: Error {
    var message: String?
}

protocol URLRequestConvertible {
    func makeURLRequest() throws -> URLRequest
}

class BaseNetworkService<Router: URLRequestConvertible> {
    private let urlSession: URLSession

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    private func handleResponse(data: Data, response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.requestFailed(statusCode: httpResponse.statusCode)
        }
    }

    func request<T: Decodable>(_ returnType: T.Type, router: Router) async throws -> T {
        let request = try router.makeURLRequest()
        print(request)
        let (data, response) = try await urlSession.data(for: request)

        try handleResponse(data: data, response: response)

        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(returnType, from: data)
            return decodedData
        } catch {
            throw NetworkError.dataConversionFailure
        }
    }

    func requestGetErrorMessage<T: Decodable>(_ returnType: T.Type, router: Router) async throws -> T {
        do {
            return try await request(returnType, router: router)
        } catch NetworkError.dataConversionFailure {
            throw StringError(message: "Decoded data failed.")
        } catch NetworkError.invalidResponse {
            throw StringError(message: "Invalid Response from API")
        } catch NetworkError.invalidURL {
            throw StringError(message: "Invalid URL")
        } catch NetworkError.requestFailed(let statusCode) {
            throw StringError(message: "Request Failed with \(statusCode)")
        } catch {
            throw StringError(message: "Error in getting data process")
        }
    }
}
