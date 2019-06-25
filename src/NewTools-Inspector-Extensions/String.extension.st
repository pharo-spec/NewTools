Extension { #name : #String }

{ #category : #'*NewTools-Inspector-Extensions' }
String >> inspectorString [
	<inspectorPresentationOrder: 10>
	
	^ SpTextPresenter new
		title: 'String';
		text: (self truncateWithElipsisTo: 100000);
		yourself
]
