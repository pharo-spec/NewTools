Class {
	#name : #SindarinStepCommand,
	#superclass : #SindarinCommand,
	#category : #'NewTools-Sindarin-Tools'
}

{ #category : #default }
SindarinStepCommand class >> defaultDescription [
	^ 'Step in'
]

{ #category : #initialization }
SindarinStepCommand class >> defaultIconName [
	^#glamorousInto
]

{ #category : #default }
SindarinStepCommand class >> defaultName [
	^ 'Step'
]

{ #category : #hooks }
SindarinStepCommand >> execute [
	self context model step.
	self context refresh.
]
