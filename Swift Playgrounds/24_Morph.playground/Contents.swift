import PlaygroundSupport
import SceneKit

class GameViewController: UIViewController {
    
    var scnView:SCNView!
    
    var o1:SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // シーンファイルの呼び出し
        let scene = SCNScene(named: "monkey.scn")!
        
        // カメラ
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 2.325, y: 1.414, z: 2.399)
        cameraNode.eulerAngles = SCNVector3(x: -0.125 * Float.pi, y: 0.25 * Float.pi, z: 0)
        scene.rootNode.addChildNode(cameraNode)
    
        o1 = scene.rootNode.childNode(withName: "o", recursively: false)!
        
        let a2 = CABasicAnimation.init(keyPath: "morpher.weights[0]")
        a2.fromValue = 0.0
        a2.toValue = 1.0
        a2.duration = 0.5
        a2.beginTime = 1.0
        a2.autoreverses = true
        a2.repeatCount = .infinity
        
        o1.addAnimation(a2, forKey: nil)
        
        // View 設定
        scnView = SCNView()
        self.view.addSubview(scnView)
        
        // View の Autolayout
        scnView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:
            "V:|[scnView]|", options: NSLayoutFormatOptions(rawValue: 0),
                             metrics: nil, views: ["scnView": scnView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:
            "H:|[scnView]|", options: NSLayoutFormatOptions(rawValue: 0),
                             metrics: nil, views: ["scnView": scnView]))
        
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.showsStatistics = true
        scnView.backgroundColor = UIColor.black
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

PlaygroundPage.current.liveView = GameViewController()
