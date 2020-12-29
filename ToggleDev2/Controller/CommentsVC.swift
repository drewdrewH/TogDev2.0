//
//  CommentsVC.swift
//  ToggleDev2
//
//  Created by Walid Rafei on 12/28/20.
//

import UIKit

class CommentsVC: UIViewController {
    
    @IBOutlet weak var commentTextField: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var CommentInputBottomConstraint: NSLayoutConstraint!
    
    //MARK: - variables
    private var currentComments = [OGComment]()
    private let fetchedComments = CommentsViewModel()
    private var originalCommentTextViewHeight = CGFloat()

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
        addKeyBoardObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
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
    
    private func addKeyBoardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyBoardNotification(notification: NSNotification) {
        let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.CommentInputBottomConstraint.constant = isKeyboardShowing ? +keyboardSize.height : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut) {
                self.view.layoutIfNeeded()
            } completion: { (completed) in
            }

        }
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
