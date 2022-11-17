//
//  EditViewModel.swift
//  Six_GitHubRepository
//
//  Created by 이윤수 on 2022/11/17.
//

import Foundation

import RxSwift
import RxCocoa

struct EditViewModel{
    let textField = PublishRelay<String?>()
    let okBtnClick = PublishRelay<Void>()
}
