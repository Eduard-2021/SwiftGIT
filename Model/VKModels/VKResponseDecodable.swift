//
//  VKResponseDecodable.swift
//  VK_PlusHW2.4
//
//  Created by Eduard on 09.07.2021.
//

struct VKResponseDecodable<T:Decodable>: Decodable {
    let response: T
}
