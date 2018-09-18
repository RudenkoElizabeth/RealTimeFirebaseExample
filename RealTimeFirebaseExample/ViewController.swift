//
//  ViewController.swift
//  RealTimeFirebaseExample
//
//  Created by Elizabeth Rudenko on 17.09.2018.
//  Copyright © 2018 Elizabeth Rudenko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var database: DatabaseReference!
    var postArray = [PostModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        database = Database.database().reference()
        let postRef = database.child("post")
        postRef.observe(.value, with: { snapshot in
            self.postArray.removeAll()
            for item in snapshot.children {
                let child = item as! DataSnapshot
                let post = PostModel(snapshot: child)
                self.postArray.append(post)
            }
            self.tableView.reloadData()
        }) { error in
            self.alert(title: "Error", message: error.localizedDescription)
        }

        postRef.observe(.childRemoved, with: { snapshot in
            let post = PostModel(snapshot: snapshot)
            self.alert(title: "Removed object", message: "with name: \(post.name)\n description \(post.description)")
        })
    }

    private func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let data = postArray[indexPath.row]
        cell.nameLabel.text = data.name
        cell.descriptionLabel.text = data.description
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.database.child("post").child(postArray[indexPath.row].id).removeValue()
            postArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension ViewController {
    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        addItemAlert()
    }

    private func addItemAlert() {
        let alert = UIAlertController(title: "New post", message: "Enter a text", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Description"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let nameTextField = alert?.textFields![0]
            let descriptionTextField = alert?.textFields![1]
            let uuid = UUID().uuidString
            if let name = nameTextField?.text {
                self.database.child("post").child(uuid).child("name").setValue(name)
            }
            if let description = descriptionTextField?.text {
                self.database.child("post").child(uuid).child("description").setValue(description)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
