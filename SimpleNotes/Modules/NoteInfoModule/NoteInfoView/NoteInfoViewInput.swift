//
//  NoteInfoViewInput.swift
//  SimpleNotes
//
//  Created by Снытин Ростислав on 12.01.2023.
//

import Foundation

protocol NoteInfoViewInput: AnyObject {
    func showNoteInfo(noteInfo: Note)
}
