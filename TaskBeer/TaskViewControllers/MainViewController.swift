//
//  ViewController.swift
//  TaskBeer
//
//  Created by Paul James on 05.11.2022.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    private let noTaskLabel: UILabel = {
        let label = UILabel()
        label.text = "Поставить задачу или выпить пива?"
        label.font = UIFont(name: "Avenir Next Demi Bold", size: 25)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "fullBeer")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let addTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.backgroundColor = #colorLiteral(red: 1, green: 0.3943974972, blue: 0.4663012028, alpha: 1)
        button.setTitle(" К задаче ", for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goToAddTaskVC), for: .touchUpInside)
        return button
    }()
    
    private let beerButton: UIButton = {
        var button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        button.setTitle("   По пивасу   ", for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(beerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //кнопка на основном вью для добавления задач
    private let addButtonVK: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 15
        button.backgroundColor = #colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1)
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonVKTapped), for: .touchUpInside)
        return button
    }()
    
    private var buttonStackView = UIStackView()
    let beerAlert = BeerAlert()
    
    //Realm
    var taskArray: Results<TaskModel>!
    
    //ориентация
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hasAnyTask()
        setCountRows()
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1) //меняет цвет кнопки возврата в навигейшен
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) //убирает надпись back в навигейшенконтроллере


        taskArray = realm.objects(TaskModel.self)
        
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.bounces = false
        
        setupView()
        
    }
    
    //подсчет сколько задач в блоке
    private func setCountRows() {
        let taskCount = taskArray.count
        navigationItem.title = "Пивные задачи (\(taskCount))"
    }
    
    private func setupView() {
        view.addSubview(noTaskLabel)
        view.addSubview(imageView)
        buttonStackView = UIStackView(arrangedSubviews: [addTaskButton, beerButton], axis: .horizontal, spacing: 20)
        view.addSubview(buttonStackView)
        view.addSubview(addButtonVK)
        
        setContraints()
        
    }
    
    private func hasAnyTask() {
        if taskArray.count == 0 {
            tableView.isHidden = true
            noTaskLabel.isHidden = false
            imageView.isHidden = false
            addTaskButton.isHidden = false
            beerButton.isHidden = false
            
            
        } else {
            tableView.isHidden = false
            noTaskLabel.isHidden = true
            imageView.isHidden = true
            addTaskButton.isHidden = true
            beerButton.isHidden = true
            tableView.reloadData()
        }
    }
    //кнопка К задачам
    @objc private func goToAddTaskVC() {
        
        if let addTackVC = storyboard?.instantiateViewController(withIdentifier: "addTackVC") as? AddTaskViewController {
            addTackVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(addTackVC, animated: true) //если использовать такой переход, то у нас не пропадет возможность вернуться назад у навигейшенБара. Если использовать present, то будет просто переход и возможность вернуться обратно не будет
        }
    }
    // кнопка по пивасу
    
    @objc private func beerButtonTapped() {
            self.beerAlert.alertCustom(viewController: self)
    }
    
    
    //кнопка добавления задачи на основном вью которая будет всегоа
    @objc func addButtonVKTapped() {
        if let addTackVC = storyboard?.instantiateViewController(withIdentifier: "addTackVC") as? AddTaskViewController {
            addTackVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(addTackVC, animated: true) //если использовать такой переход, то у нас не пропадет возможность вернуться назад у навигейшенБара. Если использовать present, то будет просто переход и возможность вернуться обратно не будет
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editCell" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let detailVC = segue.destination as? AddTaskViewController
            detailVC?.selectedIndex = taskArray[indexPath.row]
        }
    }
    //активируется когда на  addTaskVC мы нажимаем на кнопку сохранить. ВАЖНО чтобы в методе goToAddTaskVC() переход был фулСкрин, иначе не сработает reloadData
    @IBAction func unwindSegueActionTask(_ segue: UIStoryboardSegue) {
        guard let newEvent = segue.source as? AddTaskViewController else {return}
        newEvent.saveButtonTapped()
        tableView.reloadData()
    }
    
}

//MARK: - TableView delegate and dataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskTableViewCell
        
        cell.cellTaskDelegate = self
        cell.index = indexPath
        
        let model = taskArray[indexPath.row]
        cell.cellCongigure(model: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteRow = taskArray[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Красава!") { _, _, _ in
//            RealmManager.shared.deleteTaskModel(model: deleteRow)
            RealmManager.deleteTaskModel(model: deleteRow)
            self.hasAnyTask()
            self.setCountRows()
            tableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

//MARK: - Constraints for elements
extension MainViewController {
    
    func setContraints() {
        NSLayoutConstraint.activate([
            noTaskLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            noTaskLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            noTaskLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            noTaskLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: noTaskLabel.bottomAnchor, constant: 30),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            addTaskButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        NSLayoutConstraint.activate([
            beerButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            addButtonVK.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            addButtonVK.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -85),
            addButtonVK.widthAnchor.constraint(equalToConstant: 50),
            addButtonVK.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension MainViewController: PressReadyButtonProtocol {
func readyButtonTapped(indexPath: IndexPath) {
    let task = taskArray[indexPath.row]
//    RealmManager.shared.updateReadyTaskButtonModel(task: task, bool: !task.taskReady)
    RealmManager.updateReadyTaskButtonModel(task: task, bool: !task.taskReady)
    tableView.reloadData()
}
}
