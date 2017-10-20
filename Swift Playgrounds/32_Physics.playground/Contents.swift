import PlaygroundSupport
import SceneKit

class GameViewController: UIViewController {
    
    var ballNode:SCNNode!
    var scnView:SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene()
        
        // 床
        let floor = SCNFloor()
        let floorNode = SCNNode(geometry: floor)
        floorNode.position = SCNVector3(0, -4, 0)
        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        scene.rootNode.addChildNode(floorNode)
        
        // オムニ ライト
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // アンビエント ライト
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // カメラ
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        scene.rootNode.addChildNode(cameraNode)
        
        // シーン設定
        scnView = SCNView()
        self.view.addSubview(scnView)
        
        scnView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scnView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["scnView": scnView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scnView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["scnView": scnView]))
        
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.showsStatistics = true
        scnView.backgroundColor = UIColor.black
        
        // 球のジオメトリ
        let ball = SCNSphere(radius: 0.5)
        ballNode = SCNNode(geometry: ball)
        ballNode.position.y = 4
        
        ballNode.runAction(SCNAction.sequence([
            SCNAction.wait(duration: 10, withRange:4),
            SCNAction.fadeOut(duration: 1),
            SCNAction.removeFromParentNode()
            ]))
        
        // 追加分
        let physicsBall = SCNPhysicsShape(node: ballNode, options: nil)
        ballNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: physicsBall)
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        scnView.scene?.rootNode.addChildNode(ballNode.clone())
        
    }
    
    override var shouldAutorotate: Bool {
        return true
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
        // Release any cached data, images, etc that aren't in use.
    }
    
}

PlaygroundPage.current.liveView = GameViewController()
