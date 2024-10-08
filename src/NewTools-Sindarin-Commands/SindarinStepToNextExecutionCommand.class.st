Class {
	#name : 'SindarinStepToNextExecutionCommand',
	#superclass : 'SindarinCommand',
	#instVars : [
		'debugger',
		'conditionValue'
	],
	#category : 'NewTools-Sindarin-Commands',
	#package : 'NewTools-Sindarin-Commands'
}

{ #category : 'accessing - defaults' }
SindarinStepToNextExecutionCommand class >> defaultIconName [
	^ #into
]

{ #category : 'hooks' }
SindarinStepToNextExecutionCommand >> execute [

	| callingMethod maxDepth depth |
	self debuggerPresenter debuggerActionModel preventUpdatesDuring: [ 
		debugger := self context sindarinDebugger.
		self setConditionValue.
		callingMethod := debugger method.
		debugger step.

		maxDepth := 1000.
		depth := 0.
		[ 
		debugger method ~= callingMethod and: [ 
			depth < maxDepth and: [ self targetCondition not] ] ] whileTrue: [ 
			debugger step.
			depth := depth + 1.
			debugger hasSignalledUnhandledException ifTrue: [ depth := 1000 ] ] ].
]

{ #category : 'hooks' }
SindarinStepToNextExecutionCommand >> setConditionValue [

	^ self subclassResponsibility
]

{ #category : 'hooks' }
SindarinStepToNextExecutionCommand >> targetCondition [

	^ self subclassResponsibility
]
