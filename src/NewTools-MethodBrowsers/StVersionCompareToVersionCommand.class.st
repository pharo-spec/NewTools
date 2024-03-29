Class {
	#name : 'StVersionCompareToVersionCommand',
	#superclass : 'StCommand',
	#category : 'NewTools-MethodBrowsers-Commands',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Commands'
}

{ #category : 'accessing' }
StVersionCompareToVersionCommand class >> defaultDescription [

	^ 'Compare selected version to another selected version'
]

{ #category : 'accessing' }
StVersionCompareToVersionCommand class >> defaultName [

	^ 'Compare to version...'
]

{ #category : 'executing' }
StVersionCompareToVersionCommand >> execute [
	
	context doCompareToOtherVersion
]
