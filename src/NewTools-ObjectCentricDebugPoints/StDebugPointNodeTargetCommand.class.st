"
I am the base class for commands to install from the inspector object-centric debug points on an AST node
"
Class {
	#name : 'StDebugPointNodeTargetCommand',
	#superclass : 'StDebugPointCommand',
	#category : 'NewTools-ObjectCentricDebugPoints',
	#package : 'NewTools-ObjectCentricDebugPoints'
}

{ #category : 'testing' }
StDebugPointNodeTargetCommand >> canBeExecuted [

	^ self appliesTo: context
]
