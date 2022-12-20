//
//  DIYCalendarCell.swift
//  TaskBeer
//
//  Created by Paul James on 20.12.2022.
//

import Foundation
import FSCalendar


class DIYCalendarCell: FSCalendarCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.12)
        view.layer.cornerRadius = 15
        self.backgroundView = view;
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.frame = self.bounds.insetBy(dx: 2, dy: 2)
    }
}
