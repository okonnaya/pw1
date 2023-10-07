//
//  ViewController.swift
//  kbramazanovaPW1
//
//  Created by carina 🕯 on 04.10.2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var views: [UIView]!
    
    @IBOutlet weak var blueButton: UIButton!
    //объявляю кнопку, чтобы дизейблить
    @IBAction func buttonWasPressed(_ sender: Any) {
        print("pressed")
        var currentColors = Set<UIColor>()
        self.blueButton.isEnabled = false
        print("disabled")
        //нажатие кнопки,  объявление переменной с цветом
        let dispatchGroup = DispatchGroup()
        //объявление диспатч группы, чтобы асинхронными функциями управлять вместе, как я поняла
        
        UIView.animate(withDuration: 0.4, animations: {
            //включаем анимации и начинаем цикл для каждого элемента из массива вьюшек
            for item in self.views {
                //удаляем из сабвью с лейблом в начале цикла
                item.subviews.forEach { $0.removeFromSuperview() }
                var notRepeatedColorFound = false
                
                //цикл который генерит цвета и проверяет чтобы они не повторялись
                while notRepeatedColorFound == false {
                    let randomColor = UIColor(
                        red: .random(in: 0...1),
                        green: .random(in: 0...1),
                        blue: .random(in: 0...1),
                        alpha: 1
                    )
                    print(randomColor)
                    print(notRepeatedColorFound)
                    print(currentColors)
                    
                    if !currentColors.contains(randomColor) {
                        currentColors.insert(randomColor)
                        
                        dispatchGroup.enter()
                        
                        //если нашли рандомный цвет, то включаем анимацию и меняем цвет самого объекта и бордер радиус генерим, добавляем лейбл с названием цвета переведенным в хекс
                        UIView.animate(withDuration: 0.4, animations: {
                            item.backgroundColor = randomColor
                            item.layer.cornerRadius = .random(in: 20...100)
                            
                            let textHEX = UILabel(frame: CGRect(x: 0, y: 0, width: item.frame.width, height: 100))
                            textHEX.textAlignment = .center
                            textHEX.textColor = .black
                            textHEX.text = randomColor.toHEX()
                            textHEX.font = UIFont.systemFont(ofSize: 14)
                                                    item.addSubview(textHEX)
                            
                        }, completion: { _ in
                            dispatchGroup.leave()
                        })
                        
                        notRepeatedColorFound = true
                    }
                }
            }
        }) { [weak self] _ in
            dispatchGroup.notify(queue: .main) {
                self?.blueButton.isEnabled = true
                print("disdisabled")
                //включаем кнокпу, когда закончили все анимации из группы
            }
        }
    }

    
    
}
//тут экстеншн, чтобы перевести значение из ргб в хекс, выше эта функция используется при генерации лейбла

extension UIColor {
    func toHEX() -> String {
        guard let components = cgColor.components, components.count >= 3 else {
            return "something wrong???"
        }
        
        let red = Int(components[0] * 255)
        let green = Int(components[1] * 255)
        let blue = Int(components[2] * 255)
        
        let hex = String(format: "#%02X%02X%02X", red, green, blue)
        return hex
    }
}
