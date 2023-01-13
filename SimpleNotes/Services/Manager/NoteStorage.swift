//
//  NoteStorage.swift
//  SimpleNotes
//
//  Created by Снытин Ростислав on 12.01.2023.
//

import Foundation

class NoteStorage {
    static let shared = NoteStorage()

    private var storage = UserDefaults.standard
    private var storageKey: String = "notes"

    private enum NoteKey: String {
        case title
        case mainText
        case date
    }

    func loadNotes() -> [Note] {
        var resultNotes: [Note] = []
        let notesFromStorage = storage.array(forKey: storageKey) as? [[String: Any]] ?? []
        for note in notesFromStorage {
            guard let title = note[NoteKey.title.rawValue] as? String,
                  let text = note[NoteKey.mainText.rawValue] as? String,
                  let date = note[NoteKey.date.rawValue] as? Date
            else { continue }
            resultNotes.append(Note(titleText: title, mainText: text, date: date))
        }
        return resultNotes
    }

    func saveNotes(_ notes: [Note]) {
        var arrayForStorage: [[String: Any]] = []
        notes.forEach { note in
            var newElementForStorage: [String: Any] = [:]
            newElementForStorage[NoteKey.title.rawValue] = note.titleText
            newElementForStorage[NoteKey.mainText.rawValue] = note.mainText
            newElementForStorage[NoteKey.date.rawValue] = note.date
            arrayForStorage.append(newElementForStorage)
        }
        storage.set(arrayForStorage, forKey: storageKey)
    }

    func appendNote(_ notes: [Note]) {
        var notesFromStorage = storage.array(forKey: storageKey) as? [[String: Any]] ?? []
        notes.forEach { note in
            var newElementForStorage: [String: Any] = [:]
            newElementForStorage[NoteKey.title.rawValue] = note.titleText
            newElementForStorage[NoteKey.mainText.rawValue] = note.mainText
            newElementForStorage[NoteKey.date.rawValue] = note.date
            notesFromStorage.append(newElementForStorage)
        }
        storage.set(notesFromStorage, forKey: storageKey)
    }
}
