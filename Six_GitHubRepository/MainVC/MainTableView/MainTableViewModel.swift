//
//  MainTableViewModel.swift
//  Six_GitHubRepository
//
//  Created by 이윤수 on 2022/11/16.
//

import Foundation

import RxSwift
import RxCocoa

struct MainTableViewModel{
    // INPUT
    let loadCellData = PublishRelay<[MainCellData]?>()
    let cellRefresh = BehaviorRelay<Void>(value: Void())
 
    // OUTPUT
    let cellData : Driver<[MainCellData]>
    
    init(){
        self.cellData = self.loadCellData
            .map{
                $0!
            }
            .asDriver(onErrorDriveWith: .empty())
    }
}
