;; Application Processing Contract
;; Manages construction permit requests and approvals

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-APPLICATION-NOT-FOUND (err u101))
(define-constant ERR-INVALID-STATUS (err u102))
(define-constant ERR-ALREADY-EXISTS (err u103))
(define-constant ERR-INVALID-INPUT (err u104))

;; Data Variables
(define-data-var next-application-id uint u1)

;; Data Maps
(define-map applications
  { application-id: uint }
  {
    applicant: principal,
    project-type: (string-ascii 50),
    property-address: (string-ascii 200),
    project-description: (string-ascii 500),
    estimated-cost: uint,
    status: (string-ascii 20),
    submitted-at: uint,
    reviewed-by: (optional principal),
    reviewed-at: (optional uint),
    notes: (string-ascii 500)
  }
)

(define-map applicant-applications
  { applicant: principal }
  { application-ids: (list 50 uint) }
)

(define-map authorized-reviewers
  { reviewer: principal }
  { authorized: bool }
)

;; Authorization Functions
(define-public (add-authorized-reviewer (reviewer principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (ok (map-set authorized-reviewers { reviewer: reviewer } { authorized: true }))
  )
)

(define-public (remove-authorized-reviewer (reviewer principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (ok (map-set authorized-reviewers { reviewer: reviewer } { authorized: false }))
  )
)

;; Application Management Functions
(define-public (submit-application
  (project-type (string-ascii 50))
  (property-address (string-ascii 200))
  (project-description (string-ascii 500))
  (estimated-cost uint))
  (let
    (
      (application-id (var-get next-application-id))
      (current-applications (default-to { application-ids: (list) }
        (map-get? applicant-applications { applicant: tx-sender })))
    )
    (asserts! (> (len project-type) u0) ERR-INVALID-INPUT)
    (asserts! (> (len property-address) u0) ERR-INVALID-INPUT)
    (asserts! (> estimated-cost u0) ERR-INVALID-INPUT)

    (map-set applications
      { application-id: application-id }
      {
        applicant: tx-sender,
        project-type: project-type,
        property-address: property-address,
        project-description: project-description,
        estimated-cost: estimated-cost,
        status: "submitted",
        submitted-at: block-height,
        reviewed-by: none,
        reviewed-at: none,
        notes: ""
      }
    )

    (map-set applicant-applications
      { applicant: tx-sender }
      { application-ids: (unwrap! (as-max-len?
        (append (get application-ids current-applications) application-id) u50) ERR-INVALID-INPUT) }
    )

    (var-set next-application-id (+ application-id u1))
    (ok application-id)
  )
)

(define-public (review-application
  (application-id uint)
  (new-status (string-ascii 20))
  (notes (string-ascii 500)))
  (let
    (
      (application (unwrap! (map-get? applications { application-id: application-id }) ERR-APPLICATION-NOT-FOUND))
      (reviewer-auth (default-to { authorized: false }
        (map-get? authorized-reviewers { reviewer: tx-sender })))
    )
    (asserts! (get authorized reviewer-auth) ERR-NOT-AUTHORIZED)
    (asserts! (or (is-eq new-status "approved")
                  (is-eq new-status "rejected")
                  (is-eq new-status "pending-review")) ERR-INVALID-STATUS)

    (ok (map-set applications
      { application-id: application-id }
      (merge application {
        status: new-status,
        reviewed-by: (some tx-sender),
        reviewed-at: (some block-height),
        notes: notes
      })
    ))
  )
)

(define-public (update-application-status
  (application-id uint)
  (new-status (string-ascii 20)))
  (let
    (
      (application (unwrap! (map-get? applications { application-id: application-id }) ERR-APPLICATION-NOT-FOUND))
      (reviewer-auth (default-to { authorized: false }
        (map-get? authorized-reviewers { reviewer: tx-sender })))
    )
    (asserts! (get authorized reviewer-auth) ERR-NOT-AUTHORIZED)

    (ok (map-set applications
      { application-id: application-id }
      (merge application { status: new-status })
    ))
  )
)

;; Read-only Functions
(define-read-only (get-application (application-id uint))
  (map-get? applications { application-id: application-id })
)

(define-read-only (get-applicant-applications (applicant principal))
  (map-get? applicant-applications { applicant: applicant })
)

(define-read-only (is-authorized-reviewer (reviewer principal))
  (default-to false (get authorized (map-get? authorized-reviewers { reviewer: reviewer })))
)

(define-read-only (get-next-application-id)
  (var-get next-application-id)
)

(define-read-only (get-application-status (application-id uint))
  (match (map-get? applications { application-id: application-id })
    application (some (get status application))
    none
  )
)
