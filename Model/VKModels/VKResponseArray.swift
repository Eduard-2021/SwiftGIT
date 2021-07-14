//
//  VKResponseArray.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 13.07.2021.
//

struct VKResponseArray<T:Codable>: Codable {
    let response: [T]
}
