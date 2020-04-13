//
//  CalendarViewController.swift
//  TimeSheet
//
//  Created by Allen on 4/6/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import UIKit

protocol CalendarViewControllerDelegate {
    func dateSelected(month: Int, day: Int, year: Int)
}

class CalendarViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var delegate: CalendarViewControllerDelegate?
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeCurrentDateComponents()
        collectionView.register(dateCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        //return day == 7 ? 1 : day
        return day
    }
    
    func initializeCurrentDateComponents() {
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth = getFirstWeekDay()
        
        //for leap years, make february month of 29 days
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex-1] = 29
        }
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfDaysInMonth[currentMonthIndex - 1] + firstWeekDayOfMonth - 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! dateCell
        if indexPath.item < firstWeekDayOfMonth - 1 {
            cell.isHidden = true
        } else {
            cell.isHidden = false
        }
        cell.dateLabel.text = "\(indexPath.item - firstWeekDayOfMonth + 2)"
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .red
        let selectedDay = (indexPath.item - firstWeekDayOfMonth + 2)
        delegate?.dateSelected(month: currentMonthIndex, day: selectedDay, year: currentYear)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .clear
    }
    
    let minimumLineSpacing: CGFloat = 8
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - (6 * minimumLineSpacing)
        return .init(width: width / 7 , height: width / 7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    func didChangeMonth(monthIndex: Int, year: Int) {
        print("calendarcalled")
        currentMonthIndex = monthIndex - 1
        currentYear = year
        
        if monthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 29
            } else {
                numOfDaysInMonth[monthIndex] = 28
            }
        }
        
        firstWeekDayOfMonth = getFirstWeekDay()
        collectionView.reloadData()
    }
    
}


class dateCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
        setupView()
    }
    override func prepareForReuse() {
        backgroundColor = .clear
    }
    
    func setupView() {
        addSubview(dateLabel)
        dateLabel.fillSuperview()
    }
    
    let dateLabel: UILabel = {
        let lb = UILabel(text: "00", font: .systemFont(ofSize: 16))
        lb.textColor = .black
        return lb
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
