Extension { #name : #String }

{ #category : #'*NewTools-Inspector-Extensions' }
String >> inspectionFullString [
	<inspectorPresentationOrder: 100 title: 'Full Content'>

	^ SpTextPresenter new
		text: self;
		yourself
]

{ #category : #'*NewTools-Inspector-Extensions' }
String >> inspectionString [
	<inspectorPresentationOrder: -10 title: 'Preview'>
	
	^ SpTextPresenter new
		text: (self truncateWithElipsisTo: 1000);
		yourself
]
