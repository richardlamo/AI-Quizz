//
//  QuizzModel.swift
//  MyMacApp
//
//  Created by Richard Lam on 2/6/2024.
//

import Foundation
import SwiftUI


@Observable
class QuizzViewModel {
    var commentary : String = ""
    var question : String = ""
    var answerOptions : [String: String] = [:]
    var responseOther : String? = nil
    var subject : String = ""
    var answer : String = ""
    var askAnotherQuestion = false
    var chatHistory = ChatModel(messages: [])
    
    var commandPrompt = PromptEnum.none
    
    var promptChoice : PromptEnum = PromptEnum.none
    
    var url : String {
        let host = UserDefaults.standard.string(forKey: "host") ?? DefaultValues.host
        let port = UserDefaults.standard.string(forKey: "port") ?? DefaultValues.port

        return String(format: "http://%@:%@/api/chat", host, port)
    }
    
    init() {
        
    }
    
    init(question: String, answerOptions: [String: String],  questionOther : String?) {
        self.question = question
        self.answerOptions = answerOptions
        self.responseOther = questionOther
    }
    
    func requestChat(subject : String) async {
        self.subject = subject
        
        do {
            let chatUtil = ChatRequestUtil()
            let prompt = PromptModel.init(prompt: String(format: Constants.QUESTION_PROMPT, subject, Int.random(in: 1...10000)), model: Constants.MODEL, system: Constants.ASSISTANT)
            let newChat = ChatMessage(content: prompt.prompt)
            chatHistory.addPrompt(chatMessage: newChat)
            let generateResponseModel =  try await chatUtil.chatRequest(reqUrl: self.url, chatPrompt: chatHistory)
            chatHistory.addPrompt(chatMessage: generateResponseModel.message)
            createQuizz(aiGeneratedResponse: generateResponseModel.message.content)
            
            print("Response: \(generateResponseModel.message)")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func submitAnswer() async {
        do {
            let chatUtil = ChatRequestUtil()
            var prompt : PromptModel
            
            if (commandPrompt == PromptEnum.submit) {
                prompt = PromptModel.init(prompt: String(format: Constants.ANSWER_PROMPT, answer), model: Constants.MODEL, system: Constants.ASSISTANT)
            } else {
                prompt = PromptModel.init(prompt: commandPrompt.getPromptConstant(), model: Constants.MODEL, system: Constants.ASSISTANT)
            }
            
            let newChat = ChatMessage(content: prompt.prompt)
            chatHistory.addPrompt(chatMessage: newChat)
            let generateResponseModel =  try await chatUtil.chatRequest(reqUrl: self.url, chatPrompt: chatHistory)
            chatHistory.addPrompt(chatMessage: generateResponseModel.message)
            createQuizz(aiGeneratedResponse: generateResponseModel.message.content)
            answer=""

        } catch {
            print(error.localizedDescription)
        }
    }
    
    func returnYesNoOptions() -> Array<AnswerOptionModel>  {
        let yes = AnswerOptionModel(key: "Yes", value: "Yes")
        let no = AnswerOptionModel(key: "No", value: "No")
        return Array([yes,no])
    }
    
    func sortAnswer() -> Array<AnswerOptionModel>  {
        var result : [AnswerOptionModel] = []
        if !answerOptions.isEmpty {
            let sortedKeyValuePairs = answerOptions.sorted { $0.0 < $1.0 }
            for item in sortedKeyValuePairs {
                result.append(AnswerOptionModel(key: item.key, value: item.value))
            }
        }
        return result
    }
    
    func shouldGotoSummary() -> Bool {
        return (askAnotherQuestion && answer.lowercased() == "no")
    }
    
    func resetProperties() {
        answerOptions = [:]
        answer = ""
        responseOther = ""
        question = ""
    }
    
    func createQuizz(aiGeneratedResponse : String) {

        // Define the regex patterns for each option
        let patterns = [
//            "A": "A\\)([^B-D]+)",
//            "B": "B\\)([^C-D]+)",
//            "C": "C\\)([^D-D]+)",
//            "D": "D\\)([^\\n]+)"

            "A": "A\\) ([^\\n]+)",
            "B": "B\\) ([^\\n]+)",
            "C": "C\\) ([^\\n]+)",
            "D": "D\\) ([^\\n]+)"

        ]
        
        let beforeOptionsPattern = #"(?s)(.*?)\nA\)"#
        let afterOptionsPattern = "D\\) [^\n]+\n\n(.*)"
        
        askAnotherQuestion = aiGeneratedResponse.range(of: Constants.LIKE_ANOTHER_QUESTION) != nil
        print("Ask another question: \(askAnotherQuestion)")
        resetProperties()
        if askAnotherQuestion {
            question = aiGeneratedResponse
        } else {
            if let questionText = extractOption(from: aiGeneratedResponse, pattern: beforeOptionsPattern) {
                question = questionText.trimmingCharacters(in: .whitespacesAndNewlines)
                var fixOptionString = insertNewlineBeforeOccurrence(of: "Choose an answer", in: aiGeneratedResponse)
                fixOptionString = insertNewlineBeforeOccurrence(of: "A)", in: fixOptionString)
                fixOptionString = insertNewlineBeforeOccurrence(of: "B)", in: fixOptionString)
                fixOptionString = insertNewlineBeforeOccurrence(of: "C)", in: fixOptionString)
                fixOptionString = insertNewlineBeforeOccurrence(of: "D)", in: fixOptionString)
                // Extract and print each option
                if let answerOptionsString = substringFromLastOccurrence(of: "A)", in: fixOptionString) {
                    print("Options are:\n \(answerOptionsString)")
                    for (key, pattern) in patterns {
                        if let option = extractOption(from: answerOptionsString, pattern: pattern) {
                            answerOptions[key] = option.trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                    }
                    if let questionSuffix = extractOption(from: answerOptionsString, pattern: afterOptionsPattern) {
                        responseOther = questionSuffix
                    }
                }
                
                if answerOptions.isEmpty {
                    askAnotherQuestion = true
                }
            } else {
                question = aiGeneratedResponse
            }
        }
        print("Response: \(aiGeneratedResponse)")
        
    }

    // Function to extract options using regex
    private func extractOption(from text: String, pattern: String) -> String? {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let nsString = text as NSString
            let results = regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsString.length))
            if let match = results.first {
                return nsString.substring(with: match.range(at: 1))
            }
        } catch let error {
            print("Invalid regex: \(error.localizedDescription)")
        }
        return nil
    }
    
    func substringFromLastOccurrence(of substring: String, in text: String) -> String? {
        guard let range = text.range(of: substring, options: .backwards) else {
            return nil
        }
        return String(text[range.lowerBound...])
    }
                
    func insertNewlineBeforeOccurrence(of substring: String, in text: String) -> String {
        return text.replacingOccurrences(of: substring, with: "\n"+substring)
    }
    
}



