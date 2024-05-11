//
//  DetailViewController.swift
//  Project1-StormViewer
//
//  Created by Matteo Orru on 28/12/23.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
        
    var selectedImage: String?
    var positionInArray = 1
    var numberOfPictures = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Image \(positionInArray) of \(numberOfPictures)"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonPressed))

        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
        
        
        assert(selectedImage != nil, "umwrap of selectedImage gone well, it has a value")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    

    @objc private func shareButtonPressed() {
            guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
                print("No image found")
                return
            }
            let activityVC = UIActivityViewController(activityItems: [selectedImage!, image], applicationActivities: [])
            activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(activityVC, animated: true)
        }


}

