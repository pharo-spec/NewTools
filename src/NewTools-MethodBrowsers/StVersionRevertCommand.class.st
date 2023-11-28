Class {
	#name : 'StVersionRevertCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-MethodBrowsers-Versions',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Versions'
}

{ #category : 'accessing' }
StVersionRevertCommand class >> defaultDescription [

	^ 'Compare selected version to the current version'
]

{ #category : 'accessing' }
StVersionRevertCommand class >> defaultName [

	^ 'Revert to selected version'
]

{ #category : 'executing' }
StVersionRevertCommand >> execute [
	
	context doRevert
]
