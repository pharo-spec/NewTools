"
Abstract class grouping behavior for Finder tool operations. 
It is based in the Commander frameworks.

"
Class {
	#name : 'StFinderCommand',
	#superclass : 'CmCommand',
	#category : 'NewTools-Finder-Commands',
	#package : 'NewTools-Finder',
	#tag : 'Commands'
}

{ #category : 'accessing' }
StFinderCommand >> application [

	^ self context application
]

{ #category : 'accessing' }
StFinderCommand >> applicationClass [

	^ self application class
]

{ #category : 'testing' }
StFinderCommand >> canBeExecuted [
	"See superimplementor's comment"

	^ self resultTreeItems notEmpty
]

{ #category : 'accessing' }
StFinderCommand >> resultTree [

	^ 	self context resultTree.
]

{ #category : 'accessing' }
StFinderCommand >> resultTreeItems [
	"Answer a <Collection> of finder results, each one an instance of a <StFinderResult> subclass"
	
	^ self resultTree roots
]

{ #category : 'accessing' }
StFinderCommand >> selectedItem [
	"Answer the currently selected <StFinderResult>. Valid for operations on a single selection"
	
	^ self resultTree selectedItem
]

{ #category : 'accessing' }
StFinderCommand >> selectedItems [
	"Answer a <Collection> of <StFinderResult> if there are selections, otherwise answer an empty collection"
	
	^ self resultTree selectedItems
]
