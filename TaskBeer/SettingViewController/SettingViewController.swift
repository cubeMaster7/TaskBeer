//
//  SettingViewController.swift
//  TaskBeer
//
//  Created by Paul James on 06.11.2022.
//

import UIKit
import MessageUI
import StoreKit

enum Theme: Int {
    case device
    case light
    case dark
    
    
    func getUserInterfaceStyle() -> UIUserInterfaceStyle {
        
        //тут какой-то сбой и из-за этого приходится менять значение кейсов местами. Думаю связано с тем что у нас стоит кейс девайс, но когда убираю, все опять слетает. Потом починю на рефакторинге
        switch self {
        case .light:
            
            return .dark
        case .dark:
            
            return .light
        default:
            return .light
        }
    }
}

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var lightBeerImageView: UIImageView!
    @IBOutlet weak var darkBeerImageView: UIImageView!
    
//    var trigger: Bool?
//    let appID = "1287000522"
    
    let helpThemeArray = ["Написать разработчику", "Поставить оценку", "Поделиться приложением", "Скинуть разработчику на пиво", "Сменить язык"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupChangeColor()
        setupTableView()
        setupBeerImageView()
    }
    
    private func setupBeerImageView() {
        
        
        
        lightBeerImageView.image = UIImage(named: "lightBeer")
        lightBeerImageView.layer.cornerRadius = 20
        lightBeerImageView.clipsToBounds = true
        
        darkBeerImageView.image = UIImage(named: "barkBeer")
        darkBeerImageView.layer.cornerRadius = 20
        darkBeerImageView.clipsToBounds = true
    }
    
    // настройка смены со светлой на темную тему
    private func setupChangeColor() {
        view.backgroundColor = UIColor(named: "backgroundColor")
        segmentedControl.selectedSegmentIndex = MTUserDefaults.shared.theme.rawValue
    }
    
    //смена светлой и темной темы
    @IBAction func changeBeerType(_ sender: Any) {
        MTUserDefaults.shared.theme = Theme(rawValue: segmentedControl.selectedSegmentIndex) ?? .device
        view.window?.overrideUserInterfaceStyle = MTUserDefaults.shared.theme.getUserInterfaceStyle()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
    }
}

//MARK: - конфигурация TableView

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helpThemeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = helpThemeArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [0,0]:
            //написать разработчику
            let mailComposeViewController = configureMailController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                showMailError()
            }
        case [0,1]:
            // поставить оценку приложению
            
            if #available(iOS 14.0, *) {
                if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            } else if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            }
            
        case [0,2]:
            //поделиться приложением
            //            let url = URL(string: "https://apps.apple.com/us/app/id1535629801")!
            //            let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            //            present(vc, animated: true)
            
            if let name = URL(string: "https://itunes.apple.com/us/app/myapp/idxxxxxxxx?ls=1&mt=8"), !name.absoluteString.isEmpty {
                let objectsToShare = [name]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                self.present(activityVC, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Восстановить", message: "Вы попытались поделиться приложением, но что-то пошло не так", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            }
            
        case [0,3]:
            let alert = UIAlertController(title: "Копилка в разработке", message: "Спасибо, котятки, но пока что вы можете только написать разработчику", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Плак-плак", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        case [0,4]:
            let alert = UIAlertController(title: "Смена языка в разработке", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Хорошо", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        default:
            print("SMTH")
        }
    }
    
    
}

//MARK: - конфигурация для отправки письма из приложения
extension SettingViewController: MFMailComposeViewControllerDelegate {
    // тут описываем конфигурацию кому отправляем и что будет указано
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["luckypaulj@icloud.com"])
        mailComposerVC.setSubject("Вопрос по приложению BeerTask")
        mailComposerVC.setMessageBody("Привет. Как дела?", isHTML: false)
        
        return mailComposerVC
    }
    
    // вызовет алерт если у нас не будет отправляться письмо через почту
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Восстановить \"Почта\"?", message: "Для отправки сообщения требуется приложение \"Почта\", отсутствующее на вашем iPhone. Вы можете загрузить его из App Store. Если оно у вас есть, включите в настройках iCloud \"Почта iCloud\"", preferredStyle: .alert)
        let appStoreAction = UIAlertAction(title: "Перейти в App Store", style: .default) { _ in
          //переход в эпп стор
            if let url = URL(string: "itms-apps://itunes.apple.com/app/id1108187098") {
                UIApplication.shared.open(url)
            }
        }
        let dismiss = UIAlertAction(title: "Отменить", style: .default, handler: nil)
        sendMailErrorAlert.addAction(appStoreAction)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
