import UIKit
import SDWebImage

class ShowNewsVc: UIViewController {

  
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var sourceName: UILabel!
    @IBOutlet weak var contentView: UILabel!
  
    @IBOutlet weak var descriptionView: UILabel!
    
    @IBOutlet weak var date: UILabel!
    var categoryFromVc = ""
    var titleFromVc = ""
    var authorFromVc = ""
    var imageFromVc = ""
    var sourceNameFromVc = ""
    var contentFromVc = ""
    var descriptionFromVc = ""
    var dateFromVc = ""
    var fullnewsUrl = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.isNavigationBarHidden = true
        category.text = categoryFromVc
        newsTitle.text = titleFromVc
        author.text = authorFromVc
       
        image.sd_setImage(with: URL(string: imageFromVc))
       sourceName.text = sourceNameFromVc
      descriptionView.text = descriptionFromVc
      contentView.text = contentFromVc
        
        date.text = dateFromVc
//        image.layer.cornerRadius = 0
//        print(contentFromVc)
//        print(descriptionFromVc)
        // Do any additional setup after loading the view.
    }
    @IBAction func addToBookmark(_ sender: Any) {
        print("Added")
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true)
    }
    

    @IBAction func showFullNewsAction(_ sender: Any) {
        performSegue(withIdentifier: Constants.showWebView, sender: nil)
//        if let url = URL(string: fullnewsUrl){
//            UIApplication.shared.open(url)
//        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.showWebView{
            if let webView = segue.destination as? WebView {
                webView.url = fullnewsUrl
            }
        }
    }
    
}
