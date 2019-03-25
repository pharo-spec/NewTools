Class {
	#name : #FBFlag,
	#superclass : #Object,
	#instVars : [
		'parameter',
		'locations'
	],
	#category : #'FlagBrowser-Model'
}

{ #category : #accessing }
FBFlag class >> allFlags [
	^ self isAbstract ifTrue: [ self allFlagsInSystem ] ifFalse: [ self allInSystem ]
]

{ #category : #accessing }
FBFlag class >> allFlagsInSystem [
	| flagNodes flags |
	flags := OrderedCollection new.
	flagNodes := #flag: senders flatCollect: [ :sender | sender compiledMethod ast allChildren select: [ :child | child isMessage and: [ child selector = #flag: ] ] ].
	(flagNodes groupedBy: [ :node | node arguments first value ]) keysAndValuesDo: [ :argument :rbNodes | flags add: ((self flagClassFor: argument) parameter: argument locations: (self toLocations: rbNodes)) ].
	^ flags
]

{ #category : #accessing }
FBFlag class >> allInSystem [
	| flagNodes flags |
	self isAbstract ifTrue: [ ^ self error: 'This method can be called only on concrete classes.' ].

	flags := OrderedCollection new.
	flagNodes := #flag: senders flatCollect: [ :sender | sender compiledMethod ast allChildren select: [ :child | child isMessage and: [ child selector = #flag: ] ] ].
	(flagNodes groupedBy: [ :node | node arguments first value ])
		keysAndValuesDo: [ :argument :rbNodes | (FBFlag flagClassFor: argument) = self ifTrue: [ flags add: (self parameter: argument locations: (self toLocations: rbNodes)) ] ].
	^ flags
]

{ #category : #accessing }
FBFlag class >> flagClassFor: aFlagArgument [
	^ (self allSubclasses sorted: #priority descending) detect: [ :subclass | subclass matchesArgument: aFlagArgument ]
]

{ #category : #testing }
FBFlag class >> isAbstract [
	^ self = FBFlag
]

{ #category : #testing }
FBFlag class >> matchesArgument: aFlagArgument [
	^ self subclassResponsibility
]

{ #category : #'instance creation' }
FBFlag class >> parameter: anArgument locations: aCollectionOfNodes [
	^ self new
		parameter: anArgument;
		locations: aCollectionOfNodes;
		yourself
]

{ #category : #accessing }
FBFlag class >> priority [
	^ self subclassResponsibility
]

{ #category : #accessing }
FBFlag class >> toLocations: aCollectionOfRBNodes [
	^ aCollectionOfRBNodes
		collect: [ :node | 
			| methodNode |
			methodNode := node methodNode.
			FBFlagLocation class: methodNode methodClass selector: methodNode selector ]
]

{ #category : #accessing }
FBFlag >> locations [
	^ locations
]

{ #category : #accessing }
FBFlag >> locations: anObject [
	locations := anObject
]

{ #category : #accessing }
FBFlag >> parameter [
	^ parameter
]

{ #category : #accessing }
FBFlag >> parameter: anObject [
	parameter := anObject
]

{ #category : #printing }
FBFlag >> printOn: aStream [
	super printOn: aStream.

	aStream
		<< $[;
		print: parameter;
		<< $];
		<< $(;
		print: locations size;
		<< $)
]
