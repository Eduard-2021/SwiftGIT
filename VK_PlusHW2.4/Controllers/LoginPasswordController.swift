//
//  ViewController.swift
//  VK_PlusHW1
//
//  Created by Eduard on 02.04.2021.
//

import UIKit

class ViewController: UIViewController {
    
    let cloud = CAShapeLayer()
    var buttonEnterEarlierPress = false
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func unwindSwgue(for unwindSegue: UIStoryboardSegue) {}
    
    private func checkLoginPassword() -> Bool {
        //Проверка логина и пароля (пока заданы дефолтные значения)
        var login = loginField.text!
        login = "a@a.com"
        var password = passwordField.text!
        password = "12345678"
        if (login == "a@a.com") && (password == "12345678") {
            return true
        }
        else {
            //Если неправильно, то вызывается Alert
            uncorrectPasswordOrLogin()
            return false
        }
    }
    
    // Метод отрабатывает нажатие на кнопку "Войти"
    @IBAction func pressEnter(_ sender: Any) {
        if !buttonEnterEarlierPress { //проверка не нажимался ли повторно во время анимации ввод чтобы не множить движущиеся по контуру облака линии
            
        buttonEnterEarlierPress = true
        cloud.isHidden = false // делаем облако загрузки видимым
        animateLoadingCloud() // вызываем метод создания бегущей полосы по облаку
        
        let cub = UIView(); view.addSubview(cub) // создание технической View, которой на экране не видно, но она в рамках следующей анамации будет обеспечивать 3 секундную задержку перед переходом в блок Complite, который, в свою очередь, производит переход по Segue на слудующий экран (анаимацию класса CAKeyframeAnimation и его Complete не удалось для этого использовать - сразу активируется Complete)
        
        UIView.animate(withDuration: 3,
                       animations: {
                        cub.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                       },
                       completion: { [self] _ in
                        if checkLoginPassword() {
                        self.performSegue(withIdentifier: "showSecondWindow", sender: nil)
                        }
                        cub.removeFromSuperview() // удаление технической View
                        // удаление облака и всех связанных с ним слоев
                        self.cloud.isHidden = true
                        self.cloud.sublayers = nil
                        self.cloud.removeFromSuperlayer()
                       })
        }
    }
    
    //Возврат кнопке "Войти" возможности вызывать облако и переходить на следующий экран
    override func viewDidDisappear(_ animated: Bool) {
        buttonEnterEarlierPress = false
    }
    
    // Отработка неверного логина или пароля через Alert
    private func uncorrectPasswordOrLogin(){
        let alertController = UIAlertController(title: "Ошибка",
                                                message: "Неверный логин или пароль",
                                                preferredStyle: .alert)
        let buttonOk = UIAlertAction(title: "Ok", style: .default, handler:
                                        { _ in self.loginField.text = ""
                                            self.passwordField.text = ""
                                        })
        alertController.addAction(buttonOk)
        present(alertController, animated: true)
    }
    
    
    //метод задания параметров облаку, его размещение и анамирование по нему линии
    func animateLoadingCloud(){
        let factor : CGFloat = 5 //переменная, которая масштабирует (уменьшает) облако в указанное число раз
        
        //задание позиции облаку
        let pozzitionCloudX : CGFloat = self.view.bounds.width/2 - 28
        let pozzitionCloudY = self.view.bounds.height/2 - 10
        cloud.frame = CGRect(x: pozzitionCloudX, y: pozzitionCloudY, width: 0, height: 0)
        
        //Создание константы, в которой храниться начальная точка прорисовки облака и точек линии
        let startPoint = CGPoint(x: 46.7/factor, y: 180/factor)
        //объект с BeziePath облака
        let bezieCloud = makeBeziePath(factor: factor, startPoint: startPoint)
        
        //параметрирование облака и размещение его на слое
        cloud.path = bezieCloud.cgPath
        cloud.strokeColor = UIColor.systemBlue.cgColor
        cloud.lineWidth = 3
        view.layer.addSublayer(cloud)
        
        //создание 3 точек на контуре облака и их анамирование
        createPointAndMoveThem(startPoint: startPoint, bezieCloud: bezieCloud, duration: 0)
        createPointAndMoveThem(startPoint: startPoint, bezieCloud: bezieCloud, duration: 0.05)
        createPointAndMoveThem(startPoint: startPoint, bezieCloud: bezieCloud, duration: 0.1)
        
    }
    
