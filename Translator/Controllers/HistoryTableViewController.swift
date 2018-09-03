//
//  HistoryTableViewController.swift
//  Translator
//
//  Created by Vladimir Khuraskin on 23.08.2018.
//  Copyright © 2018 Vladimir Khuraskin. All rights reserved.
//

import UIKit
import CoreData

class HistoryTableViewController: UITableViewController {
    
    var history = [History]()
    var historyElement = History()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let history = CoreDataManager.shared.fetchHistory() else { return }
        self.history = history
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "History"
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryTableViewCell
        cell.backgroundColor = .clear
        let historyElement = history[indexPath.row]
        cell.configure(with: historyElement)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        historyElement = history[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "unwindFromHistorySegue", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let objectToDelete = history[indexPath.row]
        guard editingStyle == .delete else { return }
        CoreDataManager.shared.delete(fromHistory: objectToDelete)
        history.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
}
