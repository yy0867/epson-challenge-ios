import Foundation

struct ConnectDTO {
  struct Request: Encodable {
    let device: String
    let password: String
  }
  
  struct Response: Decodable {
    let tokenType: String
    let accessToken: String
    let expiresIn: Double
    let refreshToken: String
    let subjectType: String
    let subjectId: String
  }
}

struct GenerateDTO {
  struct Request: Encodable {
    let input: String
  }
  
  struct Response: Decodable {
    let output: String
    let copies: Int
  }
}

struct CreatePrintDTO {
  struct Request {
    let data: Data
    let boundary: String
    
    init(accessToken: String, subjectId: String, copies: Int, html: String) {
      self.boundary = UUID().uuidString
      
      let htmlData = html.data(using: .utf8) ?? Data()
      
      var body = Data()
      body.append("--\(boundary)\r\n")
      body.append("Content-Disposition: form-data; name=\"access_token\"\r\n\r\n")
      body.append("\(accessToken)\r\n")
      
      body.append("--\(boundary)\r\n")
      body.append("Content-Disposition: form-data; name=\"subject_id\"\r\n\r\n")
      body.append("\(subjectId)\r\n")
      
      body.append("--\(boundary)\r\n")
      body.append("Content-Disposition: form-data; name=\"copies\"\r\n\r\n")
      body.append("\(copies)\r\n")
      
      body.append("--\(boundary)\r\n")
      body.append("Content-Disposition: form-data; name=\"file\"; filename=\"file.html\"\r\n")
      body.append("Content-Type: text/html; charset=utf-8\r\n\r\n")
      body.append(htmlData)
      body.append("\r\n")
      
      body.append("--\(boundary)--\r\n")

      self.data = body
    }
  }
  
  struct Response: Decodable {
    let jobId: String
  }
}

extension Data {
  
  mutating func append(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}

struct PrintStatusDTO {
  struct Request: Encodable {
    let subjectId: String
    let accessToken: String
    let jobId: String
  }
  
  struct Response: Decodable {
    let status: String
  }
}
