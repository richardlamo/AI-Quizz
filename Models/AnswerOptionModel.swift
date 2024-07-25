//
//  QuizzModel.swift
//  MyMacApp
//
//  Created by Richard Lam on 9/6/2024.
//

import Foundation

struct AnswerOptionModel : Hashable, Identifiable {
    let id = UUID()
    let key : String
    let value : String
}
