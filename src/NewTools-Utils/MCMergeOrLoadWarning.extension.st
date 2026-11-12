Extension { #name : 'MCMergeOrLoadWarning' }

{ #category : '*NewTools-Utils' }
MCMergeOrLoadWarning >> defaultAction [
	"Without a user to ask (a run without --interactive, like the command line), fail like any warning nobody handles.
	Workaround: this asks the global Smalltalk whether the image is interactive. The application this warning opens its dialog in (StPharoApplication) should know whether it can ask the user, without referencing Smalltalk"

	Smalltalk isInteractive ifFalse: [ ^ super defaultAction ].
	^ (StMCMergeOrLoadChoicePresenter newApplication: StPharoApplication current) requestReslutionWithDescription: self messageText
]
