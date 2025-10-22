//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Ali Mounim Rajabi on 10/21/25.
//

import Foundation

/// Service responsible for fetching and decoding trivia questions
final class TriviaQuestionService {
    
    struct Params {
        var amount: Int = 5            // number of questions
        var category: Int? = nil       // optional category ID
        var difficulty: String? = nil  // "easy" | "medium" | "hard"
        var type: String? = nil        // "multiple" | "boolean"
    }
    
    /// Fetch trivia questions from OpenTDB
    func fetchQuestions(
        _ params: Params = Params(),
        completion: @escaping (Result<[TriviaQuestion], Error>) -> Void
    ) {
        var components = URLComponents(string: "https://opentdb.com/api.php")!
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "amount", value: String(params.amount))
        ]
        if let category = params.category {
            queryItems.append(URLQueryItem(name: "category", value: String(category)))
        }
        if let difficulty = params.difficulty {
            queryItems.append(URLQueryItem(name: "difficulty", value: difficulty))
        }
        if let type = params.type {
            queryItems.append(URLQueryItem(name: "type", value: type))
        }
        components.queryItems = queryItems
        
        guard let url = components.url else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1)))
            return
        }

        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "NoData", code: -1)))
                }
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(OpenTDBResponse.self, from: data)
                let questions = decoded.results.map { TriviaQuestion(from: $0) }
                DispatchQueue.main.async { completion(.success(questions)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }
}
