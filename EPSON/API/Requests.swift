//
//  Requests.swift
//  EPSON
//
//  Created by Seyoung Kim on 6/20/24.
//

import Foundation

class Requests {
  
  enum RequestError: Error {
    case invalidResponse
  }
  
  static let shared = Requests()
  
  private init() {}
  
  private func encodeWithSnakeCase<T: Encodable>(_ value: T) -> Data? {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    
    return try? encoder.encode(value)
  }
  
  private func decodeWithSnakeCase<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    return try? decoder.decode(type.self, from: data)
  }
  
  private func request<T: Encodable>(httpMethod: String, with body: T?, to endpoint: String) async throws -> Data? {
    var request = URLRequest(url: URL(string: Constants.baseURL + endpoint)!)
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = httpMethod
    if let body {
      request.httpBody = encodeWithSnakeCase(body)
    }
    
    let (data, _) = try await URLSession.shared.data(for: request)
    return data
  }
  
  // MARK: - Auth
  func authorize(email: String, password: String) async throws -> (token: String, subjectId: String) {
    try await Task.sleep(for: .seconds(1))
    
    let body = ConnectDTO.Request(device: email, password: password)
    guard let data = try await request(httpMethod: "POST", with: body, to: "/connect"),
          let response = decodeWithSnakeCase(ConnectDTO.Response.self, from: data) else {
      throw RequestError.invalidResponse
    }
    
    
    return (token: response.accessToken, subjectId: response.subjectId)
  }
  
  func generate(recordedText: String) async throws -> (output: String, copies: Int) {
    let body = GenerateDTO.Request(input: recordedText)
    guard let data = try await request(httpMethod: "POST", with: body, to: "/generate"),
          let output = String(data: data, encoding: .utf8) else {
      throw RequestError.invalidResponse
    }
    let copiesRegex = /<!-- copies (\d+) -->/
    let copies = try copiesRegex.firstMatch(in: output)?.output.1 ?? "1"
    
    return (output: output, copies: Int(copies) ?? 1)
  }
  
  func createPrint(html: String, copies: Int, token: String, subjectId: String) async throws -> String {
    let body = CreatePrintDTO.Request(accessToken: token, subjectId: subjectId, copies: copies, html: html)
    var request = URLRequest(url: URL(string: Constants.baseURL + "/print")!)
    
    request.setValue("multipart/form-data; boundary=\(body.boundary)", forHTTPHeaderField: "Content-Type")
    request.httpBody = body.data
    request.httpMethod = "POST"
    
    let (data, _) = try await URLSession.shared.data(for: request)
    guard let response = decodeWithSnakeCase(CreatePrintDTO.Response.self, from: data) else {
      throw RequestError.invalidResponse
    }
    
    return response.jobId
  }
  
  func isPrintCompleted(token: String, subjectId: String, jobId: String) async throws -> Bool {
    let body = PrintStatusDTO.Request(subjectId: subjectId, accessToken: token, jobId: jobId)
    guard let data = try await request(httpMethod: "POST", with: body, to: "/print/status"),
          let response = decodeWithSnakeCase(PrintStatusDTO.Response.self, from: data) else {
      throw RequestError.invalidResponse
    }
    
    return response.status == "completed"
  }
}
