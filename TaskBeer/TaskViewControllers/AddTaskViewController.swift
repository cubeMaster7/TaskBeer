//
//  AddTaskViewController.swift
//  TaskBeer
//
//  Created by Paul James on 05.11.2022.
//

import UIKit
import RealmSwift

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var showDateSwitch: UISwitch!
    @IBOutlet weak var doneButton: UIButton!
    

    let localRealm = try! Realm()
    var selectedIndex: TaskModel? // это для редактирования задачи
    let taskModel = TaskModel()
    
    
    //настрйока уведомлений
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //обзерверы на клаву: нужны чтобы при появлении клавы у нас происходило событие. В моем случае - появление кнопки готово
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        textFieldSetup()
        setupView()
        
        setupEditScreen()
    }
    
    private func setupView() {
        doneButton.isHidden = true//кнопка готово когда появляется клаиватура
        showDateSwitch.isOn = false  //параметр свитча
        datePicker.isHidden = true
        showDateSwitch.addTarget(self, action: #selector(showDateSwitchChanged), for: .valueChanged)
        
    }
    
    
    private func textFieldSetup() {

        taskTextField.becomeFirstResponder()
        taskTextField.clearButtonMode = .whileEditing
        taskTextField.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 8, height: taskTextField.frame.height))
        taskTextField.leftViewMode = .always
        taskTextField.returnKeyType = .done
        taskTextField.delegate = self
        
        tapCloseKeyboard()
    }
    
    private func saveLogic() {
        if let text = taskTextField.text, !text.isEmpty {
            notificationLogic()
    
            taskModel.title = taskTextField.text!
            taskModel.taskDate = datePicker.date
            taskModel.priority = Int(segmentedControl.selectedSegmentIndex)
    
            if selectedIndex != nil {
                try! localRealm.write {
                    selectedIndex?.title = taskTextField.text!
                    selectedIndex?.taskDate = datePicker.date
                    selectedIndex?.priority = Int(segmentedControl.selectedSegmentIndex)
                }
            } else {
    
                RealmManager.saveTaskModel(model: taskModel)
            }
        } else {
            isTextFieldIsEmpty()
        }
    }
 
     func saveButtonTapped() {
   
           notificationCenter.getNotificationSettings { [self] (settings) in
               DispatchQueue.main.async {
                   if settings.authorizationStatus == .authorized {
                       saveLogic()
                   } else {
                       ifAuthorisationDenied()
                   }
               }
           }
       }
    

    //когда открываем окно для редактирования
    func setupEditScreen() {
        if selectedIndex != nil {
            taskTextField.text = selectedIndex?.title
            
            if selectedIndex?.taskDate != nil {
                showDateSwitch.isOn = true
                datePicker.isHidden = false
            }
            guard let date = selectedIndex?.taskDate else {return}
            datePicker.date = date
            segmentedControl.selectedSegmentIndex = selectedIndex!.priority

        }
    }
    
    private func isTextFieldIsEmpty() {
        let alert = UIAlertController(title: "Бро, ты че, пьян?", message: "Напиши задачу! Иначе не сохранится", preferredStyle: .alert)
        let okAlert = UIAlertAction(title: "Понял", style: .default, handler: nil)
        alert.addAction(okAlert)
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc func showDateSwitchChanged() {
        if showDateSwitch.isOn {
            //            dateLabel.text = "На когда надо?"
            datePicker.isHidden = false
        } else {
            //            dateLabel.text = "Бро, запланировать задачку?"
            datePicker.isHidden = true
        }
    }
    
    func notificationLogic() {
        let message = self.taskTextField.text!
        let date = self.datePicker.date
        scheduleDateNotification(date: date, message: message)
    }
    
    //MARK: работа кнопки готово
    @IBAction func gotovoButtonTapped(_ sender: Any) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillDisappear() {
        doneButton.isHidden = true
    }
    @objc func keyboardWillAppear() {
        doneButton.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
}

extension AddTaskViewController: UITextFieldDelegate {
    //когда нажимамем на done клава скрывается
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //закрытие клавы по тапу на экран
    private func tapCloseKeyboard() {
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapScreen)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

//MARK: доп.настройка уведомлений
extension AddTaskViewController {
    func scheduleDateNotification(date: Date, message: String) {
        
        notificationCenter.getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                let title = "Бро, напоминаю"
                let message = message
                let date = date
                
                if settings.authorizationStatus == .authorized {
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = message
                    
                    let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    self.notificationCenter.add(request) { (error) in
                        if error != nil {
                            print("error" + error.debugDescription)
                            return
                        }
                    }
                }
            }
        }
    }
    
    func ifAuthorisationDenied() {
        let ac = UIAlertController(title: "Включить уведомления?", message: "Чтобы пользоваться напоминаниями, включите уведомления в настройках", preferredStyle: .alert)
        let goToSettings = UIAlertAction(title: "Настройки", style: .default) { _ in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {return}
            
            if UIApplication.shared.canOpenURL(settingURL) {
                UIApplication.shared.open(settingURL, completionHandler: nil)
            }
        }
        
        ac.addAction(goToSettings)
        ac.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
}
