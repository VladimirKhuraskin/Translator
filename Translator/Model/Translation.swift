//
//  Translation.swift
//  Translator
//
//  Created by Vladimir Khuraskin on 21.08.2018.
//  Copyright © 2018 Vladimir Khuraskin. All rights reserved.
//

import Foundation

struct Translation: Codable {
    let code: Int
    let lang: String
    let text: [String]
}
