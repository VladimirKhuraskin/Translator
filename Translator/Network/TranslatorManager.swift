//
//  TranslatorManager.swift
//  Translator
//
//  Created by Vladimir Khuraskin on 21.08.2018.
//  Copyright © 2018 Vladimir Khuraskin. All rights reserved.
//

import Foundation

class TranslatorManager {
    
    static let shared = TranslatorManager()
    
    let key = "trnsl.1.1.20180820T160135Z.8171bbe6a94bdc24.d0309e06282d767930e40cf640e2c702e83c344a"
    let getLangsUrl = "https://translate.yandex.net/api/v1.5/tr.json/getLangs"
    let translateUrl = "https://translate.yandex.net/api/v1.5/tr.json/translate"
    
    func getTranslate(text: String, lang: String, completion: @escaping (Translation?) -> Void) {

        guard var components = URLComponents(string: translateUrl) else { return }
        components.queryItems = [URLQueryItem(name: "key", value: key),
                                 URLQueryItem(name: "text", value: text),
                                 URLQueryItem(name: "lang", value: lang),
                                 URLQueryItem(name: "format", value: "plain"),
                                 URLQueryItem(name: "options", value: String(1))]
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }

            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let translation = try JSONDecoder().decode(Translation.self, from: data)
                completion(translation)
            } catch {
                print(error)
                completion(nil)
            }
            }.resume()
    }
    
    func getAvailableLangs(completion: @escaping (Languages?) -> Void) {
        
        guard let url = URL(string: getLangsUrl + "?key=\(key)&ui=en") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let langs = try JSONDecoder().decode(Languages.self, from: data)
                completion(langs)
            } catch {
                print(error)
                completion(nil)
            }
            }.resume()
    }
    
    func errorHandler(code: Int) -> String {
        
        switch code {
        case 401:
            return "Invalid API key"
        case 402:
            return "API Key Locked"
        case 404:
            return "The daily limit on the volume of the translated text was exceeded"
        case 413:
            return "Maximum text size exceeded"
        case 422:
            return "Text can not be translated"
        case 501:
            return "Specified translation direction is not supported"
        default:
            return ""
        }
    }
    
    private init(){}
}
