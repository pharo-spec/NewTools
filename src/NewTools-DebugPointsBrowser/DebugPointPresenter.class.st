"
I am the superclass for UI elements for subclasses of DebugPoint.
"
Class {
	#name : 'DebugPointPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'debugPoint'
	],
	#category : 'NewTools-DebugPointsBrowser',
	#package : 'NewTools-DebugPointsBrowser'
}

{ #category : 'accessing' }
DebugPointPresenter >> debugPoint [ 
	^debugPoint 
]

{ #category : 'accessing' }
DebugPointPresenter >> debugPoint: aDebugPoint [
	debugPoint := aDebugPoint 
]
