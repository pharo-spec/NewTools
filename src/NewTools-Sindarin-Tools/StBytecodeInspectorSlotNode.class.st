Class {
	#name : 'StBytecodeInspectorSlotNode',
	#superclass : 'StInspectorSlotNode',
	#category : 'NewTools-Sindarin-Tools',
	#package : 'NewTools-Sindarin-Tools'
}

{ #category : 'accessing' }
StBytecodeInspectorSlotNode >> key [
	^ 'rcvr: ' , (self slot index - 1) asString, ' [' , super key , ']'
]
