//
//  DetailView.swift
//  News
//
//  Created by Данил on 05.02.2022.
//

import UIKit

class DetailView: UIView {

    let systemLabel : UILabel = {
        let label = UILabel()
        label.text = "gray label"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let customLabel : UILabel = {
        let label = UILabel()
        label.text = "gray label"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(named: "textColorSet")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(systemLabel)
        addSubview(customLabel)
        
        systemLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        systemLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        systemLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        customLabel.topAnchor.constraint(equalTo: systemLabel.bottomAnchor).isActive = true
        customLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        customLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        customLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
}

