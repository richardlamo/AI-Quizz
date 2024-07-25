//
//  ChatRequestUtil.swift
//  MyMacApp
//
//  Created by Richard Lam on 30/5/2024.
//

import Foundation




struct ChatRequestUtil {
    
    
    
    func makeNonStreamingRequest(url: String, requestModel: Encodable) async throws -> Data{

        guard let url = URL(string: url) else {
            throw NetError.invalidURL(error: nil)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        request.httpBody = try encoder.encode(requestModel)
        
        do {
            let syncData: Data
            let response: URLResponse

            (syncData, response) = try await URLSession.shared.data(for: request)
            let httpResponse = response as? HTTPURLResponse
            guard httpResponse?.statusCode == 200 else {
                throw NetError.httpError(statusCode: httpResponse!.statusCode)
            }
            return syncData
        } catch {
            throw NetError.invalidData(error: error)
        }
    }
    
    
    /**
            makes a request based on the URL "/api/chat"
            "http://127.0.0.1:11434/api/chat"
     */
    func chatRequest(reqUrl : String, chatPrompt : ChatModel)  async throws -> ResponseModel {
        let responseData = try await makeNonStreamingRequest(url: reqUrl, requestModel: chatPrompt)
        let promptResponse = try JSONDecoder().decode(ResponseModel.self, from: responseData)
        return promptResponse
    }
    
    /**
            makes a request based on the URL "/api/generate"
     */
    func generateRequest(reqUrl : String, prompt : PromptModel)  async throws -> GenerateResponseModel {
        
        if (!prompt.stream) {
            let responseData = try await makeNonStreamingRequest(url: reqUrl, requestModel: prompt)
            let promptResponse = try JSONDecoder().decode(GenerateResponseModel.self, from: responseData)
            return promptResponse
            
        } else {
            do {
                guard let url = URL(string: reqUrl) else {
                    throw NetError.invalidURL(error: nil)
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let encoder = JSONEncoder()
                encoder.keyEncodingStrategy = .convertToSnakeCase
                request.httpBody = try encoder.encode(prompt)

                let _ = String(data: request.httpBody!, encoding: .utf8)
                let data: URLSession.AsyncBytes
                let response: URLResponse
                
                let sessionConfig = URLSessionConfiguration.default
                sessionConfig.timeoutIntervalForRequest = 60
                sessionConfig.timeoutIntervalForResource = 604800

                (data, response) = try await URLSession(configuration: sessionConfig).bytes(for: request)

                let httpResponse = response as? HTTPURLResponse
                guard httpResponse?.statusCode == 200 else {
                    throw NetError.httpError(statusCode: httpResponse!.statusCode)
                }
                
                for try await line in data.lines {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = line.data(using: .utf8)!
                    let decoded = try decoder.decode(GenerateResponseModel.self, from: data)
                    
                    return decoded
                }
            } catch {
                throw NetError.unreachable(error: error)
            }
        }
        
        
        throw NetError.invalidResponse(error: nil)
        
    }
}
