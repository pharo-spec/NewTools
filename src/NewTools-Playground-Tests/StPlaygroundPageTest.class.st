Class {
	#name : #StPlaygroundPageTest,
	#superclass : #TestCase,
	#category : #'NewTools-Playground-Tests'
}

{ #category : #'instance creation' }
StPlaygroundPageTest >> newPage [ 

	^ StPlaygroundPage new 
		baseDirectory: FileSystem memory;
		timeToWait: 10 milliSeconds;
		yourself
]

{ #category : #tests }
StPlaygroundPageTest >> testContents [
	| page waitMock |
	
	self skipOnPharoCITestingEnvironment.
	
	page := self newPage.
	waitMock := StPlaygroundPageTestMockedWaitable new.
	page timeToWait: waitMock.
	page contents: 'test'.
	self assert: page contents isEmpty.
	page contents: 'test 2'.
	self assert: page contents isEmpty.
	waitMock resume.
	self assert: page contents equals: 'test 2'
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
StPlaygroundPageTest >> testFromReference [
	| memory file page |
	
	memory := FileSystem memory.
	file := memory / 'test.ph'.
	file writeStreamDo: [ :stream | stream << 'TEST'].
	
	page := StPlaygroundPage fromReference: file. 
	self assert: page fileReference equals: file.

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
