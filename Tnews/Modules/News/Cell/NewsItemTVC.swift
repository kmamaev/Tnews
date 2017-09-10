import UIKit

class NewsItemTVC: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(withViewModel viewModel: NewsItemVM) {
        titleLabel.text = viewModel.title
        contentLabel.text = viewModel.content
    }
}
