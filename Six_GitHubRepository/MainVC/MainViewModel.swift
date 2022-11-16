//
//  MainViewModel.swift
//  Six_GitHubRepository
//
//  Created by 이윤수 on 2022/11/16.
//

import Foundation

import RxSwift
import RxCocoa

class MainViewModel{
    // MODEL
    let mainModel = MainModel()
    let mainTableViewModel = MainTableViewModel()
    
    let bag = DisposeBag()
    
    init(){
      self.mainTableViewModel.cellRefresh
            .flatMap{
                self.mainModel.loadCellData(gitName: "Apple")
            }
            .map{ data -> [MainCellData]? in
                guard case .success(let value) = data else {return nil}
                return value
            }
            .filter{$0 != nil}
            .bind(to: self.mainTableViewModel.loadCellData)
            .disposed(by: self.bag)
    }
}
