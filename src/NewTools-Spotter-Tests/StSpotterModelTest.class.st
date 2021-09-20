Class {
	#name : #StSpotterModelTest,
	#superclass : #StSpotterBaseTest,
	#category : #'NewTools-Spotter-Tests'
}

{ #category : #tests }
StSpotterModelTest >> testAnnounceQueryEndedIsSentOnce [
	| model count |

	count := 0.
	(model := StSpotterModel new)
		whenQueryEndedDo: [ count := count + 1 ].

	[ 
		model processSearch: 'Object' on: StSpotter new.
	] fork.
	
	self waitUntilEnded: model.
	
	self assert: count equals: 1.
]

{ #category : #tests }
StSpotterModelTest >> testSpotterModelShouldWaitToPerformActualSearch [

	| model started |
	model := StSpotterModel new.
	started := false.
	
	model whenQueryStartedDo: [ started := true ].
	
	[ model processSearch: 'Object' on: StSpotter new ] fork.

	self deny: started.
	
	5 timesRepeat: [
		50 milliSeconds wait.
		self deny: started ].
	
	300 milliSeconds wait.
	self assert: started
]
