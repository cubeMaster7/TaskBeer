//
//  CalendarViewController.swift
//  TaskBeer
//
//  Created by Paul James on 07.11.2022.
//

import UIKit
import RealmSwift
import FSCalendar

class CalendarViewController: UIViewController {

    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    var calendarArray: Results<CalendarModel>!
    var calendarModel = CalendarModel()
    
    private let noEventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "fullBeer")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let noEventLabel: UILabel = {
       let label = UILabel()
        label.text = "Нажмите на дату чтобы узнать, пили ли вы в этот день"
        label.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        hasAnyEvent()
        tableView.reloadData()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor(named: "calendarDatesColor")
        
        setupView()
        calendarSetup()
        eventOnDay(date: Date())
        setContraints()
    }

    
    private func setupView() {
        view.addSubview(noEventImageView)
        view.addSubview(noEventLabel)
        
    }
    
    private func calendarSetup() {
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.locale = Locale(identifier: "RU_ru")
        calendarView.appearance.caseOptions = .headerUsesCapitalized //месяц будет с большой буквы
        
        calendarView.appearance.headerTitleFont = UIFont(name: "Avenir Next Bold", size: 20)
        calendarView.appearance.weekdayTextColor = UIColor(named: "calendarTitlesColor") // дни недели
        calendarView.appearance.headerTitleColor = UIColor(named: "calendarTitlesColor") // название месяцев
        calendarView.appearance.titleDefaultColor = UIColor(named: "calendarDatesColor") //даты
        calendarView.appearance.borderDefaultColor = UIColor(named: "calendarBorderColor")
        calendarView.appearance.selectionColor = #colorLiteral(red: 1, green: 0.6497964263, blue: 0, alpha: 1)
        calendarView.appearance.borderSelectionColor = .red

        
//        calendarView.calendarHeaderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
//        calendarView.calendarWeekdayView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
//        calendarView.select(Date())//делает выделенным текущий день. Но не активирует его
        
    }
    
    private func hasAnyEvent() {
        if calendarArray.count == 0 {
            tableView.isHidden = true
            noEventImageView.isHidden = false
            noEventLabel.isHidden = false
        } else {
            tableView.isHidden = false
            noEventImageView.isHidden = true
            noEventLabel.isHidden = true
        }
    }
    
    
    func eventOnDay(date: Date) {
        let dateStart = date
        let dateEnd: Date = {
            let components = DateComponents(day: 1, second: -1)
            return Calendar.current.date(byAdding: components, to: dateStart)!
        }()
        
        let predicateUnrepeat = NSPredicate(format: "calendarDate BETWEEN %@", [dateStart,dateEnd])
        calendarArray = realm.objects(CalendarModel.self).filter(predicateUnrepeat)
        
        hasAnyEvent()
        tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCell" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let detailVC = segue.destination as? CardTableViewController
            detailVC?.selectedIndex = calendarArray[indexPath.row]
            //тестовое
            detailVC?.editIndex = calendarArray[indexPath.row]
        }
    }
    
    @IBAction func unwindSaveAction(_ segue: UIStoryboardSegue) {
        guard let newEvent = segue.source as? SelfViewController else {return} //до этого было вот это SelfViewController
        newEvent.saveEvent()
        tableView.reloadData()
    }
    
    private func setContraints() {
        NSLayoutConstraint.activate([
            noEventLabel.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 0),
            noEventLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            noEventLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            noEventLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noEventLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            noEventImageView.topAnchor.constraint(equalTo: noEventLabel.bottomAnchor, constant: 10),
            noEventImageView.widthAnchor.constraint(equalToConstant: 55),
            noEventImageView.heightAnchor.constraint(equalToConstant: 60),
            noEventImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
}

//MARK: - TableView delegate and dataSource
extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventTableViewCell
        let model = calendarArray[indexPath.row]
        cell.cellConfigure(model: model)
        cell.eventImageView.layer.cornerRadius = 30
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editingRow = calendarArray[indexPath.row]
        let deleceAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
            RealmManager.deleteModel(model: editingRow)
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [deleceAction])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}

//MARK: FS Calendar delegate and dataSource

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        eventOnDay(date: date)
    }

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
       //здесь должна быть логика что если у нас есть событие на дату, то поставить точку
    
        return 0
    }
    
  
}
