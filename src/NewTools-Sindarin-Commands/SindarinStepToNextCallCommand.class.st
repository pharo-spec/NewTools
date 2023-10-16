Class {
	#name : 'SindarinStepToNextCallCommand',
	#superclass : 'SindarinCommand',
	#instVars : [
		'debugger',
		'conditionValue'
	],
	#category : 'NewTools-Sindarin-Commands',
	#package : 'NewTools-Sindarin-Commands'
}

{ #category : 'accessing - defaults' }
SindarinStepToNextCallCommand class >> defaultIconName [
	^ #glamorousInto
]

{ #category : 'hooks' }
SindarinStepToNextCallCommand >> execute [

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
			depth < maxDepth and: [ self targetCondition ] ] ] whileTrue: [ 
			debugger step.
			depth := depth + 1.
			debugger hasSignalledUnhandledException ifTrue: [ depth := 1000 ] ] ].
]

{ #category : 'hooks' }
SindarinStepToNextCallCommand >> setConditionValue [

	^ self subclassResponsibility
]

{ #category : 'hooks' }
SindarinStepToNextCallCommand >> targetCondition [

	^ self subclassResponsibility
]
