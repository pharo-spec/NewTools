Class {
	#name : 'StVersionCompareToCurrentCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-MethodBrowsers-Commands',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Commands'
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
