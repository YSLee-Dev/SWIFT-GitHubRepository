//
//  MainTableCell.swift
//  Six_GitHubRepository
//
//  Created by 이윤수 on 2022/10/05.
//

import UIKit

import SnapKit
import Then

class MainTableCell : UITableViewCell{
    let nameLabel = UILabel().then{
        $0.font = .systemFont(ofSize: 15, weight: .bold)
    }
    
    let descriotionLabel = UILabel().then{
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.numberOfLines = 2
    }
    
    let starImageView = UIImageView().then{
        $0.image = UIImage(systemName: "star")
    }
    
    let starLabel = UILabel().then{
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .gray
    }
    
    let languageLabel = UILabel().then{
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .gray
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: nil)
        self.viewSet()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewSet(){
        [self.nameLabel, self.descriotionLabel, self.starImageView, self.starLabel, self.languageLabel]
            .forEach{
                self.contentView.addSubview($0)
            }
        
        self.nameLabel.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        self.descriotionLabel.snp.makeConstraints{
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(self.nameLabel)
        }
        
        self.starImageView.snp.makeConstraints{
            $0.top.equalTo(self.descriotionLabel.snp.bottom).offset(8)
            $0.leading.equalTo(self.descriotionLabel)
            $0.size.equalTo(20)
            $0.bottom.equalToSuperview().inset(18)
        }
        
        self.starLabel.snp.makeConstraints{
            $0.centerY.equalTo(self.starImageView)
            $0.leading.equalTo(self.starImageView.snp.trailing).offset(5)
        }
        
        self.languageLabel.snp.makeConstraints{
            $0.centerY.equalTo(self.starLabel)
            $0.leading.equalTo(self.starLabel.snp.trailing).offset(10)
        }
    }
}
