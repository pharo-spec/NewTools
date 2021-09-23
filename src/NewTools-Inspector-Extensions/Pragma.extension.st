Extension { #name : #Pragma }

{ #category : #'*NewTools-Inspector-Extensions' }
Pragma >> inspectionSourceCodeMethod [
	<inspectorPresentationOrder: 30 title: 'Method'>

	^ SpCodePresenter new 
		beForBehavior: self methodClass;
		text: self method sourceCode;
		yourself
]
