import PlaygroundSupport
import SceneKit

class GameViewController: UIViewController {
    
    var scnView:SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // シーンファイルの呼び出し
        let scene = SCNScene(named: "bg.scn")!
        
        // カメラ
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 3)
        scene.rootNode.addChildNode(cameraNode)
        
        // 球
        let basePos:Float = -0.9
        let pos:Float = 0.2
        let intensity:Float = 0.2
        
        for i in 0..<10 {
            for j in 0..<2 {
                let node = SCNNode()
                let geometry = SCNSphere(radius: 0.075)
                geometry.firstMaterial?.lightingModel = .physicallyBased
                geometry.firstMaterial?.diffuse.contents = UIColor.white
                geometry.firstMaterial?.metalness.contents = UIColor.white
                geometry.firstMaterial?.metalness.intensity = CGFloat(intensity * Float(i))
                
                geometry.firstMaterial?.roughness.contents = UIColor.white
                geometry.firstMaterial?.roughness.intensity = CGFloat(0.7 * Float(j))
            
                node.geometry = geometry
                node.position = SCNVector3(
                    CGFloat(basePos + (pos * Float(i))), 
                    CGFloat(-pos * Float(j)), 
                    0
                )
            
                scene.rootNode.addChildNode(node)
            }
        }
        
        // Visual Property の名前
        let textNode = SCNNode()
        let text = SCNText()
        text.flatness = 0
        text.string = "Metalness + Roughness"
        
        textNode.geometry = text
        textNode.position = SCNVector3(-1, 0.1, 0)
        textNode.scale = SCNVector3(0.012, 0.012, 0.012)
        
        scene.rootNode.addChildNode(textNode)
        
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
