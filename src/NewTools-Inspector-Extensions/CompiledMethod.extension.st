Extension { #name : 'CompiledMethod' }

{ #category : '*NewTools-Inspector-Extensions' }
CompiledMethod >> inspectionPragmas [
	<inspectorPresentationOrder: 50 title: 'Pragmas'> 

	^ SpListPresenter new
		items: self pragmas;
		display: [ :aPragma | aPragma printString ];
		yourself
]

{ #category : '*NewTools-Inspector-Extensions' }
CompiledMethod >> inspectionPragmasContext: aContext [ 
	
	aContext active: self hasPragmas
]

{ #category : '*NewTools-Inspector-Extensions' }
CompiledMethod >> inspectionSource [
	<inspectorPresentationOrder: 20 title: 'Method Source'>
	
	^ SpCodePresenter new 
		beForMethod: self method;
		text: self sourceCode;
		actionsWith: [ :group | group 
			addActionWith: [ :action | action
				name: 'Browse method class'; 
				action: [ self methodClass browse ] ] ];
		whenSubmitDo: [ :text | 
			self isInstalled 
				ifFalse: [ UIManager default inform: 'can not edit methods that are not installed' ]
				ifTrue: [ self methodClass compile: text ] ];
		yourself
]
