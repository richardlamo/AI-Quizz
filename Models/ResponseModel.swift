//
//  ResponseModel.swift
//  MyMacApp
//
//  Created by Richard Lam on 28/5/2024.
//

import Foundation

struct ResponseModel: Decodable, Hashable {
    let model: String
    let created_at: String
    let response: String?
    let done: Bool
    let done_reason: String?
    let message : ChatMessage
    let context: [Int]?
    let total_duration: Int?
    let load_duration: Int?
    let prompt_eval_count: Int?
    let eval_count: Int?
    let eval_duration: Int?
}

struct DownloadResponseModel: Decodable, Hashable {
    let status: String?
    let digest: String?
    let total: Double?
    let completed: Double?
}


struct GenerateResponseModel: Decodable, Hashable {
    let model: String
    let created_at: String
    let response: String?
    let context: [Int]?
    let total_duration: Int?
    let load_duration: Int?
    let prompt_eval_count: Int?
    let eval_count: Int?
    let eval_duration: Int?
}
