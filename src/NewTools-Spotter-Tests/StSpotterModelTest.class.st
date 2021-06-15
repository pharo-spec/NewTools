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
