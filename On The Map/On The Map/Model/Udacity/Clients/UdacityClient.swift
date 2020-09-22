//
//  UdacityClient.swift
//  On The Map
//
//  Created by Binyamin Alfassi on 16/09/2020.
//  Copyright © 2020 Binyamin Alfassi. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class UdacityClient {
    
    struct Auth {
        static var sessionId = ""
        static let uniqueKey = "4321"
        static let fistName = "Mr."
        static let lastName = "Bond"
        static var objectId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getStudentLocation (limit: Int)
        case createSession
        case postStudentLocation
        case logout
        
        var stringValue: String {
            switch self {
            case .getStudentLocation(let limit): return Endpoints.base + "/StudentLocation?limit=\(limit)&order=-updatedAt"
            case .createSession: return Endpoints.base + "/session"
            case .postStudentLocation: return Endpoints.base + "/StudentLocation"
            case .logout: return Endpoints.base + "/session"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, skipBits: Bool = false, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {DispatchQueue.main.async {
                completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let newData: Data
                if skipBits {
                    let range = 5..<data.count
                    newData = data.subdata(in: range)
                } else { newData = data}
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async{
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let newData: Data
                    if skipBits {
                        let range = 5..<data.count
                        newData = data.subdata(in: range)
                    } else {newData = data}
                    let errorResponse = try decoder.decode(SessionErrorResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func taskForGetRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                  completion(nil, error)
                }
                return
            }
            let newData = data
            let decoder = JSONDecoder()
            print(String(data: newData, encoding: .utf8)!)
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let range = 5..<data.count
                    let newData = data.subdata(in: range)
                    let errorResponse = try
                        decoder.decode(SessionErrorResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    print(error)
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func createSessionId(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let credentials: [String : String] = [Credentials.username.rawValue : username, Credentials.password.rawValue: password]
        let body = SessionRequest(udacity: credentials)
        taskForPOSTRequest(url: Endpoints.createSession.url, responseType: SessionResponse.self, body: body, skipBits: true) { (response, error) in
            if let response = response {
                Auth.sessionId = response.session.id
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getStudentsLocation(completion: @escaping ([StudentLocation], Error?) -> Void) {
        taskForGetRequest(url: Endpoints.getStudentLocation(limit: 100).url, responseType: StudentsLocationResponse.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func postStudentLocation(studentLocation: MKAnnotation, mediaURL: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = StudentLocationBody(uniqueKey: Auth.uniqueKey, firstName: Auth.fistName, lastName: Auth.lastName, latitude: Float(studentLocation.coordinate.latitude), longitude: Float(studentLocation.coordinate.longitude), mapString: ((studentLocation.title) ?? "")!, mediaURL: mediaURL)
        taskForPOSTRequest(url: Endpoints.postStudentLocation.url, responseType: StudentLocationPostResponse.self, body: body) { (response, error) in
            if let response = response {
                Auth.objectId = response.objectId
                completion(true, nil)
            } else {
                print(error)
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {xsrfCookie = cookie}
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            Auth.sessionId = ""
            Auth.objectId = ""
            DispatchQueue.main.async {
                completion()
            }
        }
        task.resume()
    }
}
