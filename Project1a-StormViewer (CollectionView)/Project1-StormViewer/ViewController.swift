//
//  ViewController.swift
//  Project1-StormViewer
//
//  Created by Matteo Orru on 28/12/23.
//  modified original Project1 using UICollectionViewController

import UIKit

class ViewController: UICollectionViewController {
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        navigationController?.navigationBar.prefersLargeTitles = true

        performSelector(inBackground: #selector(loadImages), with: nil)

        collectionView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)

    }
    
    
    @objc func loadImages() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
        pictures.sort()
        //reloadData on main thread
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? PictureCell else {
            
            fatalError("Unable to dequeue PictureCell")
        }
        
        let picture = pictures[indexPath.item]
        if let image = UIImage(named: picture) {
            cell.imageView.image = image
        } else {
            print("Failed to load image: \(picture)")
        }
        
        cell.layer.borderWidth = 1.0
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            
            vc.numberOfPictures = pictures.count
            vc.positionInArray = indexPath.row + 1
        }
    }

    
    @objc func shareTapped() {
            let str = " *AppStore link* "
            
            let vc = UIActivityViewController(activityItems: [str], applicationActivities: [])
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
        }
    
    
}

