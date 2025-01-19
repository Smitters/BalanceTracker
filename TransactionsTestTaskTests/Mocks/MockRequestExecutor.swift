//
//  MockRequestExecutor.swift
//  TransactionsTestTask
//
//  Created by Dmytro Smetankin on 19.01.2025.
//

import Foundation
@testable import TransactionsTestTask

class MockRequestExecutor: RequestExecutor {
    var mockedResult: Result<Any, Error>?
    
    func get<T>(url: URL) async throws -> T where T: Decodable {
        try await execute(request: URLRequest(url: url))
    }
    func post<T, V>(url: URL, body: V?) async throws -> T where T : Decodable, V : Encodable {
        try await execute(request: URLRequest(url: url))
    }
    
    func execute<T>(request: URLRequest) async throws -> T where T : Decodable {
        guard let result = mockedResult else { throw URLError(.badURL) }
        switch result {
        case .success(let response):
            return response as! T
        case .failure(let error):
            throw error
        }
    }
}
