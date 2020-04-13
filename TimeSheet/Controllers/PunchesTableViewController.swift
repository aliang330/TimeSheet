//
//  PunchesTableViewController.swift
//  TimeSheet
//
//  Created by Allen on 4/13/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import UIKit

class PunchesTableViewController: UITableViewController {
    
    var punches: [[Int]]?
    
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PunchCell.self, forCellReuseIdentifier: cellId)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return punches?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PunchCell
        cell.punches = punches?[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}


class PunchCell: UITableViewCell {
    
    var punches: [Int]? {
        didSet {
            if let punchInTime = punches?[0] {
                let timeInterval = TimeInterval(punchInTime)
                let date = Date(timeIntervalSince1970: timeInterval)
                let hour = Calendar.current.component(.hour, from: date)
                let minute = Calendar.current.component(.minute, from: date)
                var minuteString = ""
                if minute < 10 {
                    minuteString = "0\(minute)"
                } else {
                    minuteString = "\(minute)"
                }
                
                var punchString = ""
                if hour < 12 {
                    if hour == 0 {
                        punchString = "\(12):\(minuteString)AM"
                    } else {
                        punchString = "\(hour):\(minuteString)AM"
                    }
                } else {
                    if hour == 12 {
                        punchString = "\(hour):\(minuteString)PM"
                    } else {
                        punchString = "\(hour - 12):\(minuteString)PM"
                    }
                    
                }
                punchInTimeLabel.text = punchString
            }
            
            if let punchOutTime = punches?[1] {
                if punchOutTime == 0 {
                    punchOutTimeLabel.text = ""
                    punchOutTimeLabel.backgroundColor = .clear
                } else {
                    let timeInterval = TimeInterval(punchOutTime)
                    let date = Date(timeIntervalSince1970: timeInterval)
                    let hour = Calendar.current.component(.hour, from: date)
                    let minute = Calendar.current.component(.minute, from: date)
                    var minuteString = ""
                    if minute < 10 {
                        minuteString = "0\(minute)"
                    } else {
                        minuteString = "\(minute)"
                    }
                    
                    var punchString = ""
                    if hour < 12 {
                        if hour == 0 {
                            punchString = "\(12):\(minuteString)AM"
                        } else {
                            punchString = "\(hour):\(minuteString)AM"
                        }
                    } else {
                        if hour == 12 {
                            punchString = "\(hour):\(minuteString)PM"
                        } else {
                            punchString = "\(hour - 12):\(minuteString)PM"
                        }
                        
                    }
                    punchOutTimeLabel.text = punchString
                    punchOutTimeLabel.backgroundColor = .red
                }
                
            }
            
            if let punchTimes = punches {
                let punchInTime = punchTimes[0]
                let punchOutTime = punchTimes[1]
                
                if punchOutTime == 0 {
                    shiftTimeLabel.text = ""
                    shiftTimeLabel.backgroundColor = .clear
                } else {
                    let totalTime = punchOutTime - punchInTime
                    let (h, m ,_) = DataManager.shared.secondsToHoursMinutesSeconds(seconds: totalTime)
                    var shiftString = "\(h):"
                    if m < 10 {
                        shiftString += "0\(m)"
                    } else {
                        shiftString += "\(m)"
                    }
                    shiftTimeLabel.text = shiftString
                    shiftTimeLabel.backgroundColor = .lightGray
                }
                
            }
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    override func prepareForReuse() {
//        punchInTimeLabel.text = nil
//        punchInTimeLabel.backgroundColor = .clear
//        punchOutTimeLabel.text = nil
//        punchOutTimeLabel.backgroundColor = .clear
    }
    
    
    
    
    let punchInTimeLabel: UILabel = {
        let lb = UILabel(text: "9:00AM", font: .systemFont(ofSize: 16))
        lb.backgroundColor = .green
        lb.layer.cornerRadius = 20
        lb.clipsToBounds = true
        
        return lb
    }()
    
    let punchOutTimeLabel: UILabel = {
        let lb = UILabel(text: "5:00PM", font: .systemFont(ofSize: 16))
        lb.backgroundColor = .red
        lb.layer.cornerRadius = 20
        lb.clipsToBounds = true
        return lb
    }()
    
    let shiftTimeLabel: UILabel = {
        let lb = UILabel(text: "8:00", font: .systemFont(ofSize:16))
        lb.backgroundColor = .lightGray
        lb.layer.cornerRadius = 20
        lb.clipsToBounds = true
        return lb
    }()
    
    func setupView() {
        addSubview(punchInTimeLabel)
        punchInTimeLabel.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 100, height: 40))
        punchInTimeLabel.centerYInSuperview()
        
        addSubview(punchOutTimeLabel)
        punchOutTimeLabel.anchor(top: nil, leading: punchInTimeLabel.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 20, bottom: 0, right: 0), size: .init(width: 100, height: 40))
        punchOutTimeLabel.centerYInSuperview()
        
        addSubview(shiftTimeLabel)
        shiftTimeLabel.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 8), size: .init(width: 80, height: 40))
        shiftTimeLabel.centerYInSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
