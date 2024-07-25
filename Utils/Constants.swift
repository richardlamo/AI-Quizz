//
//  Constants.swift
//  MyMacApp
//
//  Created by Richard Lam on 11/6/2024.
//

import Foundation


enum Constants {
    static let QUESTION_PROMPT = """
Give me a multiple choice question on %@.
"""
    static let ANSWER_PROMPT = "%@"
    static let GOODBYE_PROMPT = "That's all for now, thank you. What is my score?"
    static let NEXT_QUESTION_PROMPT = "Next question please."
    static let SKIP_QUESTION_PROMPT = "I've seen this question before. Give me another one randomly."
    static let MODEL = "llama3"
    static let ASSISTANT = "assistant"
    static let LIKE_ANOTHER_QUESTION = "another question?"
    static let HAVE_ANOTHER_QUESTION = "Here's another question:"
}
