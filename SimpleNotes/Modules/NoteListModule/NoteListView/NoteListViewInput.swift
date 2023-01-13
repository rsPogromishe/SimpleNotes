//
//  NoteListViewInput.swift
//  SimpleNotes
//
//  Created by Снытин Ростислав on 12.01.2023.
//

import Foundation

protocol NoteListViewInput: AnyObject {
    func reloadData()
    func removeRows(rows: [IndexPath])
}
