//
//  PhotoSelectorController.swift
//  ClickAndShare
//
//  Created by Madhusudhan B.R on 7/12/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import Photos
import CoreImage

class PhotoSelectorController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cell"
    let headerID = "header"
    var images = [UIImage]()
    var selectedImage : UIImage?
    var assets = [PHAsset]()
    //var nextButtonTapped = false
    
    var CIFilterNames = [
        
        "CISepiaTone"
    ]
    
    let imageToFilter : UIImageView = {
       let iv = UIImageView()
       // iv.backgroundColor = UIColor.orange
        
        return iv
    }()
    
    let scrollView : UIScrollView = {
        let sv = UIScrollView()
      sv.backgroundColor = UIColor.yellow
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        collectionView?.backgroundColor = .white
        collectionView?.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
        
        fetchPhotos()
    }
    
    func fetchPhotos(){
        let options =  PHFetchOptions()
        //options.fetchLimit = 3
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        options.sortDescriptors = [sortDescriptor]
        let allPhotos = PHAsset.fetchAssets(with: .image, options:options )
        
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects({ (asset, count, stop) in
                
                let imageManager = PHImageManager()
                let size = CGSize(width: 200, height: 200)
                let imageRequestOptions = PHImageRequestOptions()
                imageRequestOptions.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: imageRequestOptions, resultHandler: { (image, info) in
                    
                    if let image = image {
                        self.images.append(image)
                        self.assets.append(asset)
                        
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                    }
                    
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                        
                    }
                    
                })
            })
        }
        
       
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedImage = images[indexPath.row]
         self.collectionView?.reloadData()
        let scrollIndex = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: scrollIndex, at: .bottom, animated: true )
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PhotoSelectorCell
            cell.imageView.image = images[indexPath.item]
        
        
        return cell
    }
    
    var header : PhotoSelectorHeader?
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! PhotoSelectorHeader
        if let selectedImage = self.selectedImage {
        let index = images.index(of: selectedImage)
            let asset = assets[index!]
            self.header = cell 
            let imageManager = PHImageManager.default()
            imageManager.requestImage(for: asset, targetSize: CGSize(width: 600, height: 600), contentMode: .aspectFill, options: nil, resultHandler: { (image, info) in
                
                if let renderedImage = image {
                    cell.selectedImageView.image = renderedImage
                }
                
            })
            
        }
        
        return cell
    }
    
    fileprivate func setupNavBar(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
     }
    
    func handleCancel() {
        dismiss(animated: true , completion: nil)
    }
    
    func handleNext() {
       
        let shareController = ShareController()
        shareController.selectedImage = header?.selectedImageView.image 
        navigationController?.pushViewController(shareController, animated: true) 
        
        
    }
    
//    func filterButtonTapped(sender: UIButton) {
//        let button = sender as UIButton
//        
//        imageToFilter.image = button.backgroundImage(for: .normal)
//    }
    
//    nextButtonTapped = true
//    collectionView?.reloadData()
//    collectionView?.addSubview(imageToFilter)
//    imageToFilter.anchor(top: navigationController?.navigationBar.bottomAnchor, left: collectionView?.leftAnchor, bottom: nil, right: collectionView?.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: view.frame.width)
//    collectionView?.addSubview(scrollView)
//    scrollView.anchor(top: nil, left: collectionView?.leftAnchor, bottom: view.bottomAnchor, right: collectionView?.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -20, paddingRight: 0, width: 0, height: 80)
//    
//    var xCoord: CGFloat = 5 + scrollView.frame.origin.x
//    let yCoord: CGFloat = 5 + scrollView.frame.origin.y
//    let buttonWidth:CGFloat = 70
//    let buttonHeight: CGFloat = 70
//    let gapBetweenButtons: CGFloat = 5
//    
//    var itemCount = 0
//    
//    for i in 0..<CIFilterNames.count {
//    itemCount = i
//    
//    // Button properties
//    let filterButton = UIButton(type: .custom)
//    filterButton.backgroundColor = .black
//    filterButton.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
//    filterButton.tag = itemCount
//    //filterButton.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .TouchUpInside)
//    filterButton.addTarget(self, action: #selector(filterButtonTapped(sender:)), for: .touchUpInside)
//    filterButton.layer.cornerRadius = 6
//    filterButton.clipsToBounds = true
//    filterButton.imageView?.contentMode = .scaleAspectFit
//    // CODE FOR FILTERS WILL BE ADDED HERE...
//    // Create filters for each button
//    let ciContext = CIContext()
//    let coreImage = CIImage(image: selectedImage!)
//    let filter = CIFilter(name: "\(CIFilterNames[i])" )
//    filter!.setValue(0.8, forKey: kCIInputIntensityKey)
//    filter!.setValue(coreImage, forKey: kCIInputImageKey)
//    let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
//    let result = filter!.outputImage
//    //let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
//    let filteredImageaRef = ciContext.createCGImage(result!, from: (result?.extent)!)
//    imageToFilter.image = UIImage(cgImage: filteredImageaRef!)
//    filterButton.imageView?.image = UIImage(cgImage: filteredImageaRef!)
//    
//    // Add Buttons in the Scroll View
//    xCoord +=  buttonWidth + gapBetweenButtons
//    scrollView.addSubview(filterButton)
//    } // END FOR LOOP
//    
//    
//    // Resize Scroll View
//    scrollView.contentSize = CGSize(width: buttonWidth * CGFloat(itemCount+2),height: yCoord)
}

