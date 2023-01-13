//
//  NoteListPresenter.swift
//  SimpleNotes
//
//  Created by Снытин Ростислав on 12.01.2023.
//

import Foundation

class NoteListPresenter: NoteListPresenterProtocol {
    weak var view: NoteListViewInput?

    var arrayOfNotes: [Note] = [] {
        didSet {
            arrayOfNotes = arrayOfNotes.sorted(by: { $0.date ?? Date() > $1.date ?? Date() })
           }
    }

    var indices: [Int] = [] {
        didSet {
            indices = indices.sorted(by: { $0 > $1 })
        }
    }

    private var firstLoadApp = true

    func loadNotes() {
        arrayOfNotes = NoteStorage.shared.loadNotes()
        if arrayOfNotes.isEmpty && firstLoadApp {
            arrayOfNotes.append(Note(titleText: "Заголовок заметки", mainText: "Основной текст"))
        } else if !arrayOfNotes.isEmpty {
            firstLoadApp = false
        }
        view?.reloadData()
    }

    func deleteNote(indexPath: Int) {
        arrayOfNotes.remove(at: indexPath)
        NoteStorage.shared.saveNotes(arrayOfNotes)
    }

    func deleteNotes() {
        var index: [IndexPath] = []
        indices.forEach({
            arrayOfNotes.remove(at: $0)
            index.append(IndexPath(row: $0, section: 0))
        })
        NoteStorage.shared.saveNotes(arrayOfNotes)
        view?.removeRows(rows: index)
    }

    func appendNote(note: Note) {
        arrayOfNotes.append(note)
        NoteStorage.shared.saveNotes(arrayOfNotes)
        view?.reloadData()
    }
}
