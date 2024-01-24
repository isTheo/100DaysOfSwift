//
//  ViewController.swift
//  Project1-StormViewer
//
//  Created by Matteo Orru on 28/12/23.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Challenge 2 of project 3
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true //Apple recommends using largeTitles only in the main ViewController
        
        let fm = FileManager.default
        //where I can find all the images added to the app
        let path = Bundle.main.resourcePath!
        //items is set to the contents of the directory at a specified path (in this case, the path constant above)
        let items = try! fm.contentsOfDirectory(atPath: path)
        //since we obtained the path directly from iOS, there is no need to handle the error as we know the code will work
        
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        print(pictures.sort())
    }
    
    //this code will be triggered when iOS wants to know how many rows are in the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    //this method will be called when you need to provide a row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //dequeue avoids iOS from creating new table view cells and recycles those already existing, saving resources
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            //queste proprietà verranno settate in DetalViewController
            vc.numberOfPictures = pictures.count
            vc.positionInArray = indexPath.row + 1
        }
    }

    
    //Challenge 2 of project 3
    @objc func shareTapped() {
            let str = " *AppStore link* "
            
            let vc = UIActivityViewController(activityItems: [str], applicationActivities: [])
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
        }
    
}

//Challenges of project 1:

// 1. Use Interface Builder to select the text label inside your table view cell and adjust its font size to something larger – experiment and see what looks good.

// 2. In your main table view, show the image names in sorted order, so “nssl0033.jpg” comes before “nssl0034.jpg”.

// 3. Rather than show image names in the detail title bar, show “Picture X of Y”, where Y is the total number of images and X is the selected picture’s position in the array. Make sure you count from 1 rather than 0.
