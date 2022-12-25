//
//  CardTableViewController.swift
//  TaskBeer
//
//  Created by Paul James on 04.12.2022.
//

import UIKit
import RealmSwift

class CardTableViewController: UITableViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var whatDrinkLabel: UILabel!
    @IBOutlet weak var whereDrinkLabel: UILabel!
    @IBOutlet weak var howMuchDrinkLabel: UILabel!
    
    private let titlelabel:UILabel = {
        let label = UILabel()
        label.text = "Карточка события"
        label.font = UIFont(name: "Avenir Next Bold", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var selectedIndex: CalendarModel?
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setupElementsView()
    }
 
    private func setupElementsView() {
        view.addSubview(titlelabel)
        setContraints()
        
        whatDrinkLabel.text = selectedIndex?.whatDrink
        whereDrinkLabel.text = selectedIndex?.whereDrink
        howMuchDrinkLabel.text = selectedIndex?.amountOfAlcohol

        guard let data = selectedIndex?.imageData, let image = UIImage(data: data) else {return}
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
    }
    
    private func setContraints() {
        NSLayoutConstraint.activate([
            titlelabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titlelabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @IBAction func imageButtonPressed(_ sender: Any) {
        
        let vc = ImageViewController()
        vc.imageCard = selectedIndex
        present(vc, animated: true, completion: nil)
    }
    
    func pushView(viewController: UIViewController){
        let transistion = CATransition()
        transistion.duration = 0.3
        transistion.type = .fade
        self.view.window?.layer.add(transistion, forKey: kCATransition)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @IBAction func editButton(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "editID") as? SelfViewController {
            vc.currentEvent = selectedIndex
            present(vc, animated: true, completion: nil)
        }
    }

    
    @IBAction func shareButtonTapped(_ sender: Any) {
        if let name = URL(string: "https://itunes.apple.com/us/app/myapp/idxxxxxxxx?ls=1&mt=8"), !name.absoluteString.isEmpty {
          let objectsToShare = [name]
          let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
          self.present(activityVC, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "У нас проблема", message: "Вы попытались поделиться приложением, но что-то пошло не так", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true)
    }
}


