Class {
	#name : #StPlaygroundPageTest,
	#superclass : #TestCase,
	#category : #'NewTools-Playground-Tests'
}

{ #category : #tests }
StPlaygroundPageTest >> testContents [
	| page |
	
	page := StPlaygroundPage new.
	page baseDirectory: FileSystem memory.
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
StPlaygroundPageTest >> testFlush [
	| page |
	
	page := StPlaygroundPage new.
	page baseDirectory: FileSystem memory.
	page basicContents: 'test'.

	self assert: page contents isEmpty.
	
	page flush.
	
	self assert: page contents equals: 'test'
		

	
]
