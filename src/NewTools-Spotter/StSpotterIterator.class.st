"
Define an iterator to be used to feed items to spotter
"
Class {
	#name : #StSpotterIterator,
	#superclass : #Object,
	#instVars : [
		'context',
		'items'
	],
	#category : #'NewTools-Spotter-Iterators'
}

{ #category : #accessing }
StSpotterIterator class >> gtIterator [
	^ self new
]

{ #category : #'mimic various enumerating' }
StSpotterIterator >> allSatisfy: aBlock [
	self do: [ :each | (aBlock value: each) ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #'mimic various enumerating' }
StSpotterIterator >> anySatisfy: aBlock [
	self do: [ :each | (aBlock value: each) ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #'mimic collection' }
StSpotterIterator >> asArray [
	^ self items asArray
]

{ #category : #'mimic collection' }
StSpotterIterator >> asOrderedCollection [
	^ self items copy " we must not expose the internal representation ! "
]

{ #category : #'mimic collection' }
StSpotterIterator >> asSet [
	^ self items asSet
]

{ #category : #'mimic various enumerating' }
StSpotterIterator >> collect: aBlock [
	^ self collect: aBlock as: self defaultItemsClass
]

{ #category : #'mimic various enumerating' }
StSpotterIterator >> collect: aBlock as: aCollectionClass [
	| collection |
	collection := self newAs: aCollectionClass.
	self do: [ :each | 
		collection add: (aBlock value: each) ].
	^ collection
]

{ #category : #accessing }
StSpotterIterator >> context [
	^ context
]

{ #category : #accessing }
StSpotterIterator >> context: aContext [
	" we assume that if the context changes, so will the result of the iterator - so we reset the internal collection "
	context := aContext.
	self reset.
]

{ #category : #public }
StSpotterIterator >> cull: aContext [
	self context: aContext
]

{ #category : #'accessing-defaults' }
StSpotterIterator >> defaultItems [
	^ self defaultItemsClass new 
]

{ #category : #'accessing-defaults' }
StSpotterIterator >> defaultItemsClass [
	^ OrderedCollection 
]

{ #category : #'mimic various enumerating' }
StSpotterIterator >> detect: aBlock [
	^ self detect: aBlock ifNone: [ NotFound signalFor: aBlock ]
]

{ #category : #'mimic various enumerating' }
StSpotterIterator >> detect: aBlock ifFound: aBlock2 ifNone: aBlock3 [
	self do: [ :each | aBlock value ifTrue: [ ^ aBlock2 value: each ] ].
	^ aBlock3 value
]

{ #category : #'mimic various enumerating' }
StSpotterIterator >> detect: aBlock ifNone: aBlock2 [
	^ self detect: aBlock ifFound: [ :each | each ] ifNone: aBlock2
]

{ #category : #'mimic enumerating' }
StSpotterIterator >> do: aBlock [
	" the iterator must keep an internal collection of items being iterated. This guarantees that the iteration is not done multiple times in case somebody sends multiple subsequent messages like #size, #items or #first:. This will slightly decrease performance while iterating "
	items 
		ifNotNil: [ 
			items do: aBlock ]
		ifNil: [ 
			items := self defaultItems.
			self itemDo: [ :each | 
				items add: each.
				aBlock value: each ] ]
]

{ #category : #'mimic collection' }
StSpotterIterator >> first: anInteger [
	^ self items copyFrom: 1 to: (self size min: (anInteger max: 0))
]

{ #category : #public }
StSpotterIterator >> gtIterator [
	^ self
]

{ #category : #testing }
StSpotterIterator >> hasDynamicItems [
	^ true
]

{ #category : #'mimic collection' }
StSpotterIterator >> isEmpty [
	^ self items isEmpty
]

{ #category : #'mimic collection' }
StSpotterIterator >> isEmptyOrNil [
	^ self items isEmptyOrNil
]

{ #category : #private }
StSpotterIterator >> itemDo: aBlock [
	self subclassResponsibility
]

{ #category : #private }
StSpotterIterator >> items [
	^ items ifNil: [ 
		items := self defaultItems.
		self itemDo: [ :each | 
			items add: each ] ]
]

{ #category : #private }
StSpotterIterator >> items: anObject [
	items := anObject
]

{ #category : #'mimic collection' }
StSpotterIterator >> last: anInteger [
	^ self items last: (self size min: (anInteger max: 0))
]

{ #category : #private }
StSpotterIterator >> newAs: aCollectionClass [
	^ items 
		ifNil: [ aCollectionClass new ] 
		ifNotNil: [ aCollectionClass new: self size ]
]

{ #category : #'mimic collection' }
StSpotterIterator >> notEmpty [
	^ self isEmpty not
]

{ #category : #'mimic various enumerating' }
StSpotterIterator >> reject: aBlock [
	^ self reject: aBlock as: self defaultItemsClass
]

{ #category : #'mimic various enumerating' }
StSpotterIterator >> reject: aBlock as: aCollectionClass [
	| collection |
	collection := self newAs: aCollectionClass.
	self do: [ :each | 
		(aBlock value: each) 
			ifFalse: [ collection add: each ] ].
	^ collection
]

{ #category : #'mimic various enumerating' }
StSpotterIterator >> reject: aBlock thenCollect: aBlock2 as: aCollectionClass [
	| collection |
	collection := self newAs: aCollectionClass.
	self reject: aBlock thenDo: [ :each | 
		collection add: (aBlock2 value: each) ].
	^ collection
]

{ #category : #'mimic various enumerating' }
StSpotterIterator >> reject: aBlock thenDo: aBlock2 [
	self do: [ :each | 
		(aBlock value: each) 
			ifFalse: [ aBlock2 value: each ] ]
]

{ #category : #initialization }
StSpotterIterator >> reset [
	items := nil.
]

{ #category : #'mimic various enumerating' }
StSpotterIterator >> select: aBlock [
	^ self select: aBlock as: self defaultItemsClass
]

{ #category : #'mimic various enumerating' }
StSpotterIterator >> select: aBlock as: aCollectionClass [
	| collection |
	collection := self newAs: aCollectionClass.
	self do: [ :each | 
		(aBlock value: each) 
			ifTrue: [ collection add: each ] ].
	^ collection
]

{ #category : #'mimic various enumerating' }
StSpotterIterator >> select: aBlock thenCollect: aBlock2 [
	^ self select: aBlock thenCollect: aBlock2 as: self defaultItemsClass
]

{ #category : #'mimic various enumerating' }
StSpotterIterator >> select: aBlock thenCollect: aBlock2 as: aCollectionClass [
	| collection |
	collection := self newAs: aCollectionClass.
	self select: aBlock thenDo: [ :each | 
		collection add: (aBlock2 value: each) ].
	^ collection
]

{ #category : #'mimic various enumerating' }
StSpotterIterator >> select: aBlock thenDo: aBlock2 [
	self do: [ :each | 
		(aBlock value: each) 
			ifTrue: [ aBlock2 value: each ] ]
]

{ #category : #'mimic collection' }
StSpotterIterator >> size [
	^ self items size
]

{ #category : #public }
StSpotterIterator >> stIterator [
	^ self
]

{ #category : #public }
StSpotterIterator >> value [
	^ self items
]

{ #category : #public }
StSpotterIterator >> value: aContext [
	self context: aContext
]

{ #category : #'mimic enumerating' }
StSpotterIterator >> withIndexDo: aBlock [
	| index |
	index := 0.
	self do: [ :each | aBlock cull: each cull: (index := index + 1) ]
]
