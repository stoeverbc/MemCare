//
//  WordBank.swift
//  MemCare
//
//  Created by Christian Kurt Stoever on 6/30/25.
//
import Foundation

struct WordBank: Decodable {
  var nouns: [String]

  static let shared: WordBank = {
    let url = Bundle.main.url(forResource: "WordBank", withExtension: "json")!
    return try! JSONDecoder().decode(WordBank.self,
                                     from: Data(contentsOf: url))
  }()

  static func sample(size: Int = 5) -> [String] {
    var pool = shared.nouns
    var result: [String] = []
    for _ in 0..<size {
      let idx = Int.random(in: 0..<pool.count)
      result.append(pool.remove(at: idx))
    }
    return result
  }
}

