//
//  ViewController.swift
//  DragAndDrop - Swift API
//
//  Created by Prashant G on 6/30/18.
//  Copyright © 2018 MyOrg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var vehiclesCollectionView: UICollectionView!
    
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    @IBOutlet weak var fourthImageView: UIImageView!
    @IBOutlet weak var fifthImageView: UIImageView!
    
    var selectedFinger = 0
    var items : [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        items = [#imageLiteral(resourceName: "bicycle.png"),#imageLiteral(resourceName: "bike.png"),#imageLiteral(resourceName: "bus.png"),#imageLiteral(resourceName: "car.png"),#imageLiteral(resourceName: "truck.png")]
        
        self.setDragAndDropSettings()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setDragAndDropSettings(){
        let dragInteraction1 = UIDragInteraction(delegate: self)
        dragInteraction1.isEnabled = true
        
        let dragInteraction2 = UIDragInteraction(delegate: self)
        dragInteraction2.isEnabled = true
        
        let dragInteraction3 = UIDragInteraction(delegate: self)
        dragInteraction3.isEnabled = true
        
        let dragInteraction4 = UIDragInteraction(delegate: self)
        dragInteraction4.isEnabled = true
        
        let dragInteraction5 = UIDragInteraction(delegate: self)
        dragInteraction5.isEnabled = true
        
        let dropInteraction1 = UIDropInteraction(delegate: self)
        let dropInteraction2 = UIDropInteraction(delegate: self)
        let dropInteraction3 = UIDropInteraction(delegate: self)
        let dropInteraction4 = UIDropInteraction(delegate: self)
        let dropInteraction5 = UIDropInteraction(delegate: self)
        
        vehiclesCollectionView.dragDelegate = self
        vehiclesCollectionView.dragInteractionEnabled = true
        
        firstImageView.isUserInteractionEnabled = true
        secondImageView.isUserInteractionEnabled = true
        thirdImageView.isUserInteractionEnabled = true
        fourthImageView.isUserInteractionEnabled = true
        fifthImageView.isUserInteractionEnabled = true
        
        self.view.isUserInteractionEnabled = true
//        subView.isUserInteractionEnabled = true
//        imageView.isUserInteractionEnabled = true
        
        //Add Drop interaction for DropImageView
        firstImageView.addInteraction(dropInteraction1)
        secondImageView.addInteraction(dropInteraction2)
        thirdImageView.addInteraction(dropInteraction3)
        fourthImageView.addInteraction(dropInteraction4)
        fifthImageView.addInteraction(dropInteraction5)
    }

}

extension ViewController : UIDropInteractionDelegate{
    //To Highlight whether the dragging item can drop in the specific area
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let location = session.location(in: self.view)
        let dropOperation: UIDropOperation?
        if session.canLoadObjects(ofClass: UIImage.self) {
            if  firstImageView.frame.contains(location) {
                dropOperation = .copy
                selectedFinger = 1
            } else if  secondImageView.frame.contains(location) {
                dropOperation = .copy
                selectedFinger = 2
                
            } else if  thirdImageView.frame.contains(location) {
                dropOperation = .copy
                selectedFinger = 3
                
            } else if  fourthImageView.frame.contains(location) {
                dropOperation = .copy
                selectedFinger = 4
                
            } else if  fifthImageView.frame.contains(location) {
                dropOperation = .copy
                selectedFinger = 5
                
            } else {
                dropOperation = .cancel
                selectedFinger = 0
            }
        } else {
            dropOperation = .cancel
            selectedFinger = 0
        }
        return UIDropProposal(operation: dropOperation!)
    }
    
    //Drop the drag item and handle accordingly
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        if session.canLoadObjects(ofClass: UIImage.self) {
            session.loadObjects(ofClass: UIImage.self) { (items) in
                if let images = items as? [UIImage] {
                    switch self.selectedFinger{
                        
                    case 1 :
                        self.firstImageView.image = images.last
                        break
                        
                    case 2 :
                        self.secondImageView.image = images.last
                        break
                        
                    case 3 :
                        self.thirdImageView.image = images.last
                        break
                        
                    case 4 :
                        self.fourthImageView.image = images.last
                        break
                        
                    case 5 :
                        self.fifthImageView.image = images.last
                        break
                        
                    default:
                        print("exit")
                    }
                    
                }
            }
        }
        
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnd session: UIDropSession){
        
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnter session: UIDropSession){
        
    }
    
    
    
}

extension ViewController : UIDragInteractionDelegate{
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        if let imageView = interaction.view as? UIImageView{
            guard let image = imageView.image else {return []}
            let provider = NSItemProvider(object: image)
            let item = UIDragItem.init(itemProvider: provider)
            return[item]
        }
        return []
    }
}

extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDragDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as! VehiclesCollectionViewCell
        cell.vehicleImageView.image = items[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]
    {
        let item = self.items[indexPath.row]
        let itemProvider = NSItemProvider(object: item as UIImage)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        selectedFinger = indexPath.row + 1
        return [dragItem]
    }
}
