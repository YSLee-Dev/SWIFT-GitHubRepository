//
//  MainTableModel.swift
//  Six_GitHubRepository
//
//  Created by 이윤수 on 2022/11/16.
//

import Foundation

import RxSwift

enum MainModelError : Error{
    case jsonError
    case networkError
    case urlError
}

struct MainModel{
    let session : URLSession
    
    init(){
        self.session = URLSession.shared
    }
    
    func loadCellData(gitName : String) -> Single<Result<[MainCellData], MainModelError>>{
        let urlString = "https://api.github.com/orgs/\(gitName)/repos"
        guard let url = URL(string: urlString) else {return .just(.failure(.urlError))}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return self.session.rx.data(request: request)
            .map {data -> [[String: Any]] in
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
                      let result = json as? [[String: Any]] else {
                    return []
                }
                return result
            }
            .filter { objects in
                return objects.count > 0
            }
            .map { objects in
                let list =  objects.compactMap { dic -> MainCellData? in
                    guard let id = dic["id"] as? Int,
                          let name = dic["name"] as? String,
                          let description = dic["description"] as? String,
                          let stargazersCount = dic["stargazers_count"] as? Int,
                          let language = dic["language"] as? String else {
                        return nil
                    }
                    
                    return MainCellData(id: id, name: name, description: description, stargazersCount: stargazersCount, language: language)
                }
                return .success(list)
            }
            .catch{ _ in
                    .just(.failure(.networkError))
            }
            .asSingle()
    }
}
