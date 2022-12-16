//
//  SetLanguageViewController.swift
//  TaskBeer
//
//  Created by Paul James on 15.12.2022.
//

import Foundation
import UIKit


class SetLanguageViewController: UIViewController {
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Avenir Next Bold", size: 20)
        label.text = "Выберите язык"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
   private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    let langArray = ["Русский", "Английский"]
    //id for cell
    let idLangCell = "idLangCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LangCell.self, forCellReuseIdentifier: idLangCell)
        
        view.addSubview(titleLabel)
        view?.addSubview(tableView)
        
        setContraints()
    }
    
    
    func setContraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}

extension SetLanguageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return langArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idLangCell, for: indexPath) as! LangCell
        
        cell.langName.text = langArray[indexPath.row]
        cell.accessoryType = LangCell.AccessoryType.checkmark
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [0,0]:
            print("выбран русский язык")
            if LocalizationSystem.sharedInstance.genLanguage() == "en" {
                LocalizationSystem.sharedInstance.setLanguage(languageCode: "ru")
            } else {
                LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
            }
            
            navigationController?.popViewController(animated: true)
        case [0,1]:
            print("выбран английский язык")
            if LocalizationSystem.sharedInstance.genLanguage() == "ru" {
                LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
            } else {
                LocalizationSystem.sharedInstance.setLanguage(languageCode: "ru")
            }
            navigationController?.popViewController(animated: true)
        default:
            if LocalizationSystem.sharedInstance.genLanguage() == "en" {
                LocalizationSystem.sharedInstance.setLanguage(languageCode: "ru")
            } else {
                LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
            }
        }
    }
}

//MARK: - Localization

extension SetLanguageViewController {
    func setLang() {
        
    }
}
