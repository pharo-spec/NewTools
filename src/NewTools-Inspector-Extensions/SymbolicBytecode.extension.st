Extension { #name : #SymbolicBytecode }

{ #category : #'*NewTools-Inspector-Extensions' }
SymbolicBytecode >> inspectionSourceCode [
	<inspectorPresentationOrder: 30 title: 'Source'>
1haltOnce.
	^ SpCodePresenter new 
		beForBehavior: self method methodClass;
		text: self method sourceCode;
		selectionInterval: self sourceInterval;
		yourself
]
