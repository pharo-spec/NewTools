Class {
	#name : #StPlaygroundPageTest,
	#superclass : #TestCase,
	#category : #'NewTools-Playground-Tests'
}

{ #category : #'instance creation' }
StPlaygroundPageTest >> newPage [ 

	^ StPlaygroundPage new 
		baseDirectory: FileSystem memory;
		yourself
]

{ #category : #tests }
StPlaygroundPageTest >> testContents [
	| page |
	
	page := self newPage.
	page timeToWait: 10 milliSeconds.
	page contents: 'test'.
	5 milliSeconds wait.
	self assert: page contents isEmpty.
	page contents: 'test 2'.
	self assert: page contents isEmpty.
	20 milliSeconds wait.
	self assert: page contents equals: 'test 2'.

]

{ #category : #tests }
StPlaygroundPageTest >> testDoNotStoreVersionIfEqual [
	| v1 page |
	
	v1 := 'v1'.
	page := self newPage.
	page basicContents: v1.
	page flush.
	"Execute twice with same content"
	page storeVersion.
	
	self deny: page versions isEmpty.
	self assert: page versions size equals: 1
]

{ #category : #tests }
StPlaygroundPageTest >> testFlush [
	| page |
	
	page := self newPage.
	page basicContents: 'test'.

	self assert: page contents isEmpty.
	
	page flush.
	
	self assert: page contents equals: 'test'
		

	
]

{ #category : #tests }
StPlaygroundPageTest >> testStoreVersion [
	| v1 page |
	
	v1 := 'v1'.
	page := self newPage.
	page basicContents: v1.
	page flush.
	self deny: page versions isEmpty.
	self assert: page versions first content equals: v1
]

{ #category : #tests }
StPlaygroundPageTest >> testVersions [
	| v1 v2 v3 page |
	
	v1 := 'v1'.
	v2 := 'v2'.
	v3 := 'v3'.
	
	page := StPlaygroundPage new.
	
	page basicContents: v1.
	page flush.
	
	page basicContents: v2.
	page flush.
	
	page basicContents: v3.
	page flush.
	
	self assert: page versions size equals: 3.
	self assert: page versions first content equals: v1.
	self assert: page versions second content equals: v2.	
	self assert: page versions third content equals: v3
]
