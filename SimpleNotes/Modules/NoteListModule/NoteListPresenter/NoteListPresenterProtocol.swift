//
//  NoteListPresenterProtocol.swift
//  SimpleNotes
//
//  Created by Снытин Ростислав on 12.01.2023.
//

import Foundation

protocol NoteListPresenterProtocol {
    func loadNotes()
    func deleteNote(indexPath: Int)
    func deleteNotes()
    func appendNote(note: Note)
}
