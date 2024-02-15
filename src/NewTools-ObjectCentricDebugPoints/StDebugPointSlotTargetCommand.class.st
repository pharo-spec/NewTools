"
I am the base class for commands to install from the inspector object-centric debug points on a variable
"
Class {
	#name : 'StDebugPointSlotTargetCommand',
	#superclass : 'StDebugPointCommand',
	#category : 'NewTools-ObjectCentricDebugPoints',
	#package : 'NewTools-ObjectCentricDebugPoints'
}

{ #category : 'testing' }
StDebugPointSlotTargetCommand >> canBeExecuted [

	^ context enableSlotMenuEntries
]
