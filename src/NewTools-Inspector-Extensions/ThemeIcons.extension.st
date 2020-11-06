Extension { #name : #ThemeIcons }

{ #category : #'*NewTools-Inspector-Extensions' }
ThemeIcons >> inspectionIcons [
	<inspectorPresentationOrder: 10 title: 'Icons'>
	
	^ SpListPresenter new
		items: (icons associations sorted: #key ascending);
		display: [ :each | each key ];
		displayIcon: [ :each | each value ];
		yourself
]
