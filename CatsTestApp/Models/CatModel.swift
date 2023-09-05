//
//  CatModel.swift
//  CatsTestApp
//
//  Created by Aliaksandr Pustahvar on 4.09.23.
//

import Foundation

struct CatModel: Decodable, Hashable {
    let name: String
    let wikipediaUrl: String?
    let referenceImageId: String?
}

struct CatImage: Decodable {
    let url: String
}
