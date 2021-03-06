//
//  FilterInterface.swift
//  ConcreteChallenge
//
//  Created by Thiago  Wlasenko Nicolau on 01/11/18.
//  Copyright © 2018 Thiago  Wlasenko Nicolau. All rights reserved.
//

import UIKit

class FilterInterface: UIViewController{
    lazy var manager = FilterManager(self)
    
    @IBOutlet weak var yearPicker: UIPickerView!
    @IBOutlet weak var genrePicker: UIPickerView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    @IBOutlet weak var gifView: UIImageView!
    
    var filterOptions : [Any] = []
    
    var startingYear = 1819
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    func setup() {
        self.filterCollectionView.delegate = self
        self.filterCollectionView.dataSource = self
        
        self.yearPicker.delegate = self
        self.yearPicker.dataSource = self
        self.genrePicker.delegate = self
        self.genrePicker.dataSource = self
        
        self.gifView.loadGif(name: "Logo-animado-1")
        
        self.manager.fetchGenres()
        
    }
 
    @IBAction func addYear(_ sender: Any) {
        self.manager.add(year: self.yearPicker.selectedRow(inComponent: 0) + self.startingYear)
    }
    
    @IBAction func addGenre(_ sender: Any) {
        self.manager.add(genreIndex: self.genrePicker.selectedRow(inComponent: 0))
    }
    
    @IBAction func apply(_ sender: Any) {
        self.manager.saveFilter()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeAll(_ sender: Any) {
        self.manager.removeFilter()
    }
    
}

extension FilterInterface: UICollectionViewDelegate {
    
}

extension FilterInterface: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.manager.numberOfFilterOptions()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as? FilterCell
        
        let filterOption = self.manager.filterOptionIn(index: indexPath.row)
        
        
        var text = ""
        
        if let year = filterOption as? Int {
            text = String(year)
            cell?.set(text: text, year: year, genre: nil)
        }
        
        if let genre = filterOption as? Genre {
            text = genre.name
            cell?.set(text: text, year: nil, genre: genre)
        }
        
        cell?.delegate = self
        
        
        return cell ?? UICollectionViewCell()
    }
    
    
}

extension FilterInterface: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.8, height: collectionView.frame.width * 0.15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.frame.width * 0.05
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.frame.width * 0.05
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionView.frame.width * 0.1, left: collectionView.frame.width * 0.1, bottom: collectionView.frame.width * 0.1, right: collectionView.frame.width * 0.1)
    }
}

extension FilterInterface: FilterCellDelegate {
    func deleteTapped(year: Int?, genre: Genre?) {
        self.manager.delete(year: year, genre: genre)
    }
}

extension FilterInterface: FilterInterfaceProtocol {
    func reload() {
        self.yearPicker.selectRow(199, inComponent: 0, animated: true)
        self.genrePicker.reloadAllComponents()
        
        UIView.animate(withDuration: 0.5) {
            self.filterCollectionView.reloadData()
        }
        
    }
}


extension FilterInterface: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.yearPicker {
            return String(row + self.startingYear)
        } else {
            return self.manager.genreIn(index: row)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.yearPicker {
            return self.manager.numberOfYears()
        } else {
            return self.manager.numberOfGenres()
        }
    }
}

