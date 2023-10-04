//
//  ViewController.swift
//  Reddit Reader
//
//  Created by BerkH on 4.10.2023.
//

import UIKit
import AlamofireImage
import Shared

class RedditReaderVC: UIViewController {
    
    @IBOutlet weak var RedditReaderCollectionView: UICollectionView!
    
    var readers: [RedditPost.Data.Child.PostData] = []
    let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        refreshData()
    }
    
    
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        RedditReaderCollectionView.refreshControl = refreshControl
    }
    
    @objc func refreshData() {
        fetchData()
    }
    
    func fetchData() {
        readers.removeAll()
        ReaderServices.fetchReader { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let reader):
                    self.readers = reader.data.children.map { $0.data }
                    self.RedditReaderCollectionView.reloadData()
//                    print("Title: \(reader.data.children[0].data.title)")
//                    print("Selftext: \(String(describing: reader.data.children[0].data.selftext))")
//                    print("Thumbnail: \(String(describing: reader.data.children[0].data.thumbnail))")
                case .failure(let error):
                    print("Veri alınamadı. Hata: \(error)")
                }
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc func descriptionTapped(_ sender: UITapGestureRecognizer) {
        if let label = sender.view as? UILabel, let details = label.text {
            showAlert(message: details)
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Details", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}

extension RedditReaderVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return readers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "readerCell", for: indexPath) as! RedditReaderCVC
        
        let reader = readers[indexPath.item]
        
        cell.lblTitle.text = reader.title
        
        if let description = reader.selftext {
            cell.lblDescription.text = description
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(descriptionTapped(_:)))
            cell.lblDescription.isUserInteractionEnabled = true
            cell.lblDescription.addGestureRecognizer(tapGestureRecognizer)
        } else {
            cell.lblDescription.text = "Details are not defined."
        }
        
        if let thumbnail = reader.thumbnail, thumbnail == "self" {
            cell.imgThumbnail.isHidden = true
        } else {
            if let imageURL = URL(string: reader.thumbnail ?? "Not Found") {
                cell.imgThumbnail.af.setImage(withURL: imageURL)
                cell.imgThumbnail.isHidden = false
            } else {
                cell.imgThumbnail.isHidden = true
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
