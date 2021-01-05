//
//  CommentsVC.swift
//  ToggleDev2
//
//  Created by Walid Rafei on 12/28/20.
//

import UIKit
import Amplify
import AmplifyPlugins

class CommentsVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var commentTextField: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var CommentInputBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var postButton: UIButton!
    
    //MARK: - variables
    private var currentComments = [Comment]()
    private let fetchedComments = CommentViewModel()
    
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        for comment in fetchedComments.comments {
            currentComments.append(comment)
        }
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
        tableView.delegate = self
        tableView.dataSource = self
        commentTextField.delegate = self
        addKeyBoardObservers()
        setupCommentTextView()
        disablePostButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        makeTextFieldFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        removeKeyboardObservers()
    }
    
    //MARK: - IB actions
    @IBAction func BackgroundTapped(_ sender: Any) {
        self.dismissKeyboard()
    }
    
    //MARK: - helpers
    private func setupNavBar() {
        self.navigationItem.title = "Comments"
        let navTitleAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 25, weight: UIFont.Weight(rawValue: 0.2))]
        self.navigationController?.navigationBar.titleTextAttributes = navTitleAttributes
        self.tableView.backgroundColor = .black
        self.tableView.separatorStyle = .none
    }
    
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupCommentTextView() {
        commentTextField.text = "Add a comment..."
        commentTextField.textColor = UIColor.lightGray
    }
    
    private func disablePostButton() {
        postButton.isUserInteractionEnabled = false
        postButton.setTitleColor(#colorLiteral(red: 0.5723509192, green: 0.5705082417, blue: 0.5704616308, alpha: 1), for: .normal)
    }
    
    private func makeTextFieldFirstResponder() {
        commentTextField.becomeFirstResponder()
    }
    
    private func enablePostButton() {
        postButton.isUserInteractionEnabled = true
        postButton.setTitleColor(#colorLiteral(red: 0.2588235294, green: 0.8705882353, blue: 0.8823529412, alpha: 1), for: .normal)
    }
    
    private func scrollToBottom() {
        if currentComments.count != 0 {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                let indexPath = IndexPath(row: self.currentComments.count-1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    private func resetContainerConstraints() {
        let guide = view.safeAreaLayoutGuide
        var frame = commentTextField.frame
        frame.size.height = 50
        commentTextField.frame = frame
        commentContainerHeight.constant  = 0.01 * guide.layoutFrame.height
    }
    
    private func addKeyBoardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyBoardNotification(notification: NSNotification) {
        self.commentTextField.snapshotView(afterScreenUpdates: true)
        let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.CommentInputBottomConstraint.constant = isKeyboardShowing ? +keyboardSize.height : 0
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut) {
                self.view.layoutIfNeeded()
            } completion: { (completed) in
            }
        }
    }
    
    //MARK: - IB Actions
    @IBAction func postButtonPressed(_ sender: Any) {
        let comment = Comment(content: commentTextField.text, owner: User(name: "Walid"))
        currentComments.append(comment)
        // TODO: put this comment in the cloud
        setupCommentTextView()
        scrollToBottom()
        disablePostButton()
        commentTextField.resignFirstResponder()
        resetContainerConstraints()
    }
    
}

//MARK: - comment Text View delegate

extension CommentsVC: UITextViewDelegate {
    
    private func adjustTextViewHeight() {
        let guide = view.safeAreaLayoutGuide
        let maxCommentContainerHeight = 0.15 * guide.layoutFrame.height
        let previousHeight = commentTextField.frame.height
        var frame = commentTextField.frame;
        frame.size.height = commentTextField.contentSize.height;
        
        if(frame.size.height >= maxCommentContainerHeight) {
            return
        }
        
        commentTextField.frame = frame
        commentContainerHeight.constant += frame.size.height - previousHeight
        self.view.layoutIfNeeded()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add a comment..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if (commentTextField.text == "Add a comment..." || commentTextField.text == "") {
            disablePostButton()
        } else {
            enablePostButton()
        }
        self.adjustTextViewHeight()
    }
}

//MARK: - tablew view delegate
extension CommentsVC: UITableViewDelegate {
    
}

//MARK: - tableview data source
extension CommentsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = currentComments[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentTableViewCell
        cell.configure(with: model)
        return cell
    }
    
}
