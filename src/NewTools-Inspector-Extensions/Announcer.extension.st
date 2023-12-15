Extension { #name : 'Announcer' }

{ #category : '*NewTools-Inspector-Extensions' }
Announcer >> hasSubscriptions [
	
	^ self numberOfSubscriptions isZero not
]

{ #category : '*NewTools-Inspector-Extensions' }
Announcer >> inspectionSubscriptions [

	<inspectorPresentationOrder: 0 title: 'Subscriptions'>
	^ registry inspectionSubscriptions
]

{ #category : '*NewTools-Inspector-Extensions' }
Announcer >> inspectionSubscriptionsContext: aContext [ 
	
	aContext active: self hasSubscriptions
]
