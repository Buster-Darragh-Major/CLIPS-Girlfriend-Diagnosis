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
	(printout t "How long was the discussion? (0-less than a second, 1-less than or equal to three hours, 2-over three hours)" crlf)
	(bind ?x (read))
	(if (= ?x 0)
		then (printout t "You've done something and its bad. Be very careful from here." crlf)
		else (if (= ?x 1)
			then (assert (weNeedToTalkEnter yes))
			else (assert (investigateNode yes))
		)
	)
)

; Shared leaf node for displaying they may have just been broken up with
(defrule investigateNode (investigateNode yes)
	=>
	(printout t "You might have just been broken up with, investigate further." crlf)
)

; Ask whether there was ever an utterance of "we need to talk" in conversation,
; only ask if there has been a discussion of average length
(defrule weNeedToTalk (weNeedToTalkEnter yes)
	=>
	(printout t "Was there ever an utterance of \"We need to talk.\"? (1-yes, 0-no)" crlf)
	(bind ?x (read))
	(if (= ?x 1)
		then (assert (weNeedToTalk yes))
		else (printout t "It sounds like you have a really healthy relationship, keep a healthy level of communication going" crlf)
	)
)

; Ask whether girlfriend explicity said "Im breaking up with you" - only 
; ask if there was an utterance of "we need to talk"
(defrule imBreakingUp (weNeedToTalk yes)
	=>
	(printout t "Did she follow it up with \"I'm breaking up with you\"? (1-yes, 0,no)" crlf)
	(bind ?x (read))
	(if (= ?x 1)
		then (printout t "You just got broken up with." crlf)
		else (printout t "You're on thin ice! Sounds like you have some unresolved issues with communication, try talk more!" crlf)
	)
)

; Ask whether you have been in contact with your girlfriend today - only
; ask if they are NOT with their girlfriend right now.
(defrule beenInContact (withGirlfriend no)
	=>
	(printout t "Have you been in contact today? (1-yes, 0-no)" crlf)
	(bind ?x (read))
	(if (= ?x 1)
		then (assert (lastMessageEnter yes))
		else (assert (beenInContact no))
	)
)

; Ask whether the girlfriends last message was in length - only ask if
; you HAVE been in contact today.
(defrule lastMessage (lastMessageEnter yes)
	=>
	(printout t "Her last message to you was: (0-greater that seven sentances, 1-three to seven sentences, 2-one to two sentences, 3-less than one sentance)" crlf)
	(bind ?x (read))
	(if (= ?x 0)
		then (assert (investigateNode yes))
	) (if (= ?x 1)
		then (printout t "You're in the good books! Keep doing what you're doing" crlf)
	) (if (= ?x 2)
		then (assert (weNeedToTalkEnter yes))
		else (assert (lastMessage lessOne))
	)
)

; Ask whether the message contained any emojis - only ask if their last message was less
; than one sentences
(defrule anyEmojis (lastMessage lessOne)
	=>
	(printout t "Any Emojis? (1-yes, 0-no)" crlf)
	(bind ?x (read))
	(if (= ?x 1)
		then (printout t "Nothing to be worried about! Emoji's are scientifically proven to indicate happiness." crlf)
		else (printout t "It sounds like something might be up, initiate a healthy dialogue to see if she's okay :)" crlf)
	)
)

; Ask whether they have plans together - only ask if thay havent been in contact today."
(defrule anyPlans (beenInContact no)
	=>
	(printout t "You two have plans? (0-Today, 1-Next few days, 2-More that a few days away, 3-None)" crlf)
	(bind ?x (read))
	(if (= ?x 0)
		then (assert (lastMessageEnter yes))
	) (if (= ?x 1)
		then (assert (flickMessageNode yes))
	) (if (= ?x 2)
		then (assert (outLastFewDaysEnter yes))
		else (assert (askNowNode yes))
	)
)

; Shared leaf node for flicking girlfriend a message
(defrule flickMessage (flickMessageNode yes)
	=>
	(printout t "Flick her a message and let her know you're thinking about her :)")
)

; Ask whether they have been out in the last few days - only ask if thay have plans a
; few days away.
(defrule outLastFewDays (outLastFewDaysEnter yes)
	=>
	(printout t "Have you been out in the last few days? (1-yes, 0-no)" crlf )
	(bind ?x (read))
	(if (= ?x 1)
		then (assert (flickMessageNode yes))
		else (assert (askNowNode yes))
	)
)

; Shared leaf node for asking girlfriend out right now
(defrule askNow (askNowNode yes)
	=>
	(printout t "Ask her out right now buddy or prepare for a breakup!" crlf)
)