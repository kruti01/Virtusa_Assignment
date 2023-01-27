//
//  TeamTableViewCell.swift
//  Virtusa_Assignment
//
//  Created by Kruti on 25/01/23.
//

import UIKit



class TeamTableViewCell: UITableViewCell {
    
    var logoImageURL: String? {
            didSet {
                let image = UIImage(named: "placeholder")
                if let url = logoImageURL {
                    UIImage.loadImageUsingCacheWithUrlString(url) { image in
                        if url == self.logoImageURL {
                            self.teamLogoImageView.image = image
                        }
                    }
                }
                else {
                    self.teamLogoImageView.image = image
                }
            }
        }
    
    // MARK: - Outlets
    lazy var teamLogoImageView: UIImageView = {
        let image = UIImage(named: "placeholder")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10.0
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 1.0
        return imageView
    }()
    
    lazy var teamSelectionImageView: UIImageView = {
        let image = UIImage(named: "checkbox")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var teamNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()

    // MARK: - Init method
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(teamLogoImageView)
        self.contentView.addSubview(teamNameLabel)
        self.contentView.addSubview(teamSelectionImageView)
        addConstraints()
     }

     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    // MARK: - Configure cell method
    func configure(teamDetails: TeamCellViewModel, selectedTeam: String?) {
        self.teamNameLabel.text = teamDetails.name
        self.logoImageURL = teamDetails.logo
        if let selectedTeam = selectedTeam {
            self.teamSelectionImageView.image = selectedTeam == teamDetails.name ? UIImage(named: "checkbox_selected") : UIImage(named: "checkbox")
        } else {
            self.teamSelectionImageView.image = UIImage(named: "checkbox")
        }
    }
    
    // MARK: - Add constrains method
    func addConstraints() {
        NSLayoutConstraint.activate([
            teamLogoImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor),
            teamLogoImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10),
            teamLogoImageView.widthAnchor.constraint(equalToConstant:70),
            teamLogoImageView.heightAnchor.constraint(equalToConstant:70),
            teamNameLabel.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor),
            teamNameLabel.leadingAnchor.constraint(equalTo:self.teamLogoImageView.trailingAnchor, constant:10),
            teamNameLabel.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10),
            teamNameLabel.heightAnchor.constraint(equalToConstant:40),
            teamSelectionImageView.widthAnchor.constraint(equalToConstant:26),
            teamSelectionImageView.heightAnchor.constraint(equalToConstant:26),
            teamSelectionImageView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-20),
            teamSelectionImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor)
        ])
    }
}

