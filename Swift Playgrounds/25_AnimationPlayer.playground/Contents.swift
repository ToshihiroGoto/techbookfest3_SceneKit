import PlaygroundSupport
import SceneKit

class GameViewController: UIViewController {
    
    var scnView:SCNView!
    
    var Max:SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // シーンファイルの呼び出し
        let scene = SCNScene(named: "max.scn")!
        
        // カメラ
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0.636, y: 0.199, z: 1.374)
        cameraNode.eulerAngles = SCNVector3(x: 0.636, y: 0.125 * Float.pi, z: 0)
        scene.rootNode.addChildNode(cameraNode)
        
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
        
        
        let walkScene = SCNScene(named: "max_walk.scn")!
        
        var walkAnimation: SCNAnimationPlayer!
        
        walkScene.rootNode.enumerateChildNodes { (child, stop) in
            if !child.animationKeys.isEmpty {
                walkAnimation = child.animationPlayer(forKey: child.animationKeys[0])
                stop.pointee = true
            }
        }
        
        walkAnimation.speed = 1
        
        let spinScene = SCNScene(named: "max_spin.scn")!
        
        var spinAnimation: SCNAnimationPlayer!
        
        spinScene.rootNode.enumerateChildNodes { (child, stop) in
            if !child.animationKeys.isEmpty {
                spinAnimation = child.animationPlayer(forKey: child.animationKeys[0])
                stop.pointee = true
            }
        }
        
        spinAnimation.speed = 1.5
        //spinAnimation.blendFactor = 0.5
        //spinAnimation.animation.autoreverses = true
        spinAnimation.animation.isRemovedOnCompletion = false
        spinAnimation.stop()
        
        Max = scene.rootNode.childNode( withName: "Max_rootNode", recursively: true)!
        Max.addAnimationPlayer(walkAnimation, forKey: "walk")
        Max.addAnimationPlayer(spinAnimation, forKey: "spin")
        
        
        
        // タップジェスチャー
        let tapGesture = UITapGestureRecognizer(target: self, action:
            #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        Max.animationPlayer(forKey: "spin")?.play()
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
