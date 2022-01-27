Extension { #name : #Pragma }

{ #category : #'*NewTools-Inspector-Extensions' }
Pragma >> inspectionSourceCodeMethod [
	<inspectorPresentationOrder: 30 title: 'Method'>

	^ SpCodePresenter new 
		beForMethod: self method;
		text: self method sourceCode;
		yourself
]
