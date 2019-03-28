"
Description
--------------------

I represent a Flag. A flag is a call to the method Object>>flag with a specific parameter. 

I save the parameter of the flag (it can be a symbol, a string or an object) and its location (the method it is in).

I am an abstract classes and my subclasses will be diferenciated by their parameter kind.
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	locations:		<aCollection>	A collection of FBLocation
	parameter:		<anObject>		Parameter of the flag. Can be a Symbol, a String or an object.

"
Class {
	#name : #FBFlag,
	#superclass : #Object,
	#instVars : [
		'parameter',
		'locations'
	],
	#classVars : [
		'CaseSensitive'
	],
	#category : #'FlagBrowser-Model'
}

{ #category : #accessing }
FBFlag class >> addNew: aClass for: argument with: rbNodes in: flags [
	self caseSensitive
		ifFalse: [ | insensitiveArgument |
			insensitiveArgument := argument asString asLowercase.
			flags
				detect: [ :flag | flag parameter asString asLowercase = insensitiveArgument and: [ flag parameter class = argument class ] ]
				ifFound: [ :flag | 
					^ flag
						addLocations: (self toLocations: rbNodes);
						insensitiveParameter ] ].

	flags add: (aClass parameter: argument locations: (self toLocations: rbNodes))
]

{ #category : #accessing }
FBFlag class >> allFlags [
	^ self isAbstract ifTrue: [ self allFlagsInSystem ] ifFalse: [ self allInSystem ]
]

{ #category : #accessing }
FBFlag class >> allFlagsInSystem [
	| flagNodes flags |
	flags := OrderedCollection new.
	flagNodes := #flag: senders flatCollect: [ :sender | sender compiledMethod ast allChildren select: [ :child | child isMessage and: [ child selector = #flag: ] ] ].
	(flagNodes groupedBy: [ :node | node arguments first value ])
		keysAndValuesDo: [ :argument :rbNodes | 
			self
				addNew: (self flagClassFor: argument)
				for: argument
				with: rbNodes
				in: flags ].
	^ flags
]

{ #category : #accessing }
FBFlag class >> allInSystem [
	| flagNodes flags |
	self isAbstract ifTrue: [ ^ self error: 'This method can be called only on concrete classes.' ].

	flags := OrderedCollection new.
	flagNodes := #flag: senders flatCollect: [ :sender | sender compiledMethod ast allChildren select: [ :child | child isMessage and: [ child selector = #flag: ] ] ].
	(flagNodes groupedBy: [ :node | node arguments first value ])
		keysAndValuesDo: [ :argument :rbNodes | 
			(FBFlag flagClassFor: argument) = self
				ifTrue: [ self
						addNew: self
						for: argument
						with: rbNodes
						in: flags ] ].
	^ flags
]

{ #category : #accessing }
FBFlag class >> caseSensitive [
	^ CaseSensitive ifNil: [ CaseSensitive := true ]
]

{ #category : #accessing }
FBFlag class >> caseSensitive: anObject [
	CaseSensitive := anObject
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
			FBLocation class: methodNode methodClass selector: methodNode selector interval: node sourceInterval ]
]

{ #category : #adding }
FBFlag >> addLocations: aCollection [
	self locations addAll: aCollection
]

{ #category : #update }
FBFlag >> insensitiveParameter [
	self subclassResponsibility
]

{ #category : #accessing }
FBFlag >> locations [
	^ locations
]

{ #category : #accessing }
FBFlag >> locations: anObject [
	locations := anObject.
	locations do: [ :location | location owner: self ]
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
