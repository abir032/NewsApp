//
//  ViewController.swift
//  MdFahimFaezAbir-30028
//
//  Created by Bjit on 11/1/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tabbar: UITabBarItem!
    @IBOutlet weak var newsCollectionView: UICollectionView!
    var articles = [Article]()
    var newsFromDB = [NewsDB]()
    var indexPath: IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
       // navigationController?.hidesBarsOnTap = true
        //navigationController?.isNavigationBarHidden = true
        userImage.layer.cornerRadius = userImage.bounds.size.width / 2.0
        searchField.layer.cornerRadius = 10
        searchField.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self
        gridView()
        //MARK: - Nib Registration
        let nib  = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Constants.collectionViewNib)
        let nib2 = UINib(nibName: "NewsCollectionViewCell", bundle: nil)
        newsCollectionView.register(nib2, forCellWithReuseIdentifier: Constants.newsCell)
        //apiCaller(url: Constants.allNewsApli, category: "All")
        setSearchBarImage()
        
    }
    
    // MARK: - URL gula vhul ache
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
}
extension ViewController{
    func apiCaller(url: String, category: String){
        NewsDataCollection.sheared.getJson(url: url, completion: { result in
            switch result{
            case .success(let news):
                if let article = news?.articles{
                    self.articles = article
                }
                DispatchQueue.main.async {
                    self.saveToDb(category: category)
                    // self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        })
        
    }
    func saveToDb(category: String){
        var data: NewsData
        for news in articles{
            if let author = news.author, let content = news.content, let newsDescription = news.description , let publishAt = news.publishedAt, let sourceName = news.source?.name, let title = news.title, let url = news.url, let urlToImage = news.urlToImage{
                data = NewsData(author: author, category: category, content: content, newsDescription: newsDescription, publishedAt: publishAt, sourceName: sourceName, title: title, url: url, urlToImage: urlToImage)
                print(data)
                CoreDataDB.shared.savePost(article: data)
                
            }
        }
    }
}
extension ViewController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        ///print("adsfhhd")
        print(searchField.text!)
    }
}
// MARK: - Segue Section
extension ViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.showNews{
            if let showNewsVc = segue.destination as? ShowNewsVc{
                if let row = indexPath?.row{
                    showNewsVc.titleFromVc  = newsFromDB[row].title ?? ""
                    showNewsVc.dateFromVc =  newsFromDB[row].publishedAt ?? ""
                    showNewsVc.categoryFromVc = newsFromDB[row].category ?? ""
                    showNewsVc.imageFromVc = newsFromDB[row].urlToImage ?? ""
                    showNewsVc.descriptionFromVc = newsFromDB[row].newsDescription ?? ""
                    showNewsVc.sourceNameFromVc = newsFromDB[row].sourceName ?? ""
                    showNewsVc.contentFromVc = newsFromDB[row].content ?? ""
                    showNewsVc.authorFromVc = newsFromDB[row].author ?? ""
                    showNewsVc.fullnewsUrl = newsFromDB[row].url ?? ""
                }
            }
        }
    }
}


// MARK: - Collection View

extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == newsCollectionView{
            self.indexPath = indexPath
            performSegue(withIdentifier: Constants.showNews, sender: nil)
        }
        else{
            let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
            cell.uiView.backgroundColor = UIColor(named: "customBlack")
            if let newsDb = CategorySectionHelper.shared.selectCategory(category: Category.categoryList[indexPath.row].categoryName, indexPath: indexPath){
                newsFromDB = newsDb
                newsCollectionView.reloadData()
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == newsCollectionView{
            
        }else{
            if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell{
                cell.uiView.backgroundColor = .white
            }
        }
        
    }
}
extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == newsCollectionView{
            return newsFromDB.count
        }else{
            print(Category.categoryList.count)
            return Category.categoryList.count
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == newsCollectionView{
            let item = newsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.newsCell, for: indexPath) as! NewsCollectionViewCell
            item.title.text = newsFromDB[indexPath.row].title
            if let url = newsFromDB[indexPath.row].urlToImage{
                item.newsImage.sd_setImage(with: URL(string: url))
            }
            item.source.text = newsFromDB[indexPath.row].sourceName
            item.catgory.text = newsFromDB[indexPath.row].category
            item.publishDate.text  = newsFromDB[indexPath.row].publishedAt
            return item
            
        } else{
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionViewNib, for: indexPath) as! CollectionViewCell
            item.imageView.image = UIImage(named: Category.categoryList[indexPath.row].image)
            item.categoryName.text = Category.categoryList[indexPath.row].categoryName
            print(indexPath.row)
            return item
        }
    }
}
extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 80, height: 70)
    }
    func gridView(){
        let insets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        let itemSize  = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1))
        let item =  NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = insets
        let horGroup = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: horGroup, subitems: [item])
        let groupInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        group.contentInsets = groupInsets
        let section  = NSCollectionLayoutSection(group: group)
        let compLayout = UICollectionViewCompositionalLayout(section: section)
        newsCollectionView.collectionViewLayout = compLayout
    }
}




