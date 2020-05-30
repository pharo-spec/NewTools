"
A FBFlagTest is a test class for testing the behavior of FBFlag
"
Class {
	#name : #FBFlagTest,
	#superclass : #TestCase,
	#instVars : [
		'flag'
	],
	#category : #'NewTools-FlagBrowser-Tests-Base'
}

{ #category : #testing }
FBFlagTest class >> isAbstract [
	^ self = FBFlagTest
]

{ #category : #testing }
FBFlagTest class >> shouldInheritSelectors [
	^ true
]

{ #category : #accessing }
FBFlagTest >> actualClass [
	^ self subclassResponsibility
]

{ #category : #helpers }
FBFlagTest >> defaultParameter [
	^ self subclassResponsibility
]

{ #category : #helpers }
FBFlagTest >> insensitiveParameter [
	^ self subclassResponsibility
]

{ #category : #helpers }
FBFlagTest >> randomLocation [
	^ FBLocation class: self class selector: #randomLocation interval: (18 to: 90)
]

{ #category : #running }
FBFlagTest >> setUp [
	super setUp.
	flag := self actualClass new.
	flag parameter: self defaultParameter.
	flag locations: {self randomLocation} asOrderedCollection
]

{ #category : #tests }
FBFlagTest >> testAddLocations [
	self assert: flag locations size equals: 1.
	flag addLocations: {(FBLocation class: self class selector: #testAddLocations interval: (18 to: 90))}.
	self assert: flag locations size equals: 2
]

{ #category : #tests }
FBFlagTest >> testFlagClassFor [
	self assert: (FBFlag flagClassFor: self defaultParameter) equals: self actualClass
]

{ #category : #tests }
FBFlagTest >> testInsensitiveParameter [
	self assert: flag parameter equals: self defaultParameter.
	flag insensitiveParameter.
	self assert: flag parameter equals: self insensitiveParameter
]
