//
//  LangTableViewController.swift
//  Translator
//
//  Created by Vladimir Khuraskin on 23.08.2018.
//  Copyright © 2018 Vladimir Khuraskin. All rights reserved.
//

import UIKit

class LangTableViewController: UITableViewController {
    
    var langs = [String]()
    var tappedLang = ""
    var selectedLanguage = ""
    var sourceLang = ""
    var targetLang = ""
    
    let favoriteLangs = ["Russian", "English", "Spanish", "French", "German"]
    let sections = ["Favorite languages", "All languages"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choose language"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return favoriteLangs.count
        default:
            return langs.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .clear
        switch indexPath.section {
        case 0:
            let lang = favoriteLangs[indexPath.row]
            cell.textLabel?.text = lang
        default:
            let lang = langs[indexPath.row]
            cell.textLabel?.text = lang
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.init(red: 0.2, green: 0.3, blue: 0.5, alpha: 0.6)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            selectedLanguage = favoriteLangs[indexPath.row]
        default:
            selectedLanguage = langs[indexPath.row]
        }
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "backWithLangSegue", sender: nil)
    }
    
}
