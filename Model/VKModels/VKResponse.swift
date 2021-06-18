//
//  VKResponse.swift
//  VK_PlusHW2.2
//
//  Created by Eduard on 30.05.2021.
//

struct VKResponse<T:Codable>: Codable {
    let response: T
}

