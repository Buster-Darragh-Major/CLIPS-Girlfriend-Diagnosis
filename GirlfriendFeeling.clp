; TODO: Bind 'else' operations to anything
; Determine whether girlfreind is with you right now
(defrule withGirlfriend
	=>
	(printout t "Are you with your girlfriend right now? (1-yes, 0-no)" crlf)
	(bind ?x (read))
	(if (= ?x 1)
		then (assert (withGirlfriend yes))
		else (assert (withGirlfriend no))
	)
)

; Ask how girlfriends day is - only execute if with girlfriend
(defrule askedHowDayIs (withGirlfriend yes)
	=>
	(printout t "Have you asked how her day is? (1-yes, 0-no)" crlf)
	(bind ?x (read))
	(if (= ?x 1)
		then (assert (askedHowDayIs yes))
		else (printout t "Inconclusive. Anything could be going on." crlf)
	)
)

; Ask how long discussion was - only execute if asked how day is
(defrule discussionLength (askedHowDayIs yes)
	=>
	(printout t "How long was the discussion? (0-less than a second, 1-less than or equal to three hours, 2-over three hours" crlf)
	(bind ?x (read))
	(if (= ?x 0)
		then (printout t "You've done something and its bad. Be very careful from here." crlf)
		else (if (= ?x 1)
			then (assert (discussionLength average))
			else (printout t "You might have just been broken up with, investigate further." crlf)
		)
	)
)

; Ask whether ther was ever an utterance of "we eed to talk" in conversation,
; only ask if there has been a discussion of average length