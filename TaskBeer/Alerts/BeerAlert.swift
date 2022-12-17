//
//  BeerAlert.swift
//  TaskBeer
//
//  Created by Paul James on 05.12.2022.
//

import Foundation
import UIKit

class BeerAlert {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let scrollView = UIScrollView()
    private var mainView: UIView?
    
    func alertCustom(viewController: UIViewController) {
        guard let parentView = viewController.view else {return}
        mainView = parentView
        
        scrollView.frame = parentView.frame
        parentView.addSubview(scrollView)
        
        backgroundView.frame = parentView.frame
        parentView.addSubview(backgroundView)
        
        alertView.frame = CGRect(x: 40, y: -420, width: parentView.frame.width - 80, height: 420)
        parentView.addSubview(alertView)
        
        
        //картинка
        let beerImageView = UIImageView(frame: CGRect(x: 60 , y: 50, width: 200 , height: 200))
        beerImageView.image = UIImage(named: "megaSuperBeer")
        beerImageView.contentMode = .scaleAspectFill
        beerImageView.clipsToBounds = true
        
        alertView.addSubview(beerImageView)
        
        //текст
        
        let textLabel = UILabel(frame: CGRect(x: (alertView.frame.width * 0.2) / 2, y: 260, width: alertView.frame.width - 50, height: 60))
        textLabel.text = "Хорошо пивко, но надо поработать"
        textLabel.textColor = .white
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        alertView.addSubview(textLabel)
        
        //кнопка
        
        let okButton = UIButton(frame: CGRect(x: 50, y: 350, width: alertView.frame.width - 100,height: 35))
        okButton.backgroundColor = #colorLiteral(red: 0.2745098039, green: 0.4862745098, blue: 0.1411764706, alpha: 1)
        okButton.setTitle("Пора поработать", for: .normal)
        okButton.titleLabel?.font = UIFont(name: "Avenir Next", size: 17)
        okButton.layer.cornerRadius = 10
        okButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        alertView.addSubview(okButton)
        
        // работа анимации
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 0.8
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.3) {
                    self.alertView.center = parentView.center
                }
            }
        }
    }
    
    @objc private func dismissAlert() {
        
        guard let targetView = mainView else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.alertView.frame = CGRect(x: 40, y: targetView.frame.height, width: targetView.frame.width - 80, height: 420)
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.3) {
                    self.backgroundView.alpha = 0
                } completion: { [weak self] done in
                    guard let self = self else { return }
                    if done {
                        self.alertView.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                        self.scrollView.removeFromSuperview()
                        
                    }
                }
            }
        }
    }
}
