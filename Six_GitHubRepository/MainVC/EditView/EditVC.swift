//
//  EditVC.swift
//  Six_GitHubRepository
//
//  Created by 이윤수 on 2022/11/17.
//

import UIKit

import RxSwift
import RxCocoa
import Then
import SnapKit

class EditVC : UIViewController{
    deinit{
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    let mainView = UIView().then{
        $0.backgroundColor = .white
    }
    
    let textField = UITextField().then{
        $0.placeholder = "INSERT Repositories"
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 0.5
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    let okBtn = UIButton(type: .system).then{
        $0.setTitle("OK", for: .normal)
    }
    
    var keyHeight: CGFloat?
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        self.layout()
        self.attribute()
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        self.keyHeight = keyboardHeight
        
        self.view.frame.size.height -= keyboardHeight
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.size.height += self.keyHeight ?? 0
    }
}

extension EditVC{
    private func layout(){
        self.view.addSubview(self.mainView)
        self.mainView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(130)
        }
        
        self.mainView.addSubview(self.okBtn)
        self.okBtn.snp.makeConstraints{
            $0.trailing.top.equalToSuperview().inset(10)
            $0.size.equalTo(30)
        }
        
        self.mainView.addSubview(self.textField)
        self.textField.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(30)
            $0.top.equalTo(self.okBtn.snp.bottom).offset(10)
        }
    }
    
    private func attribute(){
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func bind(viewModel : EditViewModel){
        self.textField.rx.text
            .bind(to: viewModel.textField)
            .disposed(by: self.bag)
        
        self.okBtn.rx.tap
            .bind(to: viewModel.okBtnClick)
            .disposed(by: self.bag)
        
        self.okBtn.rx.tap
            .bind(to: self.rx.dismiss)
            .disposed(by: self.bag)
    }
}

extension Reactive where Base: EditVC{
    var dismiss : Binder<Void>{
        return Binder(base){ base, _ in
            base.dismiss(animated: true)
        }
    }
}
