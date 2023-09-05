//
//  CatsCollectionViewModel.swift
//  CatsTestApp
//
//  Created by Aliaksandr Pustahvar on 4.09.23.
//

import Foundation
import UIKit

class CatsCollectionViewModel {
    
    let network = NetworkService()
    var isPagOn = false
    
    let imageUrl = "https://api.thecatapi.com/v1/images/"
    let path = "/v1/breeds"
    var page = 0
    let key = "live_skpFP9TrYQk2jSlewvXJVbPVlw4DMEB5dw6rOFtgMkisvswqjORjTxeM5KFBVQkg"
    
    private  var cats: [CatModel] = [CatModel]()
    var updateCollection: (([CatModel], _ page: Int) -> Void)?
    
    private let imageCache = NSCache<NSString, NSData>()
    
    init() {
        Task{
            print(page)
            cats = await network.fetchData(path: path, page: String(page), key: key)
            self.updateCollection?(cats, page)
        }
    }
    
    func getImageDataFromCache(for name: String) -> Data? {
        guard let cacheData = imageCache.object(forKey: name as NSString) else { return nil }
        return Data(referencing: cacheData)
    }
    
    func setImageDataToCache(_ data: Data, for name: String) {
        imageCache.setObject(data as NSData, forKey: name as NSString)
    }
    
    func getmoreCats() async {
        page = cats.count / 10
        isPagOn = true
        var newCats: [CatModel] = []
        newCats = await network.fetchData(path: path, page: String(page), key: key)
        if !newCats.isEmpty {
            cats.append(contentsOf: newCats)
            self.updateCollection?(cats, page)
            isPagOn = false
        }
    }
    
    @MainActor func getImageData(id: String) async -> Data? {
        let cat: CatImage? = await network.fetchImageUrl(url: imageUrl + id)
        guard let url = cat?.url else  { return nil }
        do {
            return try await network.getImage(url: url)
        } catch {
            return nil
        }
    }
}
