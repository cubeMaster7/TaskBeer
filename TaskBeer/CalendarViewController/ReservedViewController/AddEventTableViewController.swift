//
//  AddEventTableViewController.swift
//  TaskBeer
//
//  Created by Paul James on 07.12.2022.
//

import UIKit

class AddEventTableViewController: UITableViewController {

    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet weak var whatDrinkTF: UITextField!
    @IBOutlet weak var amountOfAlcoholTF: UITextField!
    @IBOutlet weak var whereDrinkTF: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var datePicker: UIDatePicker!

    var imageIsChanged = false
    var currentEvent: CalendarModel?
    let calendarModel = CalendarModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
        
        whatDrinkTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        textFieldSetup()
        //editingChanged означает что работает селектор при редактировании
        setupEdtiScreen()

    }
    
    private func textFieldSetup(){
//        whatDrinkTF.becomeFirstResponder()
        whatDrinkTF.clearButtonMode = .whileEditing
        whatDrinkTF.returnKeyType = .done
        amountOfAlcoholTF.returnKeyType = .done
        whereDrinkTF.returnKeyType = .done
        whatDrinkTF.delegate = self
        amountOfAlcoholTF.delegate = self
        whereDrinkTF.delegate = self
        
        tapCloseKeyboard()
    }
    
    
    
    @IBAction func chooseImage(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }


        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true, completion: nil)

    }
    
    func saveEvent() {
    
        var image: UIImage?
        
        if imageIsChanged { //если изображение изменено, то ставим измененное иначе по дефолту
            image = beerImage.image
        } else {
            image = #imageLiteral(resourceName: "noImage")
        }
        
        let imageData = image?.pngData()
        
//        let newEvent = CalendarModel(whatDrink: whatDrinkTF.text!, amountOfAlcohol: amountOfAlcoholTF.text, whereDrink: whereDrinkTF.text, calendarDate: datePicker.date, imageData: imageData)
        calendarModel.whatDrink = whatDrinkTF.text!
        if var text = amountOfAlcoholTF.text, text.isEmpty {
            text = "Море алкоголя"
            calendarModel.amountOfAlcohol = text
        } else {
            calendarModel.amountOfAlcohol = amountOfAlcoholTF.text
        }
        
        if var text = whereDrinkTF.text, text.isEmpty {
            text = "В лучшем месте этого города"
            calendarModel.whereDrink = text
        } else {
            calendarModel.whereDrink = whereDrinkTF.text
        }
        
        calendarModel.calendarDate = datePicker.date
        calendarModel.imageData = imageData
        
        //вот это для редактирования
        if currentEvent != nil {
            try! realm.write {
                currentEvent?.whatDrink = calendarModel.whatDrink
                currentEvent?.amountOfAlcohol = calendarModel.amountOfAlcohol
                currentEvent?.whereDrink = calendarModel.whereDrink
                currentEvent?.calendarDate = calendarModel.calendarDate
                currentEvent?.imageData = calendarModel.imageData
            }
        } else {
            RealmManager.saveModel(model: calendarModel) // тут было сохранение newEvent если использовали модель
        }
    }
    
    private func setupEdtiScreen() {
        if currentEvent != nil { //если не равно nil, значит мы в окне редактирования
            //здесь мы преобразовываем дата картинку в просто картинку
            
            setupNavigationBar()
            imageIsChanged = true
            
            guard let data = currentEvent?.imageData, let image = UIImage(data: data) else {return}
            beerImage.image = image
            beerImage.contentMode = .scaleAspectFill
            whatDrinkTF.text = currentEvent?.whatDrink
            amountOfAlcoholTF.text = currentEvent?.amountOfAlcohol
            whereDrinkTF.text = currentEvent?.whereDrink
            
            guard let dateEvent = currentEvent?.date else {return}
            datePicker.date = dateEvent
        }
    }
    
    private func setupNavigationBar() {
        
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
//        //уберем кнопку cancel
//        navigationItem.leftBarButtonItem = nil
//        title = currentEvent?.whereDrink
        saveButton.isEnabled = true
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - TextField delegate
extension AddEventTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // кнопка save не будет показываться если не заполним текствиод
    @objc func textFieldChanged() {
        if whatDrinkTF.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
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

//MARK: - Work with image

extension AddEventTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //он определяет типа выбора изображения: галерея или камера
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true, completion: nil)
 
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        beerImage.image = info[.editedImage] as? UIImage
        beerImage.contentMode = .scaleAspectFill
        beerImage.clipsToBounds = true
        
        imageIsChanged = true
        
        dismiss(animated: true, completion: nil)
    }
}

