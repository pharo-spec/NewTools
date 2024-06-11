Class {
	#name : 'StVersionRevertCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-MethodBrowsers-Commands',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Commands'
}

{ #category : 'default' }
StVersionRevertCommand class >> defaultDescription [

	^ 'Revert the current method to the selected version'
]

{ #category : 'accessing' }
StVersionRevertCommand class >> defaultName [

	^ 'Revert to selected version'
]

{ #category : 'executing' }
StVersionRevertCommand >> execute [
	
	context doRevert
]
