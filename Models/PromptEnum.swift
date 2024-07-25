//
//  PromptEnum.swift
//  MyMacApp
//
//  Created by Richard Lam on 28/6/2024.
//

import Foundation


enum PromptEnum {
    case submit, enough, skip, next, none
    
    func getButtonLabel() -> String {
        switch self {
        case .submit:
            return "Submit"
        case .enough:
            return "That's all for now, thanks."
        case .skip:
            return "I've seen this before, please skip."
        case .next:
            return "Next question please."
        case .none:
            return ""
        }
    }
    
    func getPromptConstant() -> String {
        switch self {
        case .submit:
            return Constants.ANSWER_PROMPT
        case .enough:
            return Constants.GOODBYE_PROMPT
        case .skip:
            return Constants.SKIP_QUESTION_PROMPT
        case .next:
            return Constants.NEXT_QUESTION_PROMPT
        case .none:
            return ""
        }
    }
    
}
