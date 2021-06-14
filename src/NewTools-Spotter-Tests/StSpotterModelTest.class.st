Class {
	#name : #StSpotterModelTest,
	#superclass : #TestCase,
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
	
	200 milliSeconds wait.
	self assert: count equals: 1.
]
