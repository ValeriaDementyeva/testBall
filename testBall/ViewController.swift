//
//  ViewController.swift
//  testBall
//
//  Created by Валерия Дементьева on 03.08.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        // размеры прямоугольной области
        let sizeOfArea = CGSize(width: 350, height:800)
        // создание экземпляра
        //#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) с помощью red, green, blue определяется цвет, а с помощью alpha — прозрачность. преобразовывается в черный квадрат. Для выбора нового цвета вам необходимо дважды щелкнуть на квадрате и выбрать подходящий из появившейся палитры. Такой подход возможен только в файлах страниц playground. В файлах с исходным кодом (Balls.swift и SquareArea.swift) вся информация отображается исключительно в текстовом виде.
        let area = SquareArea(size: sizeOfArea, color: UIColor.black)
        area.setBalls(withColors:[UIColor.red, UIColor.white, UIColor.blue, UIColor.green], andRadius: 38)

        view.addSubview(area)
    }


}

