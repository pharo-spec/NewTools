Extension { #name : #DoubleLinkedList }

{ #category : #'*NewTools-Spotter' }
DoubleLinkedList >> stNoneSatisfy: aBlock [
	"Evaluate aBlock with the elements of the receiver. If aBlock returns false for all elements return true. Otherwise return false"

	self do: [:item | (aBlock value: item) ifTrue: [^ false]].
	^ true
]

{ #category : #'*NewTools-Spotter' }
DoubleLinkedList >> stRemoveCycledLink: link [
	| predecessor successor |
	predecessor := link previousLink.
	successor := link nextLink.
	predecessor
		ifNil: [ head := successor ]
		ifNotNil: [ predecessor nextLink: successor ].
	successor
		ifNil: [ tail := predecessor ]
		ifNotNil: [ successor previousLink: predecessor ].
	link clearLinks.
	
	"I'm the only one left, clear linked list and return"
	(link = head & (link = tail)) ifTrue: [ head := nil. tail := nil. ^ link ].
	
	link = head ifTrue: [ head := successor ].
	link = tail ifTrue: [ tail := predecessor ].
	
	^ link
]

{ #category : #'*NewTools-Spotter' }
DoubleLinkedList >> stTail [

	^ tail
]
