//
//  NoteInfoAssemble.swift
//  SimpleNotes
//
//  Created by Снытин Ростислав on 12.01.2023.
//

import UIKit

class NoteInfoAssemble {
    static func assembleNoteInfoModule(
        noteInfo: Note,
        delegate: NoteInfoViewControllerDelegate
    ) -> UIViewController {
        let presenter = NoteInfoPresenter()
        let view = NoteInfoViewController(presenter: presenter)
        view.presenter = presenter
        view.delegate = delegate
        presenter.view = view
        presenter.noteInfo = noteInfo
        return view
    }
}
