"
I will step the execution from a context until the next call to the same object as that context's receiver.
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
