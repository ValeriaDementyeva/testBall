//
//  Ball.swift
//  testBall
//
//  Created by Валерия Дементьева on 03.08.2023.
//

import Foundation
import UIKit


protocol BallProtocol {
    init(color: UIColor, radius: Int, coordinaes: (x: Int, y: Int))
}

//класс, создающий шар
public class Ball: UIView, BallProtocol{
    required public init(color: UIColor, radius: Int, coordinaes: (x: Int, y: Int)) {
        //создание графического прямоугольника
        super.init(frame: CGRect(x: coordinaes.x, y: coordinaes.y, width: radius * 2, height: radius * 2)
        )
        //скругление углов
        self.layer.cornerRadius = self.bounds.width / 2.0
        //изменение цвета фона
        self.backgroundColor = color
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
