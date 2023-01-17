//
//  BookMarkVc.swift
//  MdFahimFaezAbir-30028
//
//  Created by Bjit on 17/1/23.
//

import UIKit

class BookMarkVc: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var categoryCv: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.layer.cornerRadius = 10
        tableView.delegate = self
        tableView.dataSource = self
        categoryCv.delegate = self
        categoryCv.dataSource = self
        let nib = UINib(nibName: "BookMarkVcCategoryCell", bundle: nil)
        categoryCv.register(nib, forCellWithReuseIdentifier: Constants.bookMarkCategoryCell)
        setSearchBarImage()
    }
    func setSearchBarImage(){
        let searchIcon  = UIImageView()
        searchIcon.image = UIImage(systemName: "magnifyingglass")
        let uiView = UIView()
        uiView.addSubview(searchIcon)
        uiView.frame = CGRect(x: 10, y: 0, width: UIImage(systemName: "magnifyingglass")!.size.width+15, height: UIImage(systemName: "magnifyingglass")!.size.height)
        searchIcon.frame = CGRect(x:10, y: 0, width: UIImage(systemName: "magnifyingglass")!.size.width, height: UIImage(systemName: "magnifyingglass")!.size.height)
        searchField.leftView = uiView
        searchField.leftViewMode = .always
        searchField.clearButtonMode = .whileEditing
        searchIcon.tintColor = UIColor.darkGray
        searchField.addTarget(self, action: #selector(searchNews),for: .allEditingEvents)
        //searchField.
    }
    @objc func searchNews(){
        // print(searchField.text!)
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
}
extension BookMarkVc: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(searchField.text!)
    }
}

// MARK: - Table View
extension BookMarkVc: UITableViewDelegate{
    
}
extension BookMarkVc: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.bookMarkCell, for: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
}

// MARK: - Collection View

extension BookMarkVc: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = categoryCv.cellForItem(at: indexPath) as? BookMarkVcCategoryCell{
            cell.uiView.backgroundColor = UIColor(named: "customBlack")
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = categoryCv.cellForItem(at: indexPath) as? BookMarkVcCategoryCell{
            cell.uiView.backgroundColor = .white
        }
    }
}
extension BookMarkVc: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Category.categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = categoryCv.dequeueReusableCell(withReuseIdentifier: Constants.bookMarkCategoryCell, for: indexPath) as! BookMarkVcCategoryCell
            item.image.image = UIImage(named: Category.categoryList[indexPath.row].image)
            item.categoryName.text = Category.categoryList[indexPath.row].categoryName
        return item
        
    }
    
}
extension BookMarkVc: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 70, height: 80)
    }
}