    //Метод создания и анамирование точки на контуре облака
    func createPointAndMoveThem(startPoint: CGPoint, bezieCloud: UIBezierPath, duration : CFTimeInterval ){
        let point = CAShapeLayer()
        point.backgroundColor = UIColor.white.cgColor
        point.frame = CGRect(x: startPoint.x, y: startPoint.y, width: 5, height: 5)
        point.cornerRadius = 2.5
        cloud.addSublayer(point)

        let moveAnimation = CAKeyframeAnimation(keyPath: #keyPath(CAShapeLayer.position))
        moveAnimation.path = bezieCloud.cgPath
        moveAnimation.calculationMode = .paced
        moveAnimation.speed = 1
        moveAnimation.repeatCount = 3
        moveAnimation.duration = 3
        moveAnimation.beginTime = CACurrentMediaTime() + duration
        
        point.add(moveAnimation, forKey: nil)
    }
    
    //Метод создание BezierPath для облака и точек, которые по нему двигаются
    func makeBeziePath(factor : CGFloat, startPoint : CGPoint) -> UIBezierPath {
        let bezieCloud = UIBezierPath()
        bezieCloud.move(to: startPoint)
        bezieCloud.addCurve(to: CGPoint(x: 0, y: 134.8/factor),
                            controlPoint1: CGPoint(x: 20.6/factor, y: 180/factor),
                            controlPoint2: CGPoint(x: 0/factor, y: 160.73/factor))
        bezieCloud.addCurve(to: CGPoint(x: 46.5/factor, y: 88.7/factor),
                            controlPoint1: CGPoint(x: 0, y: 108.87/factor),
                            controlPoint2: CGPoint(x: 20.6/factor, y: 88.6/factor))
        bezieCloud.addCurve(to: CGPoint(x: 101.1/factor, y: 33.1/factor),
                            controlPoint1: CGPoint(x: 46.5/factor, y: 88.7/factor),
                            controlPoint2: CGPoint(x: 39/factor, y: 34.4/factor))
        bezieCloud.addCurve(to: CGPoint(x: 127.7/factor, y: 39.7/factor),
                            controlPoint1: CGPoint(x: 111.3/factor, y: 33/factor),
                            controlPoint2: CGPoint(x: 119.5/factor, y: 35.5/factor))
        bezieCloud.addCurve(to: CGPoint(x: 194.87/factor, y: 0),
                            controlPoint1: CGPoint(x: 141.4/factor, y: 14.95/factor),
                            controlPoint2: CGPoint(x: 165.7/factor, y: 0))
        bezieCloud.addCurve(to: CGPoint(x: 270.4/factor, y: 91.75/factor),
                            controlPoint1: CGPoint(x: 243.4/factor, y: 0),
                            controlPoint2: CGPoint(x: 281.39/factor, y: 42.61/factor))
        bezieCloud.addCurve(to: CGPoint(x: 300/factor, y: 134.29/factor),
                            controlPoint1: CGPoint(x: 288.4/factor, y: 98.7/factor),
                            controlPoint2: CGPoint(x: 300/factor, y: 114.7/factor))
        bezieCloud.addCurve(to: CGPoint(x: 253.61/factor, y: 180/factor),
                            controlPoint1: CGPoint(x: 300/factor, y: 160.35/factor),
                            controlPoint2: CGPoint(x: 279.8/factor, y: 180/factor))
        bezieCloud.addCurve(to: startPoint,
                            controlPoint1: CGPoint(x: 184.26/factor, y: 180/factor),
                            controlPoint2: CGPoint(x:  116.79/factor, y: 180/factor))
        return bezieCloud
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(hideKeyboard))
        scrollView?.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWasShown),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillBeHidden(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc func hideKeyboard() {
        scrollView?.endEditing(true)
    }
    
    @objc func keyboardWasShown(notification: Notification) {
    // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    //Когда клавиатура исчезает 
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }
    
}

