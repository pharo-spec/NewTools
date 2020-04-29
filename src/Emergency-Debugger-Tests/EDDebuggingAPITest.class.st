Class {
	#name : #EDDebuggingAPITest,
	#superclass : #EDTests,
	#category : #'Emergency-Debugger-Tests'
}

{ #category : #running }
EDDebuggingAPITest >> setUp [
	super setUp
	
]

{ #category : #'tests - context' }
EDDebuggingAPITest >> testContextAt [
	1 to: session stack size do: [ :i | 
		self
			assert: (debugAPI contextAt: i)
			identicalTo: (session stack at: i) ]
]

{ #category : #'tests - context' }
EDDebuggingAPITest >> testMethodAt [
	1 to: session stack size do: [ :i | 
		self
			assert: (debugAPI methodAt: i)
			identicalTo: (session stack at: i) method ]
]

{ #category : #'tests - context' }
EDDebuggingAPITest >> testNodeAt [
	1 to: session stack size do: [ :i | 
		| context |
		context := session stack at: i.
		self
			assert: (debugAPI nodeAt: i)
			identicalTo: (context method sourceNodeForPC: context pc) ]
]

{ #category : #'tests - context' }
EDDebuggingAPITest >> testNodeForContext [
	| context |
	context := session stack first.
	self
		assert: (debugAPI nodeForContext: context)
		identicalTo: (context method sourceNodeForPC: context pc)
]
