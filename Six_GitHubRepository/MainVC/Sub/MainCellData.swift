//
//  MainModel.swift
//  Six_GitHubRepository
//
//  Created by 이윤수 on 2022/10/05.
//

import Foundation

struct MainCellData : Decodable{
    let id : Int
    let name : String
    let description : String
    let stargazersCount : Int
    let language : String
    
    enum Codingkeys : String, CodingKey{
        case id, name, description , language
        case stargazersCount = "stargazers_count"
    }
}
