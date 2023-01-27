//
//  MatchDetailsHeaderView.swift
//  Virtusa_Assignment
//
//  Created by Kruti on 25/01/23.
//

import UIKit

class MatchDetailsHeaderView: UICollectionReusableView {
        
    let label = UILabel()

        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .clear
            label.textColor = UIColor(red: 95/255, green: 158/255, blue: 160/255, alpha: 1)
            label.textAlignment = .left
            label.font = UIFont.preferredFont(forTextStyle: .title3)
            addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
