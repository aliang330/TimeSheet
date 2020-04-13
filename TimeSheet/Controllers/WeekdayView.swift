//
//  WeekdayView.swift
//  TimeSheet
//
//  Created by Allen on 4/6/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import UIKit

class WeekdayView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    
    func setupView() {
        addSubview(weekdayStackView)
        weekdayStackView.fillSuperview()
        
        let daysArray = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
        for i in daysArray {
            let lb = UILabel()
            lb.text = i
            lb.textAlignment = .center
            weekdayStackView.addArrangedSubview(lb)
        }
    }
    
    let weekdayStackView: UIStackView = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
