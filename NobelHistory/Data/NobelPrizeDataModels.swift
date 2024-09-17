//
//  NobelPrizeDataModels.swift
//  NobelHistory
//
//  Created by Lars Dahmen on 20.09.23.
//

import Foundation

struct LocalisedValue: Decodable, Equatable, Hashable {
    let en: String
}

struct NobelPrices: Decodable, Hashable {
    let nobelPrizes: [NobelPrize]
}

struct NobelPrize: Decodable, Equatable, Hashable {
    struct Category: Decodable, Equatable, Hashable {
        let en: String
    }
    
    let awardYear: String
    let category: Category
    let laureates: [NobelLaureate]?
    
    // New stored property to hold the unique ID, since the reponse does not have a ID
    var uniqueID: Int?
    
    mutating func assignUniqueID(index: Int) {
        self.uniqueID = index
    }
}

struct NobelLaureate: Decodable, Equatable, Hashable {
    let id: String
    let fullName: LocalisedValue?
    let orgName: LocalisedValue?
    let gender: String?
    let birth: LifeEvent?
    let death: LifeEvent?
    
    func name() -> String { fullName?.en ?? orgName?.en ?? "?" }
}

struct LifeEvent: Decodable, Equatable, Hashable {
    let date: String
    let place: Place
}

struct Place: Decodable, Equatable, Hashable {
    let city: LocalisedValue?
    let country: LocalisedValue?
    let cityNow: LocalisedValue?
    let countryNow: LocalisedValue?
    let continent: LocalisedValue?
    let locationString: LocalisedValue?
}


