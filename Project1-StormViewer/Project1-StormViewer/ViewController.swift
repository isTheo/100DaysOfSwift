//
//  ViewController.swift
//  Project1-StormViewer
//
//  Created by Matteo Orru on 28/12/23.
//

//  Modified the original Project1 by implementing UserDefaults. Now it tracks and displays the number of times each image has been opened.


import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    var picDictionary = [String: Int]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: "picDictionary") as? Data,
           let savedPictures = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()
            
            
            do {
                picDictionary = try jsonDecoder.decode([String: Int].self, from: savedData)
                pictures = try jsonDecoder.decode([String].self, from: savedPictures)
            } catch {
                print("Failed to load saved data")
            }
        } else {
            performSelector(inBackground: #selector(loadPictures), with: nil)
        }
        
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    
    @objc func loadPictures() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
                picDictionary[item] = 0
            }
        }
        print(pictures.sort())
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(picDictionary),
           let savedPictures = try? jsonEncoder.encode(pictures) {
            
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "picDictionary")
            defaults.set(savedPictures, forKey: "pictures")
        } else {
            print("Failed to save data.")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        let picture = pictures[indexPath.row]
        cell.textLabel?.text = pictures[indexPath.row]
        cell.detailTextLabel?.text = "Image viewed \(picDictionary[picture]!) times"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            vc.numberOfPictures = pictures.count
            vc.positionInArray = indexPath.row + 1
        }
        
        let picture = pictures[indexPath.row]
        picDictionary[picture]! += 1
        save()
        tableView.reloadData()
    }

    
    @objc func shareTapped() {
            let str = " *AppStore link* "
            
            let vc = UIActivityViewController(activityItems: [str], applicationActivities: [])
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
        }
    
}
