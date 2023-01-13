//
//  NoteListViewController.swift
//  SimpleNotes
//
//  Created by Снытин Ростислав on 12.01.2023.
//

import UIKit

class NoteListViewController: UIViewController {
    var presenter: NoteListPresenter

    private var tableView = UITableView()
    private var addNoteButton = UIButton()
    private var backItem = UIBarButtonItem()
    private var rightBarButton = UIBarButtonItem()

    private let navigationTitle = "Заметки"
    private let chooseRightButtonTitle = "Выбрать"
    private let doneRightButtonTitle = "Готово"
    private let emptyValue = ""

    private var firstButtonConst: NSLayoutConstraint?
    private var secondButtonConst: NSLayoutConstraint?

    init(presenter: NoteListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: Constant.screenBackgroundColor)

        setupNavigationBar()
        setupTableView()
        setupAddButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadNotes()
        secondButtonConst?.isActive = false
        firstButtonConst = addNoteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 60)
        firstButtonConst?.isActive = true
        view.layoutSubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        buttonAppearAnimation()
    }
}

// MARK: SetupUI

extension NoteListViewController {
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(named: Constant.screenBackgroundColor)
        navigationItem.title = navigationTitle
        backItem.title?.removeAll()
        navigationItem.backBarButtonItem = backItem

        navigationItem.rightBarButtonItem = rightBarButton
        rightBarButton.title = chooseRightButtonTitle
        rightBarButton.target = self
        rightBarButton.style = .plain
        rightBarButton.action = #selector(didRightBarButtonTapped(_:))
    }

    @objc private func didRightBarButtonTapped(_ sender: Any) {
        presenter.indices.removeAll()
        tableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing {
            rightBarButton.title = doneRightButtonTitle
            UIView.transition(
                with: addNoteButton,
                duration: 0.5,
                options: [.transitionFlipFromLeft],
                animations: {
                    self.addNoteButton.setImage(UIImage(named: Constant.deleteButtonImage), for: .normal)
                }
            )
        } else {
            changeButtonFunctionAnimation()
        }
    }

    private func setupTableView() {
        tableView.register(NoteListCellView.self, forCellReuseIdentifier: NoteListCellView.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.isEditing = false

        tableView.backgroundColor = UIColor(named: Constant.screenBackgroundColor)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupAddButton() {
        addNoteButton.layer.cornerRadius = 25
        addNoteButton.clipsToBounds = true
        addNoteButton.setImage(UIImage(named: Constant.addButtonImage), for: .normal)
        addNoteButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        addNoteButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(addNoteButton)
        NSLayoutConstraint.activate([
            addNoteButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -19),
            addNoteButton.widthAnchor.constraint(equalToConstant: 50.0),
            addNoteButton.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }

    @objc private func buttonTapped(_ sender: Any) {
        if tableView.isEditing {
            if presenter.indices.isEmpty {
                let action = UIAlertController(
                    title: "Ошибка",
                    message: "Вы не выбрали ни одной заметки",
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(
                    title: "OK",
                    style: .default
                )
                action.addAction(okAction)
                present(action, animated: true)
            } else {
                deleteRowsButtonAnimation()
            }
        } else {
            pushVCButtonAnimation()
        }
    }
}

// MARK: Setup TableView

extension NoteListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        presenter.arrayOfNotes.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: NoteListCellView.cellIdentifier,
            for: indexPath
        ) as? NoteListCellView {
            cell.configure(note: presenter.arrayOfNotes[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            presenter.deleteNote(indexPath: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
            tableView.reloadData()
        }
    }

    func tableView(
        _ tableView: UITableView,
        shouldIndentWhileEditingRowAt indexPath: IndexPath
    ) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            presenter.indices.append(indexPath.row)
            tableView.cellForRow(at: indexPath)?.setSelected(true, animated: true)
        } else {
            let note = presenter.arrayOfNotes[indexPath.row]
            presenter.arrayOfNotes.remove(at: indexPath.row)
            let vc = NoteInfoAssemble.assembleNoteInfoModule(noteInfo: note, delegate: self)
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        presenter.indices.removeAll(where: { $0 == indexPath.row })
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
    }
}

// MARK: ViewInput

extension NoteListViewController: NoteListViewInput {
    func reloadData() {
        tableView.reloadData()
    }

    func removeRows(rows: [IndexPath]) {
        self.tableView.deleteRows(at: rows, with: .right)
    }
}

// MARK: Delegate

extension NoteListViewController: NoteInfoViewControllerDelegate {
    func saveNote(note: Note) {
        presenter.appendNote(note: note)
    }
}

// MARK: Setup animation

extension NoteListViewController {
    private func buttonAppearAnimation() {
        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.1,
            initialSpringVelocity: 10,
            options: [.layoutSubviews],
            animations: {
                self.firstButtonConst?.isActive = false
                self.secondButtonConst = self.addNoteButton.bottomAnchor.constraint(
                    equalTo: self.view.bottomAnchor,
                    constant: -60
                )
                self.secondButtonConst?.isActive = true
                self.view.layoutSubviews()
            }
        )
    }

    private func pushVCButtonAnimation() {
        UIView.animateKeyframes(
            withDuration: 1,
            delay: 0,
            options: [.layoutSubviews],
            animations: {
                self.pushVCButtonAnimationKeyFrames()
            },
            completion: { _ in
                let vc = NoteInfoAssemble.assembleNoteInfoModule(
                    noteInfo: Note(titleText: "", mainText: ""),
                    delegate: self
                )
                self.navigationController?.pushViewController(vc, animated: true)
            }
        )
    }

    private func pushVCButtonAnimationKeyFrames() {
        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25) {
            self.addNoteButton.layer.position.y -= 75
        }
        UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
            self.addNoteButton.layer.position.y += 500
        }
    }

    private func changeButtonFunctionAnimation() {
        rightBarButton.title = chooseRightButtonTitle
        UIView.transition(
            with: addNoteButton,
            duration: 0.5,
            options: [.transitionFlipFromRight],
            animations: {
                self.addNoteButton.setImage(UIImage(named: Constant.addButtonImage), for: .normal)
            }
        )
    }

    private func deleteRowsButtonAnimation() {
        UIView.animate(
            withDuration: 0.5,
            animations: {
                self.presenter.deleteNotes()
            },
            completion: { _ in
                self.tableView.reloadData()
                self.tableView.isEditing = false
                self.changeButtonFunctionAnimation()
            }
        )
    }
}
