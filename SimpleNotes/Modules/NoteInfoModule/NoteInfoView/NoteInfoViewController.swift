//
//  NoteInfoViewController.swift
//  SimpleNotes
//
//  Created by Снытин Ростислав on 12.01.2023.
//

import UIKit

class NoteInfoViewController: UIViewController {
    var presenter: NoteInfoPresenter

    weak var delegate: NoteInfoViewControllerDelegate?

    private var mainTextField = UITextView()
    private var titleTextField = UITextField()
    private var rightBarButton = UIBarButtonItem()
    private var mainContainer = UIView()
    private var dateLabel = UILabel()

    private let doneRightButtonTitle = "Готово"
    private let placeholderTitleTextField = "Введите название"
    private let emptyValue = ""

    init(presenter: NoteInfoPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: Constant.screenBackgroundColor)

        setupBarButtons()
        setupViewContainer()
        setupDateButton()
        setupTitleTextField()
        setupMainTextView()

        addObservers()

        presenter.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !presenter.noteInfo.isEmpty {
            delegate?.saveNote(note: presenter.noteInfo)
        }
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showKeyboard),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillTerminate(notification:)),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
    }

    @objc private func showKeyboard() {
        rightBarButton.isEnabled = true
        rightBarButton.title = doneRightButtonTitle
        let nowDate = Date()
        presenter.editDate = nowDate
        dateLabel.text = DateFormat.dateToday(day: nowDate, formatter: Constant.noteDateFormatter)
        presenter.noteInfo = Note(
            titleText: titleTextField.text ?? emptyValue,
            mainText: mainTextField.text,
            date: nowDate
        )
    }

    @objc private func applicationWillTerminate(notification: Notification) {
        if !presenter.noteInfo.isEmpty {
            let note = Note(
                titleText: titleTextField.text ?? "",
                mainText: mainTextField.text,
                date: Date()
            )
            presenter.saveNote(note: note)
        }
    }
}

// MARK: Setup UI

extension NoteInfoViewController {
    private func setupBarButtons() {
        navigationItem.rightBarButtonItem = rightBarButton
        rightBarButton.title = emptyValue
        rightBarButton.isEnabled = false
        rightBarButton.target = self
        rightBarButton.style = .plain
        rightBarButton.action = #selector(didRightBarButtonTapped(_:))
    }

    @objc private func didRightBarButtonTapped(_ sender: Any) {
        presenter.noteInfo.titleText = titleTextField.text ?? emptyValue
        presenter.noteInfo.mainText = mainTextField.text
        if !checkEmptyStroke() {
            self.view.endEditing(true)
            rightBarButton.isEnabled = false
            rightBarButton.title?.removeAll()
        }
    }

    private func setupViewContainer() {
        self.view.addSubview(mainContainer)
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainContainer.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -20
            ),
            mainContainer.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor,
                constant: 20
            ),
            mainContainer.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor,
                constant: -20
            )
        ])
    }

    private func setupTitleTextField() {
        mainContainer.addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            titleTextField.leftAnchor.constraint(equalTo: mainContainer.leftAnchor, constant: 3.5),
            titleTextField.rightAnchor.constraint(equalTo: mainContainer.rightAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: 44.0)
        ])
        titleTextField.adjustsFontSizeToFitWidth = false
        titleTextField.font = .systemFont(ofSize: 24.0, weight: .medium)
        titleTextField.placeholder = placeholderTitleTextField
    }

    private func setupMainTextView() {
        mainContainer.addSubview(mainTextField)
        mainTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTextField.leftAnchor.constraint(equalTo: mainContainer.leftAnchor),
            mainTextField.rightAnchor.constraint(equalTo: mainContainer.rightAnchor),
            mainTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor),
            mainTextField.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor)
        ])
        mainTextField.font = .systemFont(ofSize: 16.0, weight: .regular)
        mainTextField.backgroundColor = UIColor(named: Constant.screenBackgroundColor)
        mainTextField.adjustableForKeyboard()

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToMainText(_:)))
        mainTextField.addGestureRecognizer(tap)
    }

    @objc func tapToMainText(_ sender: UITapGestureRecognizer) {
        mainTextField.becomeFirstResponder()
        let endOfDocument = mainTextField.endOfDocument
        mainTextField.selectedTextRange = mainTextField.textRange(from: endOfDocument, to: endOfDocument)
    }

    private func setupDateButton() {
        mainContainer.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.leftAnchor.constraint(equalTo: mainContainer.leftAnchor),
            dateLabel.rightAnchor.constraint(equalTo: mainContainer.rightAnchor),
            dateLabel.topAnchor.constraint(equalTo: mainContainer.topAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 40.0)
        ])
        dateLabel.textAlignment = .center
        dateLabel.font = .systemFont(ofSize: 14, weight: .medium)
        dateLabel.textColor = UIColor(red: 172 / 255, green: 172 / 255, blue: 172 / 255, alpha: 1)
    }

    private func checkEmptyStroke() -> Bool {
        if presenter.noteInfo.isEmpty {
            let action = UIAlertController(
                title: "Ошибка",
                message: "Заполните поля",
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(
                title: "OK",
                style: .default
            )
            action.addAction(okAction)
            present(action, animated: true)
            return true
        } else {
            return false
        }
    }
}

// MARK: ViewInput

extension NoteInfoViewController: NoteInfoViewInput {
    func showNoteInfo(noteInfo: Note) {
        titleTextField.text = noteInfo.titleText
        mainTextField.text = noteInfo.mainText
        dateLabel.text = "\(DateFormat.dateToday(day: noteInfo.date ?? Date(), formatter: Constant.noteDateFormatter))"
    }
}

// MARK: Delegate

protocol NoteInfoViewControllerDelegate: AnyObject {
    func saveNote(note: Note)
}
