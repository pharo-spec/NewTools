"
A FDDirectoryFilterTest is a test class for testing the behavior of FDDirectoryFilter
"
Class {
	#name : 'StDirectoryFilterTest',
	#superclass : 'StAbstractFilterTest',
	#category : 'NewTools-FileBrowser-Tests-Filtering',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'Filtering'
}

{ #category : 'accessing' }
StDirectoryFilterTest >> actualClass [

	^ StDirectoryFilter
]

{ #category : 'tests' }
StDirectoryFilterTest >> testPredicate [
	self assertCollection: (filter applyOn: root children) hasSameElements: {self dir . self dirExt . self hiddenDir}
]
