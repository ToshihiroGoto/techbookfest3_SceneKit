import PlaygroundSupport
import SceneKit

class GameViewController: UIViewController {
    
    var scnView:SCNView!
    
    var Max:SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // シーンファイルの呼び出し
        let scene = SCNScene(named: "box.scn")!
        
        // カメラ
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 3, y: 3, z: 3)
        cameraNode.eulerAngles = SCNVector3(x: -0.2 * Float.pi, y: 0.25 * Float.pi, z: 0)
        scene.rootNode.addChildNode(cameraNode)
        
        let cube = scene.rootNode.childNode(withName: "Cube", recursively: true)!
        let tessellator = SCNGeometryTessellator()

        tessellator.tessellationFactorScale = 14
        tessellator.isAdaptive = true
        tessellator.isScreenSpace = true
        tessellator.smoothingMode = .phong

        cube.geometry?.subdivisionLevel = 1

        cube.geometry?.tessellator = tessellator
        
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
        
        // ワイヤーフレームを表示
        scnView.debugOptions = [
            .showWireframe,
            .showBoundingBoxes
        ]
        
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
