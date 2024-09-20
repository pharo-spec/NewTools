"
I step the execution from a starting context until the execution comes back to code that executes in the same class as the starting context's receiver's class.
"
Class {
	#name : 'SindarinStepToNextExecutionInClassCommand',
	#superclass : 'SindarinStepToNextExecutionCommand',
	#category : 'NewTools-Sindarin-Commands',
	#package : 'NewTools-Sindarin-Commands'
}

{ #category : 'accessing - defaults' }
SindarinStepToNextExecutionInClassCommand class >> defaultDescription [
	^ 'Steps until the execution comes back to code executing in the current class.'
]

{ #category : 'accessing - defaults' }
SindarinStepToNextExecutionInClassCommand class >> defaultName [
	<toolbarExtensionDebugCommand: 50>
	<codeExtensionDebugCommand: 50>
	^ 'To next execution in class'
]

{ #category : 'predicates' }
SindarinStepToNextExecutionInClassCommand >> setConditionValue [

	conditionValue := debugger receiver class
]

{ #category : 'predicates' }
SindarinStepToNextExecutionInClassCommand >> targetCondition [ 
	^debugger receiver class == conditionValue
]
