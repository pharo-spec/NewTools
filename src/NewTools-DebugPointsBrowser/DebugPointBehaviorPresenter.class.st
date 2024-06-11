"
I am the superclass of UI elements of debug point behaviors.

By setting the expand property a subclass can decide if the element should be expanding automatically when it is used in the DebugPointEditor.
"
Class {
	#name : 'DebugPointBehaviorPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'behavior',
		'debugPoint',
		'checkBox'
	],
	#category : 'NewTools-DebugPointsBrowser',
	#package : 'NewTools-DebugPointsBrowser'
}

{ #category : 'accessing' }
DebugPointBehaviorPresenter >> behavior [
	^behavior
]

{ #category : 'accessing' }
DebugPointBehaviorPresenter >> behavior: aBehavior [
	behavior := aBehavior 
]

{ #category : 'accessing' }
DebugPointBehaviorPresenter >> debugPoint [ 
	^debugPoint 
]

{ #category : 'accessing' }
DebugPointBehaviorPresenter >> debugPoint: aDebugPoint [
	debugPoint := aDebugPoint 
]

{ #category : 'expanding-collapsing' }
DebugPointBehaviorPresenter >> expand [
	^false
]
