Extension { #name : #CompiledBlock }

{ #category : #'*NewTools-Inspector-Extensions' }
CompiledBlock >> inspectionSource [
	<inspectorPresentationOrder: 20 title: 'Method Source'>
	
	^ SpCodePresenter new 
		beForMethod: self method;
		text: self sourceCode;
		addTextSegmentDecoration: (SpTextPresenterDecorator forHighlight
			interval: (self sourceNode sourceInterval first to: self sourceNode sourceInterval last + 1);
			yourself);
		contextMenu: (SpMenuPresenter new addGroup: [ :group | group 
			addItem: [ :item | item 
				name: 'Browse method class'; 
				action: [ self methodClass browse ] ] ]);
		whenSubmitDo: [ :text | 
			self isInstalled 
				ifFalse: [ self inform: 'can not edit methods that are not installed' ]
				ifTrue: [ self methodClass compile: text ]];
		yourself
]
