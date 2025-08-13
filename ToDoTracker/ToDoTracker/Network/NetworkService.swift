//
//  NetworkService.swift
//  ToDoTracker
//
//  Created by Max on 12.08.2025.
//

import Foundation

final class NetworkService {
    static let shared = NetworkService()
    private init() {}

    func fetchTodos(completion: @escaping (Result<[Todo], Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else { return }
            do {
                let storage = try JSONDecoder().decode(Storage.self, from: data)
                completion(.success(storage.todos))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    


}
