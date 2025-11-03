Extension { #name : 'Color' }

{ #category : '*NewTools-Inspector-Extensions' }
Color >> inspectionColor: aBuilder [
	<inspectorPresentationOrder: 10 title: 'Color'>
	
	^ aBuilder newImage  
		image: (Morph new 
			color: self;
			asFormOfSize: 50@50);
		yourself
]

{ #category : '*NewTools-Inspector-Extensions' }
Color class >> inspectionColors: aBuilder [
	<inspectorPresentationOrder: 10 title: 'Registered'>
	
	^ aBuilder newList 
		addStyle: 'stList';
		items: ColorRegistry associations;
		display: [ :each | each key ];
		displayIcon: [ :each | 
			Morph new 
				color: each value;
				asFormOfSize: 20@20 ];
		yourself
]
