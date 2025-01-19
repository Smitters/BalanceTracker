//
//  MobileRequestExecutor.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

import Foundation

protocol RequestExecutor {
    func get<T: Decodable>(url: URL) async throws -> T
    func post<T: Decodable, V: Encodable>(url: URL, body: V?) async throws -> T
    func execute<T: Decodable>(request: URLRequest) async throws -> T
}

class MobileRequestExecutor {

    let session: URLSession
    
    init(sesion: URLSession = .init(configuration: .default)) {
        self.session = sesion
    }
    
    static func createRequest(url: URL, method: String, body: Encodable? = nil) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let body {
            let bodyData = try JSONEncoder().encode(body)
            request.httpBody = bodyData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
}

extension MobileRequestExecutor: RequestExecutor {
    func execute<T: Decodable>(request: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw NSError(domain: "NetworkExecutor",
                          code: (response as? HTTPURLResponse)?.statusCode ?? 0,
                          userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func get<T: Decodable>(url: URL) async throws -> T {
        let urlRequest = try MobileRequestExecutor.createRequest(url: url, method: "GET")
        return try await execute(request: urlRequest)
    }
    
    func post<T: Decodable, V: Encodable>(url: URL, body: V?) async throws -> T {
        let urlRequest = try MobileRequestExecutor.createRequest(url: url, method: "POST", body: body)
        return try await execute(request: urlRequest)
    }
}
