"
I am the base class for commands to install from the inspector object-centric watchpoints on a variable's readings and writings
"
Class {
	#name : 'StWatchOnAccessCommand',
	#superclass : 'StDebugPointSlotTargetCommand',
	#category : 'NewTools-ObjectCentricDebugPoints',
	#package : 'NewTools-ObjectCentricDebugPoints'
}

{ #category : 'default' }
StWatchOnAccessCommand class >> defaultDescription [

	^ 'Saves values read or written for the selected or any variable'
]

{ #category : 'default' }
StWatchOnAccessCommand class >> defaultIconName [

	^ #smallObjects
]

{ #category : 'default' }
StWatchOnAccessCommand class >> defaultName [ 

	^ 'Watch state access'
]

{ #category : 'executing' }
StWatchOnAccessCommand >> execute [

	^ context watchInspectedObjectAccess
]
