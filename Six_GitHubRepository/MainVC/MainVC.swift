//
//  MainVC.swift
//  Six_GitHubRepository
//
//  Created by 이윤수 on 2022/09/26.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class MainVC : UIViewController{
    let mainTableView = MainTableView()
    let rightBtn = UIBarButtonItem(title: "EDIT", style: .plain, target: nil, action: nil)
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        self.layout()
        self.attribute()
    }
}

extension MainVC{
    private func layout(){
        self.view.addSubview(self.mainTableView)
        self.mainTableView.snp.makeConstraints{
            $0.bottom.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func attribute(){
        self.navigationItem.title = "Apple Repositories"
        self.view.backgroundColor = .white
    }
    
    func bind(viewModel : MainViewModel){
        self.mainTableView.bind(viewModel: viewModel.mainTableViewModel)
        
        self.navigationItem.setRightBarButton(self.rightBtn, animated: true)
    }
}
