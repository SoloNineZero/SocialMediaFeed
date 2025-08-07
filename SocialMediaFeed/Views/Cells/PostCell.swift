import UIKit

final class PostCell: UITableViewCell {
    static let reuseIdentifier = "PostCell"
    
    private var currentAvatarURL: URL?
        
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var avatarImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 25
        image.tintColor = .systemGray3
        return image
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func configure(post: PostWithAuthor) {
        titleLabel.text = post.title
        bodyLabel.text = post.body
        authorLabel.text = post.author
        avatarImage.image = UIImage(systemName: "person.crop.circle")
        currentAvatarURL = post.avatar
        
        ImageLoaderService.load(from: post.avatar) { [weak self] image in
            guard let self = self else { return }
            if let image = image {
                self.avatarImage.image = image
            } else {
                print("Аватарка не установлена")
            }
        }
    }
    
    private func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(avatarImage)
        contentView.addSubview(favoriteButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            avatarImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            avatarImage.heightAnchor.constraint(equalToConstant: 50),
            avatarImage.widthAnchor.constraint(equalToConstant: 50),
            
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            favoriteButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leftAnchor.constraint(equalTo: avatarImage.rightAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: favoriteButton.leftAnchor, constant: -16),
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            bodyLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            bodyLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            
            authorLabel.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 12),
            authorLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            authorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
