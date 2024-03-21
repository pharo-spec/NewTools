"
I am the base class for commands to install from the inspector object-centric breakpoints on a variable's readings and writings
"
Class {
	#name : 'StBreakOnAccessCommand',
	#superclass : 'StDebugPointSlotTargetCommand',
	#category : 'NewTools-ObjectCentricDebugPoints',
	#package : 'NewTools-ObjectCentricDebugPoints'
}

{ #category : 'default' }
StBreakOnAccessCommand class >> defaultDescription [

	^ 'Breaks when the selected or any variable is read or written'
]

{ #category : 'default' }
StBreakOnAccessCommand class >> defaultIconName [

	^ #smallObjects
]

{ #category : 'default' }
StBreakOnAccessCommand class >> defaultName [ 

	^ 'Break on state access'
]

{ #category : 'executing' }
StBreakOnAccessCommand >> execute [

	^ context breakInspectedObjectOnAccess
]
