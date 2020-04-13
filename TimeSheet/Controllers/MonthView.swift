//
//  MonthView.swift
//  TimeSheet
//
//  Created by Allen on 4/6/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import UIKit

protocol MonthViewDelegate: class {
    func didChangeMonth(monthIndex: Int, year: Int)
}

class MonthView: UIView {
    
    var monthsArr = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var currentMonthIndex = 0
    var currentYear = 0
    var delegate: MonthViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeCurrentMonthIndex()
        setupView()
    }
    
    func initializeCurrentMonthIndex() {
        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
    }
    
    @objc func monthChangeAction(sender: UIButton) {
        if sender == leftButton {
            currentMonthIndex -= 1
            if currentMonthIndex < 0 {
                currentMonthIndex = 11
                currentYear -= 1
            }
        } else {
            currentMonthIndex += 1
            if currentMonthIndex > 11 {
                currentMonthIndex = 0
                currentYear += 1
            }
        }
        
        monthLabel.text = "\(monthsArr[currentMonthIndex]) \(currentYear)"
        delegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)
    }
    
    func setupView() {
        backgroundColor = .clear
        addSubview(monthLabel)
        monthLabel.centerXInSuperview()
        monthLabel.constrainWidth(constant: 200)
        monthLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        addSubview(leftButton)
        leftButton.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, size: .init(width: 50, height: 0))
        
        addSubview(rightButton)
        rightButton.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, size: .init(width: 50, height: 0))
        
        monthLabel.text = "\(monthsArr[currentMonthIndex]) \(currentYear)"
    }
    
    let leftButton: UIButton = {
        let button = UIButton(title: "<", cornerRadius: 0)
        button.addTarget(self, action: #selector(monthChangeAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    let rightButton: UIButton = {
        let button = UIButton(title: ">", cornerRadius: 0)
        button.addTarget(self, action: #selector(monthChangeAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    let monthLabel: UILabel = {
        let lb = UILabel(text: "Month Year", font: .boldSystemFont(ofSize: 20))
        return lb
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

