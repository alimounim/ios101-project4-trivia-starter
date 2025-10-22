//
//  ViewController.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//  Updated for Project 4 – Networking + Per-question feedback
//

import UIKit

class TriviaViewController: UIViewController {

  @IBOutlet weak var currentQuestionNumberLabel: UILabel!
  @IBOutlet weak var questionContainerView: UIView!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var answerButton0: UIButton!
  @IBOutlet weak var answerButton1: UIButton!
  @IBOutlet weak var answerButton2: UIButton!
  @IBOutlet weak var answerButton3: UIButton!

  private var questions: [TriviaQuestion] = []
  private var currQuestionIndex = 0
  private var numCorrectQuestions = 0
  private let service = TriviaQuestionService()

  override func viewDidLoad() {
    super.viewDidLoad()
    addGradient()
    questionContainerView.layer.cornerRadius = 8.0
    configureButtons()
    fetchAndStartGame()          // ✅ Fetch questions on launch
  }

  // MARK: - Networking

  private func fetchAndStartGame() {
    setLoading(true)
    // You can pass category/difficulty via Params if you add a settings screen later.
    service.fetchQuestions(.init(amount: 5)) { [weak self] result in
      guard let self = self else { return }
      self.setLoading(false)
      switch result {
      case .success(let qs):
        self.questions = qs
        self.currQuestionIndex = 0
        self.numCorrectQuestions = 0
        if qs.isEmpty {
          self.showError("No questions returned. Try again.")
        } else {
          self.updateQuestion(withQuestionIndex: 0)
        }
      case .failure(let e):
        self.showError("Failed to load questions.\n\(e.localizedDescription)")
      }
    }
  }

  // MARK: - UI Updates

  private func configureButtons() {
    [answerButton0, answerButton1, answerButton2, answerButton3].forEach {
      $0?.layer.cornerRadius = 8
      $0?.titleLabel?.numberOfLines = 2
      $0?.isHidden = true
    }
  }

  private func resetButtonStyles() {
    [answerButton0, answerButton1, answerButton2, answerButton3].forEach {
      $0?.isEnabled = true
      $0?.backgroundColor = .systemBlue
      $0?.setTitleColor(.white, for: .normal)
    }
  }

  private func setLoading(_ loading: Bool) {
    questionLabel.text = loading ? "Loading…" : questionLabel.text
    [answerButton0, answerButton1, answerButton2, answerButton3].forEach { $0?.isEnabled = !loading }
  }

  private func updateQuestion(withQuestionIndex questionIndex: Int) {
    guard questions.indices.contains(questionIndex) else { return }
    resetButtonStyles()
    // Hide all, then unhide needed
    [answerButton0, answerButton1, answerButton2, answerButton3].forEach { $0?.isHidden = true }

    currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
    let q = questions[questionIndex]
    questionLabel.text = q.question
    categoryLabel.text = q.category

    let answers = ([q.correctAnswer] + q.incorrectAnswers).shuffled()
    let buttons = [answerButton0, answerButton1, answerButton2, answerButton3]
    for (i, title) in answers.enumerated() where i < buttons.count {
      buttons[i]?.setTitle(title, for: .normal)
      buttons[i]?.isHidden = false
    }
  }

  // MARK: - Flow

  private func handleAnswer(_ answer: String, tappedButton: UIButton) {
    let isCorrect = (answer == questions[currQuestionIndex].correctAnswer)
    if isCorrect { numCorrectQuestions += 1 }

    // ✅ Per-question feedback: color buttons, brief delay, then advance
    [answerButton0, answerButton1, answerButton2, answerButton3].forEach { $0?.isEnabled = false }
    tappedButton.backgroundColor = isCorrect ? .systemGreen : .systemRed

    // Highlight the correct answer if user chose incorrectly
    if !isCorrect {
      [answerButton0, answerButton1, answerButton2, answerButton3]
        .compactMap { $0 }
        .first(where: { $0.currentTitle == questions[currQuestionIndex].correctAnswer })?
        .backgroundColor = .systemGreen
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
      self?.goToNextQuestion()
    }
  }

  private func goToNextQuestion() {
    currQuestionIndex += 1
    guard currQuestionIndex < questions.count else {
      showFinalScore()
      return
    }
    updateQuestion(withQuestionIndex: currQuestionIndex)
  }

  private func showFinalScore() {
    let alert = UIAlertController(
      title: "Game over!",
      message: "Final score: \(numCorrectQuestions)/\(questions.count)",
      preferredStyle: .alert
    )
    let reset = UIAlertAction(title: "Restart (New Set)", style: .default) { [weak self] _ in
      self?.fetchAndStartGame()  // ✅ fetch a different set when restarting
    }
    alert.addAction(reset)
    present(alert, animated: true)
  }

  private func showError(_ message: String) {
    let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
      self?.fetchAndStartGame()
    })
    present(alert, animated: true)
  }

  private func addGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [
      UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
      UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor
    ]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    view.layer.insertSublayer(gradientLayer, at: 0)
  }

  // MARK: - IBActions

  @IBAction func didTapAnswerButton0(_ sender: UIButton) {
    handleAnswer(sender.currentTitle ?? "", tappedButton: sender)
  }

  @IBAction func didTapAnswerButton1(_ sender: UIButton) {
    handleAnswer(sender.currentTitle ?? "", tappedButton: sender)
  }

  @IBAction func didTapAnswerButton2(_ sender: UIButton) {
    handleAnswer(sender.currentTitle ?? "", tappedButton: sender)
  }

  @IBAction func didTapAnswerButton3(_ sender: UIButton) {
    handleAnswer(sender.currentTitle ?? "", tappedButton: sender)
  }
}
