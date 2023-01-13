//
//  NoteInfoPresenter.swift
//  SimpleNotes
//
//  Created by Снытин Ростислав on 12.01.2023.
//

import Foundation

class NoteInfoPresenter: NoteInfoPresenterProtocol {
    weak var view: NoteInfoViewInput?

    var noteInfo: Note = Note(titleText: "", mainText: "")
    var editDate: Date?

    func viewDidLoad() {
        editDate = noteInfo.date
        view?.showNoteInfo(noteInfo: noteInfo)
    }

    func saveNote(note: Note) {
        NoteStorage.shared.appendNote([note])
    }
}
