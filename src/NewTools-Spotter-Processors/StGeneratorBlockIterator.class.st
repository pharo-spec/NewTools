"
I wrap a block and expose it as an iterator
"
Class {
	#name : 'StGeneratorBlockIterator',
	#superclass : 'StGenericGenerator',
	#instVars : [
		'block'
	],
	#category : 'NewTools-Spotter-Processors-Iterators',
	#package : 'NewTools-Spotter-Processors',
	#tag : 'Iterators'
}

{ #category : 'instance creation' }
StGeneratorBlockIterator class >> on: aBlock [

	^ self basicNew
		block: aBlock;
		initialize;
		yourself
]

{ #category : 'accessing' }
StGeneratorBlockIterator >> block [
	^ block
]

{ #category : 'accessing' }
StGeneratorBlockIterator >> block: anObject [
	block := anObject
]

{ #category : 'enumerating' }
StGeneratorBlockIterator >> elementsDo: aValuable [

	block value: aValuable
]
