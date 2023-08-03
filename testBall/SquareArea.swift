//
//  SquareArea.swift
//  testBall
//
//  Created by Валерия Дементьева on 03.08.2023.
//

import Foundation
import UIKit


protocol SquareAreaProtocol{
    init(size: CGSize, color: UIColor)
    // установить шарики в область
    func setBalls(withColors: [UIColor], andRadius: Int)
}

//класс, создающий прямоугольную площадку, по которой будут перемещаться шарики
public class SquareArea: UIView, SquareAreaProtocol{
    required public init(size: CGSize, color: UIColor) {
        // создание обработчика столкновений
        collisionBehavior = UICollisionBehavior(items: [])
        // строим прямоугольную графическую область
        super.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        // изменяем цвет фона
        self.backgroundColor = color
        // указываем границы прямоугольной области, как объекты взаимодействия, чтобы об них могли ударяться шарики
        collisionBehavior.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))
        // подключаем аниматор с указанием на сам класс
        animator = UIDynamicAnimator(referenceView: self)
        // подключаем к аниматору обработчик столкновений
        animator?.addBehavior(collisionBehavior)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // коллекция всех шариков
    private var balls: [Ball] = []
    // аниматор графических объектов
    private var animator: UIDynamicAnimator?
    // обработчик перемещений объектов
    private var snapBehavior: UISnapBehavior?
    // обработчик столкновений шариков друг с другом и с границами прямоугольной области
    private var collisionBehavior: UICollisionBehavior

    public func setBalls(withColors ballsColor: [UIColor], andRadius radius: Int) {
        // перебираем переданные цвета один цвет — один шарик
        /* Основная задача данного метода — создание экземпляров типа Ball и размещение их на прямоугольной площадке. Работа включает следующие шаги:
         1. Производится перебор всех переданных цветов, так как количество шариков соответствует количеству цветов. При этом используется метод enumerated(), позволяющий получить целочисленный индекс и значение каждого элемента коллекции.
         2. Рассчитываются координаты очередного шарика. Указанная формула позволяет разместить элементы каскадом, то есть каждый последующий находится правее и ниже предыдущего.
         3. Создается экземпляр типа Ball (с помощью созданного ранее инициализатора).
         4. Созданное отображение шарика включается в состав отображения прямоугольной области с помощью метода addSubview(_:). Метод addSubview(_:) предназначен для того, чтобы включить одни представления в состав другого.
         5. Созданный экземпляр добавляется в приватную коллекцию.
         6. Созданный экземпляр добавляется в обработчик столкновений.*/
        for (index, oneBallColor) in ballsColor.enumerated() {
            // рассчитываем координаты левого верхнего угла шарика
            let coordinateX = 10 + (2 * radius) * index
            let coordinateY = 10 + (2 * radius) * index
            // создаем экземпляр сущности "Шарик"
            let ball = Ball(color: oneBallColor, radius: radius, coordinaes: (x: coordinateX, y: coordinateY))
            // добавляем шарик в текущее отображение (в состав прямоугольной площадки)
            self.addSubview(ball)
            // добавляем шарик в коллекцию шариков
            self.balls.append(ball)
            // добавляем шарик в обработчик столкновений
            collisionBehavior.addItem(ball)
        }
    }
    //Метод уже определен в классе UIView, поэтому при создании собственной реализации в дочерних классах (в нашем случае в SquareArea) потребуется его переопределить с использованием ключевого слова override. метод обрабатывающий произошедшие с ним события касания: touchesBegan(_:with:). При нажатии на определенную точку в прямоугольной области будет определяться, соответствуют ли координаты нажатия текущему положению одного из шариков.
    /* Аргумент touches содержит данные обо всех текущих касаниях. Это связано с тем, что экран всех современных смартфонов поддерживает мультитач, то есть одновременное касание несколькими пальцами. В начале метода извлекаются данные о первом элементе множества touches и помещаются в константу touch.
     Константа touchLocation содержит координаты касания относительно площадки, на которой расположены шарики.
     С помощью метода ball.frame.contains() мы определяем, относятся ли координаты касания к какому-либо из шариков. Если находится соответствие, то в свойство snapBehavior записываются данные о шарике, с которым в текущий момент происходит взаимодействие, и о координатах касания.
     Свойство damping определяет плавность и затухание при движении шарика.
     Далее, используя метод addBehavior(_:) аниматора, указываем, что обрабатывае- мое классом UISnapBehavior поведение объекта должно быть анимировано. Таким образом, все изменения состояния объекта будут анимированы.*/
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location( in: self )
            for ball in balls {
                if (ball.frame.contains( touchLocation )) {
                    snapBehavior = UISnapBehavior(item: ball, snapTo: touchLocation)
                    snapBehavior?.damping = 0.5
                    animator?.addBehavior(snapBehavior!)
                }
            }
        }
    }
    //необходимо обрабатывать перемещение пальца. Для этого реализуем метод touchesMoved(_:with:) Так как в свойстве snapBehavior уже содержится указание на определенный шарик, с которым происходит взаимодействие, нет необходимости проходить по всему массиву шариков снова. Единственной задачей данного метода является изменение свойства snapPoint, которое указывает на координаты объекта.
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location( in: self )
            if let snapBehavior = snapBehavior {
                snapBehavior.snapPoint = touchLocation
            }
        }
    }
    //Для завершения обработки перемещения объектов касанием необходимо переопределить метод touchesEnded(_:with:) Этот метод служит для решения одной очень важной задачи — очистки используемых ресурсов. После того как взаимодействие с шариком окончено, хранить информацию об обработчике поведения в snapBehavior уже нет необходимости.
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let snapBehavior = snapBehavior {
            animator?.removeBehavior(snapBehavior)
        }
        snapBehavior = nil
    }
}
