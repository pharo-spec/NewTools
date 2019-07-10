Class {
	#name : #StepToNextDoIterationTest,
	#superclass : #StepTest,
	#category : #'NewTools-Debugger-Tests'
}

{ #category : #testing }
StepToNextDoIterationTest >> iterateOnCollection [
	| a |
	a := OrderedCollection new.
	{ 1 . 2 . 3 } do: [ :int | a add: int. a add: int ].
	Point new.
]

{ #category : #testing }
StepToNextDoIterationTest >> testIsValid [
	self settingUpSessionAndProcessAndContextForBlock: [ self iterateOnCollection ].
	session stepInto; stepInto.
	self assert: (StepToNextDoIteration isValidForContext: (session interruptedContext)) not.
	session stepOver; stepInto.
	self assert: (StepToNextDoIteration isValidForContext: (session interruptedContext)) not.
	session stepInto.
	"valid when interrupted context is just about to send the #do: message to a Collection"
	self assert: (StepToNextDoIteration isValidForContext: (session interruptedContext)).
	session stepInto.
	"valid when interrupted context is a context whose selector is #do: and receiver is a Collection"
	self assert: (StepToNextDoIteration isValidForContext: (session interruptedContext)).
	session stepInto; stepInto; stepInto; stepInto.
	"valid when interrupted context is strictly above a context whose selector is #do: and receiver is a Collection"
	self assert: (StepToNextDoIteration isValidForContext: (session interruptedContext)).
]

{ #category : #testing }
StepToNextDoIterationTest >> testNextDoIterationJustAfterSendingDo [
	| node |
	self settingUpSessionAndProcessAndContextForBlock: [ self iterateOnCollection ].
	session stepInto; stepInto.
	session stepOver; stepInto.
	session stepInto; stepInto.
	"interruptedContext is the context of selector #do:"
	self assert: session interruptedContext method selector equals: #do:.
	session stepToNextDoIteration.
	"interruptedContext is now a block context for the do:'s block, valued for the first element of the collection (1)"
	self assert: session interruptedContext method equals: self class >>#iterateOnCollection.
	self assert: session interruptedContext isBlockContext.
	node := self class >>#iterateOnCollection sourceNodeForPC: session interruptedContext pc.
	self assert: node isMessage.
	self assert: node selector equals: #add:.
	self assert: (session interruptedContext tempNamed: #int) equals: 1.
	
]

{ #category : #testing }
StepToNextDoIterationTest >> testNextDoIterationJustBeforeDoContextExists [
	| node |
	self settingUpSessionAndProcessAndContextForBlock: [ self iterateOnCollection ].
	session stepInto; stepInto.
	session stepOver; stepInto.
	session stepInto.
	"interruptedContext is just about to send the #do: message"
	self assert: session interruptedContext method equals: self class >>#iterateOnCollection.
	node := self class >>#iterateOnCollection sourceNodeForPC: session interruptedContext pc.
	self assert: node isMessage.
	self assert: node selector equals: #do:.
	session stepToNextDoIteration.
	"interruptedContext is now a block context for the do:'s block, valued for the first element of the collection (1)"
	self assert: session interruptedContext method equals: self class >>#iterateOnCollection.
	self assert: session interruptedContext isBlockContext.
	node := self class >>#iterateOnCollection sourceNodeForPC: session interruptedContext pc.
	self assert: node isMessage.
	self assert: node selector equals: #add:.
	self assert: (session interruptedContext tempNamed: #int) equals: 1.
	
]

{ #category : #testing }
StepToNextDoIterationTest >> testNextDoIterationMultipleTimes [
	| node |
	self settingUpSessionAndProcessAndContextForBlock: [ self iterateOnCollection ].
	session stepInto; stepInto.
	session stepOver; stepInto.
	session stepInto; stepInto.
	"interruptedContext is the context of selector #do:"
	self assert: session interruptedContext method selector equals: #do:.
	
	session stepToNextDoIteration.
	"interruptedContext is now a block context for the do:'s block, valued for the first element of the collection (1)"
	self assert: session interruptedContext method equals: self class >>#iterateOnCollection.
	self assert: session interruptedContext isBlockContext.
	node := self class >>#iterateOnCollection sourceNodeForPC: session interruptedContext pc.
	self assert: node isMessage.
	self assert: node selector equals: #add:.
	self assert: (session interruptedContext tempNamed: #int) equals: 1.
	
	session stepToNextDoIteration.
	"interruptedContext is now a block context for the do:'s block, valued for the first element of the collection (2)"
	self assert: session interruptedContext method equals: self class >>#iterateOnCollection.
	self assert: session interruptedContext isBlockContext.
	node := self class >>#iterateOnCollection sourceNodeForPC: session interruptedContext pc.
	self assert: node isMessage.
	self assert: node selector equals: #add:.
	self assert: (session interruptedContext tempNamed: #int) equals: 2.
	
	session stepToNextDoIteration.
	"interruptedContext is now a block context for the do:'s block, valued for the first element of the collection (3)"
	self assert: session interruptedContext method equals: self class >>#iterateOnCollection.
	self assert: session interruptedContext isBlockContext.
	node := self class >>#iterateOnCollection sourceNodeForPC: session interruptedContext pc.
	self assert: node isMessage.
	self assert: node selector equals: #add:.
	self assert: (session interruptedContext tempNamed: #int) equals: 3.
	
]

{ #category : #testing }
StepToNextDoIterationTest >> testNextDoIterationOnLastDoIteration [
	| node |
	self settingUpSessionAndProcessAndContextForBlock: [ self iterateOnCollection ].
	session stepInto; stepInto.
	session stepOver; stepInto.
	session stepInto; stepInto.
	"interruptedContext is the context of selector #do:"
	self assert: session interruptedContext method selector equals: #do:.
	session stepToNextDoIteration.
	"interruptedContext is now a block context for the do:'s block, valued for the first element of the collection (1)"
	session stepToNextDoIteration.
	"interruptedContext is now a block context for the do:'s block, valued for the first element of the collection (2)"
	session stepToNextDoIteration.
	"interruptedContext is now a block context for the do:'s block, valued for the first element of the collection (3)"
	session stepToNextDoIteration.
	"the last iteration of the do: was reached. One more stepToNextDoIteration brings the execution to the 'Point new' node of method iterateOnCollection, after the node for the #do: send"
	self assert: session interruptedContext method equals: self class >>#iterateOnCollection.
	self assert: session interruptedContext isBlockContext not.
	node := self class >>#iterateOnCollection sourceNodeForPC: session interruptedContext pc.
	self assert: node isMessage.
	self assert: node selector equals: #new.
	
]
