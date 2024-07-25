//
//  PromptModel.swift
//  MyMacApp
//
//  Created by Richard Lam on 28/5/2024.
//

import Foundation

struct PromptModel: Encodable {
    var prompt: String
    var model: String
    var system: String
    var stream: Bool = false
}

struct ChatModel: Encodable {
    var model: String = "llama3"
    var messages: [ChatMessage] = []
    var stream: Bool = false
    var options: OptionsModel = OptionsModel()
    
    mutating func addPrompt(chatMessage : ChatMessage) {
        self.messages.append(chatMessage)
    }
}

struct ChatMessage :Encodable, Equatable, Hashable, Decodable {
    var role: String = "user"
    var content: String
    var images: [String]?
}

struct OptionsModel : Encodable {
    var seed: Int = 101
    var temperature: Int = 0
}
