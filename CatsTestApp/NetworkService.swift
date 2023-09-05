//
//  NetworkService.swift
//  CatsTestApp
//
//  Created by Aliaksandr Pustahvar on 4.09.23.
//

import Foundation
import Alamofire

final class NetworkService {
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    func fetchData(path: String, page: String, key: String) async -> [CatModel] {
        let urlComponents = getUrlComponents(path: path, page: page, key: key)
        do {
            return try await AF.request(urlComponents).serializingDecodable([CatModel].self,
                                                                            decoder: decoder).value
        } catch {
            return []
        }
    }
    
    func fetchImageUrl(url: String) async -> CatImage? {
        do {
            return try await AF.request(url).serializingDecodable(CatImage.self,
                                                                  decoder: decoder).value
        } catch {
            return nil
        }
    }
    
    func getImage(url: String) async throws -> Data? {
        guard let url = URL(string: url) else {
            throw MyErrors.badUrl
        }
        let response = try await URLSession.shared.data(from: url)
        let data = response.0
        return data
    }
    
    func getUrlComponents(path: String, page: String, key: String) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.thecatapi.com"
        urlComponents.path = path
        urlComponents.queryItems = [.init(name: "limit", value: "10"),
                                    .init(name: "page", value: page),
                                    .init(name: "api_key", value: key)]
        return urlComponents
    }
    
    enum MyErrors: Error {
        case badUrl
    }
}
