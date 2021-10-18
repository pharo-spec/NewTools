Extension { #name : #Color }

{ #category : #'*NewTools-Inspector-Extensions' }
Color >> inspectionColor [
	<inspectorPresentationOrder: 10 title: 'Color'>
	
	^ SpImagePresenter new  
		image: (Morph new 
			color: self;
			asFormOfSize: 50@50);
		yourself
]

{ #category : #'*NewTools-Inspector-Extensions' }
Color class >> inspectionColors [
	<inspectorPresentationOrder: 10 title: 'Registered'>
	
	^ SpListPresenter new 
		items: ColorRegistry associations;
		display: [ :each | each key ];
		displayIcon: [ :each | 
			Morph new 
				color: each value;
				asFormOfSize: 20@20 ];
		yourself
]
