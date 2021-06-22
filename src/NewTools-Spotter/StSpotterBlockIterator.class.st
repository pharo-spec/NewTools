"
Define an iterator on a block to be used to feed items to spotter.
A block receives the `StSpotterBlockIterator>>#onDo:` event, to call when iterating on an element.
"
Class {
	#name : #StSpotterBlockIterator,
	#superclass : #StSpotterIterator,
	#instVars : [
		'onDo'
	],
	#category : #'NewTools-Spotter-Iterators'
}

{ #category : #private }
StSpotterBlockIterator >> itemDo: aBlock [ 
	self onDo 
		cull: aBlock
		cull: self context 
]

{ #category : #accessing }
StSpotterBlockIterator >> onDo [
	^ onDo ifNil: [ onDo := [ :anItemBlock :aContext | " do nothing " ] ]
]

{ #category : #accessing }
StSpotterBlockIterator >> onDo: anObject [
	onDo := anObject
]
