Class {
	#name : 'StDebuggerExceptionExtensionsTest',
	#superclass : 'TestCase',
	#category : 'NewTools-Debugger-Tests-Model',
	#package : 'NewTools-Debugger-Tests',
	#tag : 'Model'
}

{ #category : 'testing' }
StDebuggerExceptionExtensionsTest >> testContextForMessageNotUnderstoodImplementation [

	| exception dummySession methodCreator |
	[ 1 a ]
		on: Error
		do: [ :e | exception := e freeze ].
	dummySession := StMockSession new.
	dummySession dummyContext: exception signalerContext.
	methodCreator := StDebuggerMethodImplementor forSession: dummySession.
	self
		assert: (exception contextForMethodImplementation: methodCreator)
		identicalTo: exception signalerContext
]

{ #category : 'testing' }
StDebuggerExceptionExtensionsTest >> testContextForSubclassResponsibilityImplementation [

	| exception dummySession methodCreator context |
	dummySession := StMockSession new.
	[ dummySession subclassResponsibilityExample ]
		on: Error
		do: [ :e | exception := e freeze ].

	dummySession dummyContext: exception signalerContext.
	methodCreator := StDebuggerMethodImplementor forSession: dummySession.

	context := exception contextForMethodImplementation: methodCreator.

	self assert: context selector equals: #subclassResponsibilityExample.
	self assert: context receiver identicalTo: dummySession
]

{ #category : 'testing' }
StDebuggerExceptionExtensionsTest >> testMessageNotUnderstoodToImplementInContext [

	| exception |
	[ 1 a ]
		on: Error
		do: [ :e | exception := e freeze ].
	self
		assert: (exception messageToImplementInContext: 'whatever context')
		identicalTo: exception message
]

{ #category : 'testing' }
StDebuggerExceptionExtensionsTest >> testSubclassResponsibilityToImplementInContext [
| exception dummySession  message |
	[ 1 a ]
		on: Error
		do: [ :e | exception := e freeze ].
	dummySession := StMockSession new.
	dummySession dummyContext: exception signalerContext.	

	"We work from a MNU exception, but that is just to get a context, we do not really care that we are testing a subclass resp exception below"
	message := SubclassResponsibility new
		           messageToImplementInContext: exception signalerContext.
	self
		assert: message selector
		equals: exception signalerContext selector.
	self
		assert: message arguments
		equals: exception signalerContext arguments
]
