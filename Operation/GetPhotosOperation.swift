//
//  getAllPhotos.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 16.07.2021.
//

import UIKit
import Alamofire

class GetPhotosOperation: AsyncOperation {
    
    let userId: String
    
    // возвращаемые данные
    var data: Data?
    
    init(userId:String){
        self.userId = userId
    }
    
    
    func getAllPhotos(completion: @escaping (Data?) -> () ) {
        
        let host = "https://api.vk.com"
        let path = "/method/\(PathOfMethodsVK.getAllPhotos.rawValue)"
        let parameters: Parameters = [
            "access_token": DataAboutSession.data.token,
            "v": "5.130",
            "extended": "1",
            "owner_id": "\(userId)"
        ]
        
        AF.request(host + path,
                   method: .get,
                   parameters: parameters).responseData(queue: DispatchQueue.global()) { (response) in
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure:
                completion(nil)
            }
        }
    }

    override func main() {
        getAllPhotos {[weak self] (data) in
            self?.data = data
            self?.state = .finished
        }
    }
}
