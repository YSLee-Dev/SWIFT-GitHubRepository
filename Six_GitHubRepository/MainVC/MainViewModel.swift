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
    
    // INPUT
    let editBtnClick = PublishRelay<Void>()
    
    // OUTPUT
    let gitTitle : Driver<String>
    let editViewModel : Driver<EditViewModel>
    
    let bag = DisposeBag()
    
    init(){
        let editViewModel = EditViewModel()
        let requestText = editViewModel.okBtnClick
            .withLatestFrom(editViewModel.textField)
            .startWith("Apple")
        
        self.gitTitle = requestText
            .map{$0!}
            .asDriver(onErrorDriveWith: .empty())
        
        
        self.editViewModel = self.editBtnClick
            .map{
                editViewModel
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let loadGit = Observable
            .combineLatest(requestText, self.mainTableViewModel.cellRefresh){text, _ in
                text
            }
        
        loadGit
            .flatMap{
                self.mainModel.loadCellData(gitName: $0!)
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
