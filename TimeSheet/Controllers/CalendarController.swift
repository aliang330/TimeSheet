//
//  CalendarController.swift
//  TimeSheet
//
//  Created by Allen on 4/6/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import UIKit

//protocol CalendarControllerDelegate {
//    func punchesForSelectedDate(punches: [[Int]])
//}

class CalendarController: UIViewController {
    
    var timeSheetData: TimeSheet?
    
    
//    var punchesTableViewDelegate: CalendarControllerDelegate?
    var delegate: CalendarViewController?
    var currentMonthIndex = 0
    var currentYear = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monthView.delegate = self
        calendarViewController.delegate = self
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        timeSheetData = DataManager.shared.loadJson()
        punchTableViewController.tableView.reloadData()
    }
    
    let calendarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(monthView)
        monthView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 50))
        
        view.addSubview(weekdaysView)
        weekdaysView.anchor(top: monthView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 30))
        
        view.addSubview(calendarViewController.view)
        calendarViewController.view.anchor(top: weekdaysView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 330))
        
        view.addSubview(lineSeparator)
        lineSeparator.anchor(top: calendarViewController.view.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: view.frame.width, height: 1))
        
        view.addSubview(punchTableViewController.view)
        punchTableViewController.view.anchor(top: lineSeparator.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
//        selectedLabel.backgroundColor = .red
//        view.addSubview(selectedLabel)
//        selectedLabel.anchor(top: calendarViewController.view.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 50))
        
    }
    
    let monthView: MonthView = {
        let mv = MonthView()
        mv.translatesAutoresizingMaskIntoConstraints = false
//        mv.backgroundColor = .red
        return mv
    }()
    
    let weekdaysView: WeekdayView = {
        let v = WeekdayView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let calendarViewController: CalendarViewController = {
        let cv = CalendarViewController()
        cv.collectionView.allowsMultipleSelection = false
        cv.collectionView.showsVerticalScrollIndicator = false
        cv.collectionView.showsHorizontalScrollIndicator = false
        cv.collectionView.backgroundColor = .clear
        cv.collectionView.isScrollEnabled = false
        return cv
    }()
    
    let lineSeparator: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .lightGray
        return v
    }()
    
    let punchTableViewController: PunchesTableViewController = {
        let tv = PunchesTableViewController()
        tv.tableView.bounces = false
        return tv
    }()
    
    let selectedLabel: UILabel = {
        let lb = UILabel(text: "some text", font: .systemFont(ofSize: 16))
        
        return lb
    }()
}

extension CalendarController: CalendarViewControllerDelegate {
    func dateSelected(month: Int, day: Int, year: Int) {
        let dateComponent = DateComponents(calendar: Calendar.current, year: year, month: month, day: day)
        let selectedDateSince1970 = Int(Calendar.current.date(from: dateComponent)!.timeIntervalSince1970)
        var punchArray = [[Int]]()
        for day in timeSheetData!.days! {
            if day.dateSince1970 == selectedDateSince1970 {
                guard let punchInArray = day.PunchIn else { return }
                var count = 0
                while count < punchInArray.count {
                    if count == punchInArray.count - 1 && punchInArray.count % 2 != 0{
                        punchArray.append([punchInArray[count], 0])
                    } else {
                        punchArray.append([punchInArray[count], punchInArray[count + 1]])
                    }
                    count += 2
                }
                punchTableViewController.punches = punchArray
                punchTableViewController.tableView.reloadData()
                print(punchArray)
                return
            }
        }
        print("day doesnt exist")
        punchTableViewController.punches = [[Int]]()
        punchTableViewController.tableView.reloadData()
    }
}

extension CalendarController: MonthViewDelegate {
    func didChangeMonth(monthIndex: Int, year: Int) {
        calendarViewController.currentMonthIndex = monthIndex + 1
        calendarViewController.currentYear = year
        calendarViewController.firstWeekDayOfMonth = calendarViewController.getFirstWeekDay()
        calendarViewController.collectionView.reloadData()
    }
}
