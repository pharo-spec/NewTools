Class {
	#name : 'GraphicDebugDelegate',
	#superclass : 'Object',
	#category : 'NewTools-Debugger-View',
	#package : 'NewTools-Debugger',
	#tag : 'View'
}

{ #category : 'ui requests' }
GraphicDebugDelegate >> confirm: message [

	^ UIManager default confirm: message trueChoice: 'Compile and Browse' falseChoice: 'Cancel'
]
