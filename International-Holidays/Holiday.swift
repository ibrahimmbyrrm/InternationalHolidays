//
//  Holiday.swift
//  International-Holidays
//
//  Created by İbrahim Bayram on 31.01.2023.
//

import Foundation

struct HolidayResponse: Decodable {
    var response : Holidays
}

struct Holidays : Decodable {
    var holidays : [HolidayDetail]
}

struct HolidayDetail : Decodable {
    var name : String
    var date : DateInfo
    var description : String
}

struct DateInfo : Decodable {
    var iso : String
}

