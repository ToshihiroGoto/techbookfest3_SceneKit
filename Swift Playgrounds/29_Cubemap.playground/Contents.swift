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
        
        // キューブマップ設定
        scene.background.contents = UIImage(named: "cubemap.png")
        scene.lightingEnvironment.contents = UIImage(named: "cubemap.png")
        
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
