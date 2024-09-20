"
I step the execution from a starting context until the execution comes back to code that executes in a context having the same receiver as the starting context's receiver.
"
Class {
	#name : 'SindarinStepToNextExecutionInObjectCommand',
	#superclass : 'SindarinStepToNextExecutionCommand',
	#category : 'NewTools-Sindarin-Commands',
	#package : 'NewTools-Sindarin-Commands'
}

{ #category : 'accessing - defaults' }
SindarinStepToNextExecutionInObjectCommand class >> defaultDescription [
	^ 'Steps until the execution comes back to code executing in the current receiver.'
]

{ #category : 'accessing - defaults' }
SindarinStepToNextExecutionInObjectCommand class >> defaultName [
	<toolbarExtensionDebugCommand: 50>
	<codeExtensionDebugCommand: 50>
	^ 'To next execution in receiver'
]

{ #category : 'predicates' }
SindarinStepToNextExecutionInObjectCommand >> setConditionValue [

	conditionValue := debugger receiver
]

{ #category : 'predicates' }
SindarinStepToNextExecutionInObjectCommand >> targetCondition [ 
	^debugger receiver ~= conditionValue
]
