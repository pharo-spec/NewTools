Extension { #name : #SpOutputPortProxy }

{ #category : #'*NewTools-Inspector' }
SpOutputPortProxy >> asInspection [

	^ StPresenterInspectionPresenter for: self
]
