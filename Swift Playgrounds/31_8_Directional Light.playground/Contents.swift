import PlaygroundSupport
import SceneKit

class GameViewController: UIViewController {
    
    var scnView:SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // シーンファイルの呼び出し
        let scene = SCNScene(named: "ship.scn")!
        
        // カメラ
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 2.325, y: 1.414, z: 2.399)
        cameraNode.eulerAngles = SCNVector3(x: -0.125 * Float.pi, y: 0.25 * Float.pi, z: 0)
        scene.rootNode.addChildNode(cameraNode)
        
        let ship = scene.rootNode.childNode(withName: "shipMesh", recursively: true)!
        ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        // 場所に関係なく一定方向に光をあてる DirectionalLit
        let directionalLight = SCNNode()
        directionalLight.light = SCNLight()
        directionalLight.light?.type = .directional
        directionalLight.light?.shadowRadius = 3
        directionalLight.light?.shadowBias = 4
        directionalLight.light?.shadowSampleCount = 10
        directionalLight.light?.maximumShadowDistance = 10
        directionalLight.light?.castsShadow = true
        directionalLight.position = SCNVector3(x: 0, y: 1.5, z: 0)
        directionalLight.eulerAngles = SCNVector3(-0.25 * Float.pi, 0 ,0)

        // ライトを移動
        directionalLight.runAction(SCNAction.repeatForever(
            SCNAction.sequence([
                SCNAction.move(to: SCNVector3(1, 1.5, 0), duration: 2),
                SCNAction.move(to: SCNVector3(-1, 1.5, 0), duration: 2),
            ])
        ))
        
        scene.rootNode.addChildNode(directionalLight)
        
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
        
        // デバッグオプションでライトをワイヤーフレーム表示
        scnView.debugOptions = .showLightExtents
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
