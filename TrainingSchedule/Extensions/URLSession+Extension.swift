//
//  URLSession+Extension.swift
//  TrainingSchedule
//
//  Created by Trần Hải Ninh on 28/6/24.
//

import Foundation

extension URLSession {
    func fetchData<T: Decodable>(for url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        self.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                let responseError = NSError(domain: "", code: 0,
                                          userInfo: [NSLocalizedDescriptionKey: "HTTP Response Code Error"])
                completion(.failure(responseError))
                return
            }

            if let data = data {
                do {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(object))
                } catch let decodeError {
                    completion(.failure(decodeError))
                }
            }

        }.resume()
    }
}
