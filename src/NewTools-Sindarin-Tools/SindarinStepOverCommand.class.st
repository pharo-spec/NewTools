Class {
	#name : #SindarinStepOverCommand,
	#superclass : #SindarinCommand,
	#category : #'NewTools-Sindarin-Tools'
}

{ #category : #default }
SindarinStepOverCommand class >> defaultDescription [
	^ 'Step over'
]

{ #category : #initialization }
SindarinStepOverCommand class >> defaultIconName [
	^#glamorousOver
]

{ #category : #default }
SindarinStepOverCommand class >> defaultName [
	^ 'Step Over'
]

{ #category : #hooks }
SindarinStepOverCommand >> execute [
	self context model stepOver.
	self context refresh.
]
