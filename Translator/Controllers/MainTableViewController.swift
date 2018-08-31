//
//  TableViewController.swift
//  Translator
//
//  Created by Vladimir Khuraskin on 20.08.2018.
//  Copyright © 2018 Vladimir Khuraskin. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController {
    
    var sourceLang: String?
    var targetLang: String?
    var dictOfLangs: [String: String]?
    var availabelLang = [String]()
    var tappedLang: String?
    var history: [History]?
    
    @IBOutlet weak var originalText: UITextView!
    @IBOutlet weak var translationText: UITextView!
    @IBOutlet weak var source: UIBarButtonItem!
    @IBOutlet weak var target: UIBarButtonItem!
    
    func getLangList() {
        TranslatorManager.shared.getAvailableLangs { langs in
            DispatchQueue.global().async {
                guard let langs = langs else { return }
                self.dictOfLangs = langs.langs
                for (_, value) in self.dictOfLangs! {
                    self.availabelLang.append(value)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let history = history else { return }
        originalText.text = history[0].originalText
        translationText.text = history[0].translationText
        sourceLang = history[0].sourceLang
        targetLang = history[0].targetLang
        source.title = history[0].sourceLang
        target.title = history[0].targetLang
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "⇄"
        getLangList()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(ok)
        present(ac, animated: true, completion: nil)
    }
    
    func getLangCode(sourceLang: String, targetLang: String) -> String {
        var code1 = ""
        var code2 = ""
        if let dictOfLangs = dictOfLangs {
            for (key, value) in dictOfLangs {
                if value == sourceLang {
                    code1 = key
                } else if value == targetLang {
                    code2 = key
                }
            }
        }
        return code1 + "-" + code2
    }
    
    func saveTranslationInHistory(lang: String, sourceLang: String, targetLang: String, originalText: String, translationText: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "History", in: context)
        let historyObject = NSManagedObject(entity: entity!, insertInto: context) as! History
        historyObject.lang = lang
        historyObject.sourceLang = sourceLang
        historyObject.targetLang = targetLang
        historyObject.originalText = originalText
        historyObject.translationText = translationText
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func close(segue: UIStoryboardSegue) {
    }
    
    @IBAction func unwindToMainScreen(segue: UIStoryboardSegue) {
        guard let svc = segue.source as? LangTableViewController else { return }
        if svc.tappedLang == "sourceLang" {
            sourceLang = svc.selectedLanguage
            source.title = sourceLang
        } else {
            targetLang = svc.selectedLanguage
            target.title = targetLang
        }
    }
    
    @IBAction func unwindFromHistory(segue: UIStoryboardSegue) {
        guard let svc = segue.source as? HistoryTableViewController else { return }
        history = svc.historyElement
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "langSegue" {
            if let dvc = segue.destination as? UINavigationController {
                if let targetController = dvc.topViewController as? LangTableViewController {
                    guard let tappedLang = tappedLang else { return }
                    targetController.langs = availabelLang.sorted()
                    targetController.tappedLang = tappedLang
                }
            }
        }
    }
    
    @IBAction func translateTapped(_ sender: UIButton) {
        guard let text = originalText.text else { return }
        if text == "" {
            showAlert(title: "Warning", message: "Please enter text for translation")
        }
        guard let sourceLang = sourceLang, let targetLang = targetLang else {
            showAlert(title: "Warning", message: "Please select the source language and the target language")
            return
        }
        self.view.endEditing(true)
        let lang = getLangCode(sourceLang: sourceLang, targetLang: targetLang)
        TranslatorManager.shared.getTranslate(text: text, lang: lang) { translation in
            DispatchQueue.main.async {
                guard let translation = translation else {
                    self.translationText.text = ""
                    return
                }
                self.translationText.text = translation.text[0]
                self.saveTranslationInHistory(lang: lang, sourceLang: sourceLang, targetLang: targetLang, originalText: text, translationText: translation.text[0])
                let code = translation.code
                if code != 200 {
                    let error = TranslatorManager.shared.errorHandler(code: code)
                    self.showAlert(title: "Error", message: error)
                }
            }
        }
    }
    
    @IBAction func clearTapped(_ sender: UIButton) {
        originalText.text = ""
        translationText.text = ""
        history = nil
    }
    
    @IBAction func chooseSourceLang(_ sender: UIBarButtonItem) {
        history = nil
        tappedLang = "sourceLang"
        performSegue(withIdentifier: "langSegue", sender: self)
    }
    
    @IBAction func chooseTargetLang(_ sender: UIBarButtonItem) {
        history = nil
        tappedLang = "targetLang"
        performSegue(withIdentifier: "langSegue", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
}
