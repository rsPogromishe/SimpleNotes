//
//  NoteListAssemble.swift
//  SimpleNotes
//
//  Created by Снытин Ростислав on 12.01.2023.
//

import UIKit

class NoteListAssemble {
    static func assembleNoteListModule() -> UIViewController {
        let presenter = NoteListPresenter()
        let view = NoteListViewController(presenter: presenter)
        view.presenter = presenter
        presenter.view = view
        return view
    }
}
