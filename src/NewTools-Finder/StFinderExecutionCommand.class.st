"
Abstract class to group execution behavior for example results.

"
Class {
	#name : 'StFinderExecutionCommand',
	#superclass : 'StFinderCommand',
	#category : 'NewTools-Finder-Commands',
	#package : 'NewTools-Finder',
	#tag : 'Commands'
}

{ #category : 'testing' }
StFinderExecutionCommand >> canBeExecuted [ 

	^ super canBeExecuted and: [ self selectedItems ~= 0 and: [ self selectedItem isExampleResult ] ]
]
