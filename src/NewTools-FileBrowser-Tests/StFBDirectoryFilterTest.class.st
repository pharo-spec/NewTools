"
A FDDirectoryFilterTest is a test class for testing the behavior of FDDirectoryFilter
"
Class {
	#name : 'StFBDirectoryFilterTest',
	#superclass : 'StFBAbstractFilterTest',
	#category : 'NewTools-FileBrowser-Tests-Filtering',
	#package : 'NewTools-FileBrowser-Tests',
	#tag : 'Filtering'
}

{ #category : 'accessing' }
StFBDirectoryFilterTest >> actualClass [
	^ StFBDirectoryFilter
]

{ #category : 'tests' }
StFBDirectoryFilterTest >> testPredicate [
	self assertCollection: (filter applyOn: root children) hasSameElements: {self dir . self dirExt . self hiddenDir}
]
