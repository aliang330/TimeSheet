//
//  extensions.swift
//  HRM
//
//  Created by Allen on 4/6/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(title: String, cornerRadius: CGFloat) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = cornerRadius
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

extension UILabel {
    convenience init(text: String, font: UIFont) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
        self.textAlignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}
