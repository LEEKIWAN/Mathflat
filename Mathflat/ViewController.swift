//
//  ViewController.swift
//  Mathflat
//
//  Created by kiwan on 2021/04/26.
//

import UIKit
import Sketch

class ViewController: UIViewController {

    @IBOutlet weak var sketchView: SketchView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Event
    
    @IBAction func onSaveTouched(_ sender: UIButton) {
        guard let sketchView = sketchView else { return }
        let image = UIGraphicsImageRenderer(bounds: sketchView.bounds).image { _ in
            sketchView.drawHierarchy(in: sketchView.bounds, afterScreenUpdates: true)
        }
        
        if let data = image.pngData() {
            UserDefaults.standard.set(data, forKey: "snapshot")
        }
        
    }
    
    @IBAction func onLoadTouched(_ sender: UIButton) {
        guard let data = UserDefaults.standard.data(forKey: "snapshot"), let image = UIImage(data: data) else { return }
        guard let resizedImage = ImageResizer.shared.resize(image: image, targetSize: sketchView.bounds.size) else { return }
        sketchView.loadImage(image: resizedImage)
    }
    
    @IBAction func onAddPictureTouched(_ sender: UIButton) {
        PhotoRequestManager.requestPhotoFromSavedPhotosAlbum(self){ [weak self] result in
            switch result {
            case .success(let image):
                if let sketchView = self?.sketchView, let resizedImage = ImageResizer.shared.resize(image: image, targetSize: sketchView.bounds.size) {
                    
                    self?.sketchView.loadImage(image: resizedImage)
                }
            case .faild:
                print("failed")
            case .cancel:
                break
            }
        }
    }
    
    
    @IBAction func onUndoTouched(_ sender: UIButton) {
        sketchView.undo()
    }
    
    @IBAction func onRedoTouched(_ sender: UIButton) {
        sketchView.redo()
    }
    
    @IBAction func onPenTouched(_ sender: UIButton) {
        sketchView.drawTool = .pen
    }
    
    @IBAction func onEraseTouched(_ sender: UIButton) {
        sketchView.drawTool = .eraser
    }
}

