//
//  ViewController.swift
//  TimeSheet
//
//  Created by Allen on 4/1/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import UIKit


struct TimeSheet: Codable{
    var days: [Day]?
    
//    init(days: [Day]){
//        self.days = days
//    }
}

struct Day : Codable {
    var dateSince1970: Int
    var punchIn: [Int]
    
    init(dateSince1970: Int, punchIn: [Int]){
        self.dateSince1970 = dateSince1970
        self.punchIn = punchIn
    }
}

class ViewController: UIViewController {

    
    var isPunchedIn = false
    var timePunchedIn = 0
    var totalTimeWorked = 0
    var shiftTimer: Timer?
//    var shiftTime = 0
    
    var loadedData: NSMutableDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loadedData = DataManager.shared.checkIfDataFileExists()
        loadData(from: loadedData)
        setupView()
        updateUI()
    }
    
    
    
    let punchInButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .green
        button.setTitle("Punch In", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.addTarget(self, action: #selector(handlePunch), for: .touchUpInside)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        return button
    }()
    
    let punchOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Punch Out", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.addTarget(self, action: #selector(handlePunch), for: .touchUpInside)
        button.layer.cornerRadius = 12
        button.backgroundColor = .red
        button.layer.borderWidth = 1
        return button
    }()
    
    let timeWorkedLabel = UILabel(text: "00:00:00", font: .boldSystemFont(ofSize: 60))
    
    
    let workLabel = UILabel(text: "Shift Timer", font: .boldSystemFont(ofSize: 40))
    
    
    
    @objc func handlePunch(sender: UIButton) {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        guard let currentDate = Calendar.current.date(from: dateComponents) else { return }
        let currentDateSince1970 = Int(currentDate.timeIntervalSince1970)
        
        
        
        //grab timesheet.json and check if any errors loading data
        var timeSheet = DataManager.shared.loadJson()
        if timeSheet.days == nil {
            timeWorkedLabel.text = "error loading data, try again"
            return
        } else {
            //timesheet is good, preceded to check if today exist
            var todayExist = false
            guard let days = timeSheet.days else { timeWorkedLabel.text = "Error upwrapping timesheet"; return}
            for (index, day) in days.enumerated() {
                if day.dateSince1970 == currentDateSince1970 {
                    //today exist, add punch
                    todayExist = true
                    timeSheet.days?[index].punchIn.append(Int(Date().timeIntervalSince1970))
                    DataManager.shared.saveJson(timeSheet: timeSheet)
                    break
                }
            }
            if todayExist == false {
                //today doesnt exist, add new day and punch
                let day = Day(dateSince1970: currentDateSince1970, punchIn: [Int(Date().timeIntervalSince1970)])
                timeSheet.days?.append(day)
                DataManager.shared.saveJson(timeSheet: timeSheet)
            }
        }
        
        if isPunchedIn == false {
            isPunchedIn = true
            punchInButton.isHidden = true
            punchOutButton.isHidden = false
            timePunchedIn = Int(Date().timeIntervalSince1970)
            DataManager.shared.saveData(data: createData())
            shiftTimerLabel.text = "00:00:00"
            shiftTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
                let timeInSeconds = Int(Date().timeIntervalSince1970) - self.timePunchedIn
                self.shiftTimerLabel.text = self.convertSecondsToTimeString(seconds: timeInSeconds)
            })
        } else {
            shiftTimer?.invalidate()
            isPunchedIn = false
            punchOutButton.isHidden = true
            punchInButton.isHidden = false
            totalTimeWorked += Int(NSDate().timeIntervalSince1970) - timePunchedIn
            updateUI()
            DataManager.shared.saveData(data: createData())
        }
    }
    
    func createData() -> NSMutableDictionary {
        let data: NSMutableDictionary = ["isPunchedIn" : isPunchedIn == true ? "true" : "false",
                                         "timePunchedIn" : timePunchedIn,
                                         "totalTimeWorked" : totalTimeWorked
        ]
        return data
    }
    
    func loadData(from data: NSMutableDictionary) {
        isPunchedIn = data["isPunchedIn"] as! String == "true" ? true : false
        timePunchedIn = data["timePunchedIn"] as! Int
        totalTimeWorked = data["totalTimeWorked"] as! Int
    }
    
    func updateUI() {
        
        
        timeWorkedLabel.text = convertSecondsToTimeString(seconds: totalTimeWorked)
    }
    
    func convertSecondsToTimeString(seconds: Int) -> String {
        let (h, m , s) = DataManager.shared.secondsToHoursMinutesSeconds(seconds: seconds)
        
        var timeString = ""
        
        if h < 10 {
            timeString += "0\(h):"
        } else {
            timeString += "\(h):"
        }
        if m < 10 {
            timeString += "0\(m):"
        } else {
            timeString += "\(m):"
        }
        if s < 10 {
            timeString += "0\(s)"
        } else{
            timeString += "\(s)"
        }
        
        return timeString
    }
    
    func setupView() {
        
        if isPunchedIn == false {
            punchInButton.isHidden = false
            punchOutButton.isHidden = true
        } else {
            punchInButton.isHidden = true
            punchOutButton.isHidden = false
        }
            
        updateUI()
        let punchButtonStackView = UIStackView(arrangedSubviews: [punchInButton, punchOutButton])
        
        punchButtonStackView.spacing = 100
        punchButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(punchButtonStackView)
        
        punchButtonStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        punchButtonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        punchButtonStackView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        punchButtonStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(shiftTimerLabel)
        
        shiftTimerLabel.topAnchor.constraint(equalTo: punchButtonStackView.bottomAnchor, constant: 300).isActive = true
        shiftTimerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        shiftTimerLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 60).isActive = true
        shiftTimerLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.addSubview(workLabel)
        
        workLabel.bottomAnchor.constraint(equalTo: shiftTimerLabel.topAnchor, constant: -30).isActive = true
        workLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    let shiftTimerLabel: UILabel = {
        let lb = UILabel(text: "00:00:00", font: .boldSystemFont(ofSize: 60))
        return lb
    }()

}


extension FileManager {
    static var documentDirectoryURL: URL {
        return `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
