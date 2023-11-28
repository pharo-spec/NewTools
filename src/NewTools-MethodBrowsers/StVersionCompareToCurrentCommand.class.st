Class {
	#name : 'StVersionCompareToCurrentCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-MethodBrowsers-Versions',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Versions'
}

{ #category : 'accessing' }
StVersionCompareToCurrentCommand class >> defaultDescription [

	^ 'Compare selected version to the current version'
]

{ #category : 'accessing' }
StVersionCompareToCurrentCommand class >> defaultName [

	^ 'Compare to current'
]

{ #category : 'executing' }
StVersionCompareToCurrentCommand >> execute [
	
	context doCompareToCurrentVersion
]
