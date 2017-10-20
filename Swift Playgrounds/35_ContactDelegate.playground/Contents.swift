import PlaygroundSupport
import SceneKit

class GameViewController: UIViewController, SCNPhysicsContactDelegate {
    
    var ballNode:SCNNode!
    var scnView:SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // シーン
        let scene = SCNScene()
        
        // contactDelegate
        scene.physicsWorld.contactDelegate = self
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 12.68, y: 7.445, z: 12.86)
        cameraNode.eulerAngles = SCNVector3(x: ((Float.pi * -22.129) / 180), y: ((Float.pi * 44.576) / 180), z: 0.0)
        scene.rootNode.addChildNode(cameraNode)
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 12, z: 0)
        scene.rootNode.addChildNode(lightNode)
        
        ballNode = SCNNode(geometry: SCNSphere(radius: 2))
        ballNode.name = "ball"
        ballNode.position = SCNVector3(x: 0, y: 5, z: 0)
        ballNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        ballNode.physicsBody?.contactTestBitMask = 1
        scene.rootNode.addChildNode(ballNode)
        
        let floorNode = SCNNode(geometry: SCNFloor())
        floorNode.name = "floor"
        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        floorNode.physicsBody?.contactTestBitMask = 1
        scene.rootNode.addChildNode(floorNode)
        
        // View 設定
        scnView = SCNView()
        self.view.addSubview(scnView)
        
        // View の Autolayout
        scnView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scnView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["scnView": scnView]))
    self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scnView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["scnView": scnView]))
        
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.showsStatistics = true
        scnView.backgroundColor = UIColor.black
        
        // タップジェスチャー
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        ballNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        ballNode.physicsBody?.resetTransform()
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        print("didBegin contact")
        ballNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
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
