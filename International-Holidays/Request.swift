//
//  Request.swift
//  International-Holidays
//
//  Created by İbrahim Bayram on 31.01.2023.
//

import Foundation

enum HolidayError : Error {
    case noDaataAvaiable
    case canNotProcessData
}

struct HolidayRequest {
    let resourceURL : URL?
    let API_KEY = "f3f1a00527af8b56764af821396383d9d5a17575"
    
    init(countryCode : String) {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        let currentYear = format.string(from: date)
        
        let resourceString = "https://calendarific.com/api/v2/holidays?&api_key=\(API_KEY)&country=\(countryCode)&year=\(currentYear)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        self.resourceURL = resourceURL
      
    }
    func getData (completion : @escaping(Result<[HolidayDetail] , HolidayError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL!) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDaataAvaiable))
                return
            }
            do {
                let holidayResponse = try? JSONDecoder().decode(HolidayResponse.self, from: jsonData)
                let holidayDetails = holidayResponse?.response.holidays
                guard let results = holidayDetails else {return}
                completion(.success(results))
            }catch {
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
}
