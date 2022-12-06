//
//  EventTableViewCell.swift
//  TaskBeer
//
//  Created by Paul James on 04.12.2022.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var whatDrinkLabel: UILabel!
    @IBOutlet weak var amountOfAlcoholLabel: UILabel!
    @IBOutlet weak var whereDrinkLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    func cellConfigure(model: CalendarModel) {
        whatDrinkLabel.text = model.whatDrink
        amountOfAlcoholLabel.text = model.amountOfAlcohol
        whereDrinkLabel.text = model.whereDrink
        guard let data = model.imageData, let image = UIImage(data: data) else {return}
        eventImageView.image = image
        
        eventImageView.contentMode = .scaleAspectFill
        eventImageView.clipsToBounds = true

    }

}
