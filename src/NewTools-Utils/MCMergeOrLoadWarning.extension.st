Extension { #name : 'MCMergeOrLoadWarning' }

{ #category : '*NewTools-Utils' }
MCMergeOrLoadWarning >> defaultAction [
	"Without a user to ask (a run without --interactive, like the command line), fail like any warning nobody handles"

	Smalltalk isInteractive ifFalse: [ ^ super defaultAction ].
	^ (StMCMergeOrLoadChoicePresenter newApplication: StPharoApplication current) requestReslutionWithDescription: self messageText
]
