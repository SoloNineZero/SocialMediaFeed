import UIKit

final class ShimmerPostCell: UITableViewCell {
    static let reuseIdentifier = "ShimmerPostCell"
    
    private let titleView: ShimmerView = {
        let view = ShimmerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private let bodyView: ShimmerView = {
        let view = ShimmerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private let avatarView: ShimmerView = {
        let view = ShimmerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.backgroundColor = .systemGray5
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
        startAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation() {
        avatarView.startAnimating()
        titleView.startAnimating()
        bodyView.startAnimating()
    }
    
    private func setupSubviews() {
        contentView.addSubview(avatarView)
        contentView.addSubview(titleView)
        contentView.addSubview(bodyView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            avatarView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            avatarView.heightAnchor.constraint(equalToConstant: 50),
            avatarView.widthAnchor.constraint(equalToConstant: 50),
            
            titleView.topAnchor.constraint(equalTo: avatarView.topAnchor),
            titleView.leftAnchor.constraint(equalTo: avatarView.rightAnchor, constant: 16),
            titleView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            titleView.heightAnchor.constraint(equalToConstant: 50),
            
            bodyView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 8),
            bodyView.leftAnchor.constraint(equalTo: titleView.leftAnchor),
            bodyView.rightAnchor.constraint(equalTo: titleView.rightAnchor),
            bodyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            bodyView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
        ])
    }
}
