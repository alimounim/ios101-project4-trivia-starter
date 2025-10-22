//
//  OpenTDBModels.swift
//  Trivia
//
//  Created by Ali Mounim Rajabi on 10/17/25.
//

import Foundation

struct OpenTDBResponse: Decodable {
    let response_code : Int
    let results : [OpenTDBQuestion]
}

struct OpenTDBQuestion: Decodable {
    let category : String
    let type : String
    let difficulty : String
    let question : String
    let correct_answer : String
    let incorrect_answers : [String]
}

extension String {
    var htmlUnescaped: String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        if let attributed = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return attributed.string
        }
        return self
    }
}

extension TriviaQuestion {
    init(from api: OpenTDBQuestion){
        self.category = api.category.htmlUnescaped
        self.question = api.question.htmlUnescaped
        self.correctAnswer = api.correct_answer.htmlUnescaped
        self.incorrectAnswers = api.incorrect_answers.map {$0.htmlUnescaped}
        
    }
}

#if DEBUG
func _debugDecodeSample() {
    let json = """
    {
      "response_code": 0,
      "results": [{
        "category": "General Knowledge",
        "type": "multiple",
        "difficulty": "easy",
        "question": "What is 2 &quot;+&quot; 2?",
        "correct_answer": "4",
        "incorrect_answers": ["3", "22", "5"]
      }]
    }
    """
    let data = Data(json.utf8)
    do {
        let decoded = try JSONDecoder().decode(OpenTDBResponse.self, from: data)
        let mapped = decoded.results.map { TriviaQuestion(from: $0) }
        assert(mapped.first?.question == "What is 2 + 2?")
        print("✅ Decode OK:", mapped.first ?? "nil")
    } catch {
        assertionFailure("❌ Decode failed: \(error)")
    }
}
#endif


