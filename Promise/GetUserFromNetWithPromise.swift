//
//  GetUserFromNetWithPromise.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 18.07.2021.
//

import UIKit
import PromiseKit

func getUserFromNetWithPromise() -> Promise<Data> {
    let session = URLSession.shared
    var urlComponents = MainNetworkService().makeComponents(for: .getFriends)
    urlComponents.queryItems?.append(contentsOf: [
        URLQueryItem(name: "fields", value: "photo_200"),
    ])

    return Promise<Data> {seal in
        guard let url = urlComponents.url else {return seal.reject(PromiseError.notCorrectUrl)}
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                seal.fulfill(data)
                }
            else {
                seal.reject(PromiseError.errorRequist)
            }
        }
        .resume()
    }
}
