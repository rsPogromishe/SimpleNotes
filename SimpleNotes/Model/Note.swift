//
//  Note.swift
//  SimpleNotes
//
//  Created by Снытин Ростислав on 12.01.2023.
//

import Foundation

struct Note: Codable {
    var titleText: String
    var mainText: String
    var date: Date?
    var isEmpty: Bool {
        if mainText.isEmpty {
            return true
        } else {
            return false
        }
    }
}
