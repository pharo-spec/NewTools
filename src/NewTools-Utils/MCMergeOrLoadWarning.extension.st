Extension { #name : 'MCMergeOrLoadWarning' }

{ #category : '*NewTools-Utils' }
MCMergeOrLoadWarning >> defaultAction [

	^ (StMCMergeOrLoadChoicePresenter newApplication: StPharoApplication current) requestReslutionWithDescription: self messageText
]
