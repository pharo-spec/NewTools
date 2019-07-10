Class {
	#name : #StepSkipTest,
	#superclass : #StepTest,
	#instVars : [
		'instanceVariable'
	],
	#category : #'NewTools-Debugger-Tests'
}

{ #category : #tests }
StepSkipTest >> doNothing [
]

{ #category : #tests }
StepSkipTest >> incrementInstanceVariable [
	instanceVariable := instanceVariable + 1
]

{ #category : #tests }
StepSkipTest >> testIsValid [
	"StepSkip is valid on message sends"
	self settingUpSessionAndProcessAndContextForBlock: [ self incrementInstanceVariable ].
	session stepInto.
	self assert: (StepSkip isValidForDebugSession: session).
	
	"StepSkip is valid on assignments"
	self settingUpSessionAndProcessAndContextForBlock: [ instanceVariable := 1 ].
	session stepInto.
	self assert: (StepSkip isValidForDebugSession: session).
	
]

{ #category : #tests }
StepSkipTest >> testSkipAssignment [
	| temporaryVariable |
	temporaryVariable := 0.
	"The #doNothing is there so that the assignment is not the only instruction. This way this test also checks that the value stack of the context is left in a good state (i.e. has a placeholder value for the result of the assignment)"
	self settingUpSessionAndProcessAndContextForBlock: [ temporaryVariable := 1. self doNothing. ].
	session stepInto.
	"Checking that the execution is about to perform the assignment"
	self assert: self currentNode isAssignment.
	self assert: self currentNode variable name equals: #temporaryVariable.
	session stepSkip.
	self assert: self currentNode isMessage.
	self assert: self currentNode selector equals: #doNothing.
	"The value of temporaryVariable is still 0, meaning the execution indeed skipped the temporaryVariable:=1 assignment"
	self assert: temporaryVariable equals: 0.
	
]

{ #category : #tests }
StepSkipTest >> testSkipMessage [
	instanceVariable := 0.
		"The #doNothing is there so that the message send is not the only instruction. This way this test also checks that the value stack of the context is left in a good state (i.e. has a placeholder value for the result of the message send)"
	self settingUpSessionAndProcessAndContextForBlock: [ self incrementInstanceVariable. self doNothing ].
	session stepInto.
	self assert: self currentNode isMessage.
	self assert: self currentNode selector equals: #incrementInstanceVariable.
	session stepSkip.
	self assert: self currentNode isMessage.
	self assert: self currentNode selector equals: #doNothing.
	"The value of instanceVariable is still 0, meaning the execution indeed skipped the #incrementInstanceVariable message send"
	self assert: instanceVariable equals: 0.
	
]
