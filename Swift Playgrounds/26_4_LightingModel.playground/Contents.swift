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
        cameraNode.position = SCNVector3(x: 0, y: 0.3, z: 3)
        cameraNode.camera?.zNear = 0.01
        scene.rootNode.addChildNode(cameraNode)
        
        let max1 = scene.rootNode.childNode(withName: "Max1", recursively: true)!
        let max2 = scene.rootNode.childNode(withName: "Max2", recursively: true)!
        let max3 = scene.rootNode.childNode(withName: "Max3", recursively: true)!
        let max4 = scene.rootNode.childNode(withName: "Max4", recursively: true)!
        let max5 = scene.rootNode.childNode(withName: "Max5", recursively: true)!
        
        max1.geometry?.firstMaterial?.lightingModel = .constant
        max2.geometry?.firstMaterial?.lightingModel = .lambert
        max3.geometry?.firstMaterial?.lightingModel = .blinn
        max4.geometry?.firstMaterial?.lightingModel = .phong
        max5.geometry?.firstMaterial?.lightingModel = .physicallyBased
        
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
