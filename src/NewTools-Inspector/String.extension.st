Extension { #name : #String }

{ #category : #'*NewTools-Inspector' }
String >> inspectorString [
	<inspectorPresentationOrder: 10>
	
	^ TextPresenter new
		title: 'String';
		text: (self truncateWithElipsisTo: 100000);
		yourself
]
