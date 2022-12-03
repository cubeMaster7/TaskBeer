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
        label.text = "Может пора по пивасику?"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "box")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let addTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.backgroundColor = .blue
        button.setTitle("   Не, дела   ", for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goToAddTaskVC), for: .touchUpInside)
        return button
    }()
    
    private let beerButton: UIButton = {
        var button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        button.setTitle("   По пивасу!   ", for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(beerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var buttonStackView = UIStackView()
    
    //Realm
    let localRealm = try! Realm()
    var taskArray: Results<TaskModel>!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
        hasAnyTask()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskArray = localRealm.objects(TaskModel.self)
        
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.bounces = false
        
        setupView()
        
    }
    
    private func setupView() {
        view.addSubview(noTaskLabel)
        view.addSubview(imageView)
        buttonStackView = UIStackView(arrangedSubviews: [addTaskButton, beerButton], axis: .horizontal, spacing: 20)
        view.addSubview(buttonStackView)
        
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
    
    @objc private func goToAddTaskVC() {
        
        if let addTackVC = storyboard?.instantiateViewController(withIdentifier: "addTackVC") as? AddTaskViewController {
            addTackVC.modalPresentationStyle = .formSheet
            present(addTackVC, animated: true, completion: nil)
        }
    }
    
    @objc private func beerButtonTapped() {
//            self.beerAlert.alertCustom(viewController: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editCell" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let detailVC = segue.destination as? AddTaskViewController
            detailVC?.selectedIndex = taskArray[indexPath.row]
        }
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
            RealmManager.shared.deleteTaskModel(model: deleteRow)
            self.hasAnyTask()
            tableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

//MARK: - Constraints for elements
extension MainViewController {
    
    func setContraints() {
        NSLayoutConstraint.activate([
            noTaskLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
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
    }
}

extension MainViewController: PressReadyButtonProtocol {
func readyButtonTapped(indexPath: IndexPath) {
    let task = taskArray[indexPath.row]
    RealmManager.shared.updateReadyTaskButtonModel(task: task, bool: !task.taskReady)
    tableView.reloadData()
}
}
