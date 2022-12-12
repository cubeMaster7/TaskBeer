//
//  TaskTableViewCell.swift
//  TaskBeer
//
//  Created by Paul James on 05.11.2022.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    
    let readyButton: UIButton = {
       let button = UIButton()
        button.setBackgroundImage(UIImage(named: "emptyBeer"), for: .normal) // устанавливаем именно stBackgroundImage тк надо будет эту картинку растягивать
        button.tintColor = .black //наша черная кнопка
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //попытка настроить кнопку
    weak var cellTaskDelegate: PressReadyButtonProtocol?
    var index: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setConstraints()
        readyButton.addTarget(self, action: #selector(secondReadyButtonTapped), for: .touchUpInside)
    }
    
    @objc func secondReadyButtonTapped() {
        guard let index = index else {return}
        cellTaskDelegate?.readyButtonTapped(indexPath: index)
    }

    func cellCongigure(model: TaskModel) {
        
        //с приоритетом задача или без
        switch model.priority {
        case 1:
            titleLabel.text = "❗️ \(model.title)"
        default:
            titleLabel.text = model.title
        }
        
        //настройка даты дейтпикера для ячейки
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMM y HH:mm"
        guard let date = model.taskDate else {return}
        dateAndTimeLabel.text = dateFormatter.string(from: date)
        
        
        //настройка кнопки readyButton
        if model.taskReady {
            readyButton.setBackgroundImage(UIImage(named: "fullBeer"), for: .normal)
            titleLabel.alpha = 0.3
            dateAndTimeLabel.alpha = 0.3
        } else {
            readyButton.setBackgroundImage(UIImage(named: "emptyBeer"), for: .normal)
            titleLabel.alpha = 1
            dateAndTimeLabel.alpha = 1
        }
    }
    
    func setConstraints() {
        
        //привязка кнопки
        self.contentView.addSubview(readyButton)
        NSLayoutConstraint.activate([
            readyButton.centerYAnchor.constraint(equalTo: self.centerYAnchor), //будет находится по центру вертикали
            readyButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            readyButton.heightAnchor.constraint(equalToConstant: 30),
            readyButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }

}
