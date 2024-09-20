"
I will step the execution from a context until the next call to the same class as that context's receiver's class.
"
Class {
	#name : 'SindarinStepToNextCallInClassCommand',
	#superclass : 'SindarinStepToNextCallCommand',
	#category : 'NewTools-Sindarin-Commands',
	#package : 'NewTools-Sindarin-Commands'
}

{ #category : 'accessing - defaults' }
SindarinStepToNextCallInClassCommand class >> defaultDescription [
	^ 'Steps until the execution comes back to code executing in the current class.'
]

{ #category : 'accessing - defaults' }
SindarinStepToNextCallInClassCommand class >> defaultName [
	<toolbarExtensionDebugCommand: 50>
	<codeExtensionDebugCommand: 50>
	^ 'To next execution in class'
]

{ #category : 'predicates' }
SindarinStepToNextCallInClassCommand >> setConditionValue [

	conditionValue := debugger receiver class
]

{ #category : 'predicates' }
SindarinStepToNextCallInClassCommand >> targetCondition [ 
	^debugger receiver class ~= conditionValue
]
