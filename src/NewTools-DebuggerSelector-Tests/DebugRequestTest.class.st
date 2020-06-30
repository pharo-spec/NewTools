"
A DebugRequestTest is a test class for testing the behavior of DebugRequest
"
Class {
	#name : #DebugRequestTest,
	#superclass : #TestCase,
	#category : #'NewTools-DebuggerSelector-Tests-Core'
}

{ #category : #tests }
DebugRequestTest >> testCreationFromException [
	| error dr |
	[ self error ] on: Error do: [ :e | error := e].
	dr := DebugRequest newForException: error.
	self assert: dr exception identicalTo: error.
	self assert: dr process identicalTo: dr defaultProcess
]

{ #category : #tests }
DebugRequestTest >> testDebugSession [
	| error dr ds |
	[ self error ] on: Error do: [ :e | error := e].
	dr := DebugRequest newForException: error.
	ds := dr debugSession.
	self assert: ds interruptedContext identicalTo: error signalerContext.
	self assert: ds interruptedProcess identicalTo: dr process.
	self assert: ds exception identicalTo: error.
]

{ #category : #tests }
DebugRequestTest >> testDefaultProcess [
	| dr |
	dr := DebugRequest basicNew.
	self assert: dr process identicalTo: Processor activeProcess
	
]

{ #category : #tests }
DebugRequestTest >> testNewNotAllowed [
	self should: [ DebugRequest new ] raise: ShouldNotImplement
]

{ #category : #tests }
DebugRequestTest >> testNoPreDebugActionsBeforeComputation [
	| dr |
	dr := DebugRequest basicNew.
	self assert: dr preDebugActions isEmpty
]

{ #category : #tests }
DebugRequestTest >> testNullExceptionForNamed [
	| context name nullException |
	context := thisContext.
	name := 'testName'.
	nullException := DebugRequest basicNew nullExceptionFor: context named: name.
	self assert: nullException signalerContext identicalTo: context.
	self assert: nullException messageText equals: name.
]

{ #category : #tests }
DebugRequestTest >> testPreDebugActionForDebugItMethod [
	| dr |
	dr := DebugRequest basicNew.
	dr compiledMethod: DebugRequestTest>>#testPreDebugActionForDebugItMethod.
	dr computePreDebugActions.
	self assert: dr preDebugActions isNotEmpty
]
