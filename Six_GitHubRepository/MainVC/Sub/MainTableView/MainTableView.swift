//
//  MainTableView.swift
//  Six_GitHubRepository
//
//  Created by 이윤수 on 2022/11/16.
//

import UIKit

import RxSwift
import RxCocoa

class MainTableView : UITableView {
    let bag = DisposeBag()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainTableView{
    private func attribute(){
        self.dataSource = nil
        self.delegate = nil
        self.register(MainTableCell.self, forCellReuseIdentifier: "MainTableCell")
        self.rowHeight = 150
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = .white
        self.refreshControl?.tintColor = .gray
        self.refreshControl?.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
    }
    
    func bind(viewModel : MainTableViewModel){
        viewModel.cellData
            .drive(self.rx.items){tv, row, data in
                guard let cell = tv.dequeueReusableCell(withIdentifier: "MainTableCell", for: IndexPath(row: row, section: 0)) as? MainTableCell else{return UITableViewCell()}
                
                cell.nameLabel.text = data.name
                cell.starLabel.text = "\(data.stargazersCount)"
                cell.descriotionLabel.text = data.description
                
                return cell
            }
            .disposed(by: self.bag)
        
        
        self.refreshControl?.rx.controlEvent(.valueChanged)
            .map{
                self.refreshControl?.endRefreshing()
                return Void()
            }
            .bind(to: viewModel.cellRefresh)
            .disposed(by: self.bag)
        
        viewModel.cellRefresh
            .accept(Void())
    }
}
