"
I am the base class for commands to install from the inspector object-centric watchpoints on a variable's readings
"
Class {
	#name : 'StWatchOnReadCommand',
	#superclass : 'StDebugPointSlotTargetCommand',
	#category : 'NewTools-ObjectCentricDebugPoints',
	#package : 'NewTools-ObjectCentricDebugPoints'
}

{ #category : 'default' }
StWatchOnReadCommand class >> defaultDescription [

	^ 'Saves values read for the selected or any variable'
]

{ #category : 'default' }
StWatchOnReadCommand class >> defaultIconName [

	^ #smallObjects
]

{ #category : 'default' }
StWatchOnReadCommand class >> defaultName [ 

	^ 'Watch read'
]

{ #category : 'executing' }
StWatchOnReadCommand >> execute [

	^ context watchInspectedObjectRead
]
