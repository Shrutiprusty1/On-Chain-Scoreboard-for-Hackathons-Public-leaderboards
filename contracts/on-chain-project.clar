;; On-Chain Scoreboard for Hackathons

;; Store scores mapped by participant
(define-map scores principal uint)

;; Track highest score and its owner
(define-data-var top-scorer principal tx-sender)
(define-data-var top-score uint u0)

;; Error codes
(define-constant err-invalid-score (err u100))

;; Function 1: Submit or update participant's score
(define-public (submit-score (participant principal) (score uint))
  (begin
    (asserts! (> score u0) err-invalid-score)
    (map-set scores participant score)
    (let ((current-top (var-get top-score)))
      (if (> score current-top)
          (begin
            (var-set top-score score)
            (var-set top-scorer participant)
            (ok true)) ;; return response from `if`
          (ok true))   ;; same return type in else
    )))

;; Function 2: View the current top scorer and score
(define-read-only (get-top-scorer)
  (ok {
    winner: (var-get top-scorer),
    score: (var-get top-score)
  }))
