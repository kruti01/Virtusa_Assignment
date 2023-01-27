//
//  MatchDetailsCollectionViewCell.swift
//  Virtusa_Assignment
//
//  Created by Kruti on 25/01/23.
//

import UIKit

protocol MatchDetailsCellDetegate: AnyObject {
    func highlightsButtonClick(selectedURLString: String)
}

class MatchDetailsCollectionViewCell: UICollectionViewCell {
    
    weak var delegate : MatchDetailsCellDetegate?
    var matchDetails : MatchCellViewModel?
    
    // MARK: - Outlets
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    lazy var winnerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(red: 95/255, green: 158/255, blue: 160/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    lazy var highlightsButtonBaseView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(highlightsButton)
        return view
    }()
    
    lazy var highlightsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Watch Highlights", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(highlightsButtonClick), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Highlights button click
    @objc func highlightsButtonClick(sender: UIButton) {
        self.delegate?.highlightsButtonClick(selectedURLString: matchDetails?.highlights ?? "")
    }
    
    // MARK: - Add constraints method
    func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            winnerLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            winnerLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            winnerLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            highlightsButtonBaseView.topAnchor.constraint(equalTo: winnerLabel.bottomAnchor, constant: 5),
            highlightsButtonBaseView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            highlightsButtonBaseView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            highlightsButtonBaseView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            highlightsButton.heightAnchor.constraint(equalToConstant: 30.0),
            highlightsButton.topAnchor.constraint(equalTo: highlightsButtonBaseView.topAnchor, constant: 0),
            highlightsButton.bottomAnchor.constraint(equalTo: highlightsButtonBaseView.bottomAnchor, constant: -5),
            highlightsButton.leadingAnchor.constraint(equalTo: self.highlightsButtonBaseView.leadingAnchor),
            highlightsButton.widthAnchor.constraint(equalTo: highlightsButtonBaseView.widthAnchor, multiplier: 0.45)
        ])
    }

    // MARK: - Preferred layout attributes fitting method
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        titleLabel.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.left
        layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return layoutAttributes
    }
    
    // MARK: - Init method
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.isUserInteractionEnabled = false
        addSubview(titleLabel)
        addSubview(winnerLabel)
        addSubview(highlightsButtonBaseView)
        highlightsButtonBaseView.addSubview(highlightsButton)
        addConstraints()
    }
    
    // we have to implement this initializer, but will only ever use this class programmatically
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.shadowDecorate()
    }
    
    // MARK: - Configure cell method
    func configure(matchDetails: MatchCellViewModel, delegate : MatchDetailsCellDetegate?) {
        self.matchDetails = matchDetails
        self.delegate = delegate
        
        titleLabel.text = matchDetails.description
        titleLabel.sizeToFit()
                    
        winnerLabel.isHidden = matchDetails.matchType == .upcoming
        highlightsButtonBaseView.isHidden = matchDetails.matchType == .upcoming
        
        if let winnerTeamName = matchDetails.winner {
            winnerLabel.text = "Winner Team : \(winnerTeamName)"
            winnerLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
            highlightsButtonBaseView.topAnchor.constraint(equalTo: winnerLabel.bottomAnchor, constant: 5).isActive = true
        } else {
            winnerLabel.text = ""
            winnerLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
            highlightsButtonBaseView.topAnchor.constraint(equalTo: winnerLabel.bottomAnchor, constant: 0).isActive = true
            winnerLabel.heightAnchor.constraint(equalToConstant: 0.0).isActive = true
            highlightsButtonBaseView.heightAnchor.constraint(equalToConstant: 0.0).isActive = true
            
            titleLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        }
        self.layoutSubviews()
        self.layoutIfNeeded()
    }
}

// MARK: - Apply shadow method
extension MatchDetailsCollectionViewCell {
    func shadowDecorate() {
        let radius: CGFloat = 10
        contentView.layer.cornerRadius = radius
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
    
        layer.shadowColor =  UIColor(red: 95/255, green: 158/255, blue: 160/255, alpha: 1).cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 1.0
        layer.shadowOpacity = 0.7
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        layer.cornerRadius = radius
    }
}

