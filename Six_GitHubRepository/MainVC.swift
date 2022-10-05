//
//  MainVC.swift
//  Six_GitHubRepository
//
//  Created by 이윤수 on 2022/09/26.
//

import UIKit

import RxSwift
import RxCocoa

class MainVC: UITableViewController {
    let name = "Apple"
    let list = BehaviorSubject<[MainModel]>(value: [])
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "\(self.name) Repositories"
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = .white
        self.refreshControl?.tintColor = .gray
        self.refreshControl?.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        self.tableView.register(MainTableCell.self, forCellReuseIdentifier: "MainTableCell")
        self.tableView.rowHeight = 140
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fecthData(of: self.name)
    }
    
    @objc
    func refresh(){
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else {return}
            self.fecthData(of: self.name)
        }
    }
    
    func fecthData(of name : String){
        Observable.just(name)
            .map { organization -> URL in
                return URL(string: "https://api.github.com/orgs/\(organization)/repos")!
            }
            .map { url -> URLRequest in
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                return request
            }
            .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: request)
            }
            .filter { response, _ in
                return 200..<300 ~= response.statusCode
            }
            .map { _, data -> [[String: Any]] in
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
                return objects.compactMap { dic -> MainModel? in
                    guard let id = dic["id"] as? Int,
                          let name = dic["name"] as? String,
                          let description = dic["description"] as? String,
                          let stargazersCount = dic["stargazers_count"] as? Int,
                          let language = dic["language"] as? String else {
                        return nil
                    }
                    
                    return MainModel(id: id, name: name, description: description, stargazersCount: stargazersCount, language: language)
                }
            }
            .subscribe(onNext:{[weak self] newData in
                self?.list.onNext(newData)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.refreshControl?.endRefreshing()
                }
            }, onCompleted:{
                print("END")
            })
            .disposed(by: bag)
    }
}

extension MainVC{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do{
            return try self.list.value().count
        }catch{
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableCell", for: indexPath) as? MainTableCell else{return UITableViewCell()}
        
        var nowList : MainModel{
            do{
                return try self.list.value()[indexPath.row]
            }catch{
                return MainModel(id: 0, name: "0", description: "0", stargazersCount: 0, language: "0")
            }
        }
        
        cell.nameLabel.text = nowList.name
        cell.starLabel.text = "\(nowList.stargazersCount)"
        cell.descriotionLabel.text = nowList.description
        
        
        return cell
    }
}
