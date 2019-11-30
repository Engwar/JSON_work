//
//  Todo.swift
//  JSON_work
//
//  Created by Igor Shelginskiy on 11/30/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import Foundation

// MARK: - Element
struct Todo: Codable {
    let userID, id: Int
    let title: String
    let completed: Bool

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, completed
    }
}

typealias Todos = [Todo]
