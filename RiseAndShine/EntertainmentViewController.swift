//
//  EntertainmentViewController.swift
//  Rise & Shine
//
//  TreeHacks 2019
//  https://treehacks.com
//

import UIKit

class EntertainmentViewController: UIViewController {

    @IBOutlet private weak var countdownLabel: UILabel!
    @IBOutlet private weak var xkcdImageView: UIImageView!
    @IBOutlet private weak var xkcdTitleLable: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load all the components displayed on the screen
        setupCountdown(until: "2019-02-18")
        setupXKCD()
    }

    // Display a countdown of the number of days until the passed in date
    private func setupCountdown(until targetDateString: String) {
        // Set up the format the date should be in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.init(identifier: .gregorian)

        // Find the difference between target date and today and display in label
        let targetDate: Date! = dateFormatter.date(from: targetDateString)
        let todayDate: Date! = Date()
        let dateString = DateFormatter.localizedString(from: targetDate, dateStyle: .short, timeStyle: .none)
        if let numDays = calendar.dateComponents([.day], from: todayDate, to: targetDate).day {
            self.countdownLabel.text = "Days until \(dateString): \(numDays)"
        }
    }

    // Displays the most current xkcd comic in an image view
    private func setupXKCD() {
        guard let url = URL(string: "http://xkcd.com/info.0.json") else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {(data, reponse, error) in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                    guard let imageLink = jsonResult["img"] as? String, let title = jsonResult["title"] as? String,
                        let url = URL(string: imageLink), let imageData = try? Data(contentsOf: url) else { return }

                    DispatchQueue.main.async(execute: {
                        self.xkcdTitleLable.text = title;
                        self.xkcdImageView.image = UIImage(data: imageData)
                    })
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
}
