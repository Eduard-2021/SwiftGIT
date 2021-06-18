//
//  VKLoginPasswordViewController.swift
//  VK_PlusHW2.2
//
//  Created by Eduard on 25.05.2021.
//

import UIKit
import WebKit

class VKLoginPasswordViewController: UIViewController {
    
    let cloud = CAShapeLayer()
    let cub = UIView()
    var countOfRequist = 0
    let loading = UILabel()

    @IBOutlet var webView: WKWebView!
    {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    @IBOutlet weak var login: UILabel!
    @IBOutlet weak var password: UILabel!
    
    
    private var urlComponents: URLComponents = {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7863522"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "336918"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.130")
    ]
        return urlComponents
    }()
    
    lazy var request = URLRequest(url: urlComponents.url!)
    
    
    func logOutSegue(){
        DataAboutSession.data.token = ""
        DataAboutSession.data.userID = 0

    let dataStore = WKWebsiteDataStore.default()
    dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
        for record in records {
            if record.displayName.contains("vk") {
                dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: [record], completionHandler: { [weak self] in
                    self?.webView.load(self!.request)
                })
            }
        }
    }
    webView.load(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.load(request)
        logOutSegue()
        loadAnimation()
        cloud.isHidden = true
        loading.isHidden = true
       
    }
    
    func loadAnimation() {
        cloud.isHidden = false
        animateLoadingCloud() // вызываем метод создания бегущей полосы по облаку
    }
    
    func startAnimation() {
        cloud.isHidden = false // делаем облако загрузки видимым
        login.isHidden = true
        password.isHidden = true
        loading.isHidden = false
    }
    
    func stopAnimation(){
        cloud.removeFromSuperlayer()
        loading.removeFromSuperview()
    }
    

    func animateLoadingCloud(){
        let factor : CGFloat = 5 //переменная, которая масштабирует (уменьшает) облако в указанное число раз
        
        //задание позиции облаку
        let pozzitionCloudX : CGFloat = self.view.bounds.width/2 - 28
        let pozzitionCloudY = self.view.bounds.height/2 - 30
        cloud.frame = CGRect(x: pozzitionCloudX, y: pozzitionCloudY, width: 0, height: 0)
        loading.frame = CGRect(x: pozzitionCloudX-10, y: pozzitionCloudY+30, width: 76, height: 50)
        loading.text = "Loading ..."
        view.addSubview(loading)
        
        //Создание константы, в которой храниться начальная точка прорисовки облака и точек линии
        let startPoint = CGPoint(x: 46.7/factor, y: 180/factor)
        //объект с BeziePath облака
        let bezieCloud = makeBeziePath(factor: factor, startPoint: startPoint)
        
        //параметрирование облака и размещение его на слое
        cloud.path = bezieCloud.cgPath
        cloud.strokeColor = UIColor.systemBlue.cgColor
        cloud.lineWidth = 3
        self.view.layer.addSublayer(cloud)
        
        //создание 3 точек на контуре облака и их анамирование
        createPointAndMoveThem(startPoint: startPoint, bezieCloud: bezieCloud, duration: 0)
        createPointAndMoveThem(startPoint: startPoint, bezieCloud: bezieCloud, duration: 0.05)
        createPointAndMoveThem(startPoint: startPoint, bezieCloud: bezieCloud, duration: 0.1)
        
    }
    
    //Метод создания и анимирование точки на контуре облака
    func createPointAndMoveThem(startPoint: CGPoint, bezieCloud: UIBezierPath, duration : CFTimeInterval ){
        let point = CAShapeLayer()
        point.backgroundColor = UIColor.green.cgColor
        point.frame = CGRect(x: startPoint.x, y: startPoint.y, width: 5, height: 5)
        point.cornerRadius = 2.5
        cloud.addSublayer(point)

        let moveAnimation = CAKeyframeAnimation(keyPath: #keyPath(CAShapeLayer.position))
        moveAnimation.path = bezieCloud.cgPath
        moveAnimation.calculationMode = .paced
        moveAnimation.speed = 1
        moveAnimation.repeatCount = 15
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
}

extension VKLoginPasswordViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        countOfRequist += 1
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment else
        { decisionHandler(.allow);
            if countOfRequist == 3 {
                startAnimation()
            }
            return }

        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }

        print(params)
        
        guard let token = params["access_token"],
            let userIdString = params["user_id"],
            let _ = Int(userIdString) else {
                decisionHandler(.allow)
                return
        }

//        DataAboutSession.data.token = token
//        if let userIDInt = Int(userIdString) {
//            DataAboutSession.data.userID = userIDInt
//        }
        
        DataAboutSession.data.userID = 647133643
        DataAboutSession.data.token = "e9ba8e3e913f26b137480ac4c451c1fec43f371219a0602b200771bde81bb9980ab4b12579cc129dc4feb"
        
        MainNetworkService().getUserFriends()
        while (friends.count == 0) || (friends.count < numberOfFriends) {}

        MainNetworkService().getGroupsOfUser(userId: DataAboutSession.data.userID)
        while (activeGroups.count == 0) || (activeGroups.count < numberOfGroups) {}
        
        MainNetworkService().groupsSearch(textForSearch: "Музыка", numberGroups: 5)
        while (allGroups.count == 0) || (allGroups.count < numberOfFoundGroups) {}
      
        performSegue(withIdentifier: "showSecondWindow", sender: nil)
        stopAnimation()
        decisionHandler(.cancel)
    }
}

