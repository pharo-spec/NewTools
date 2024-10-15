Class {
	#name : 'SindarinStepOverCommand',
	#superclass : 'SindarinCommand',
	#category : 'NewTools-Sindarin-Commands',
	#package : 'NewTools-Sindarin-Commands'
}

{ #category : 'accessing - defaults' }
SindarinStepOverCommand class >> defaultDescription [
	^ 'Step over'
]

{ #category : 'accessing - defaults' }
SindarinStepOverCommand class >> defaultIconName [
	^#over
]

{ #category : 'accessing - defaults' }
SindarinStepOverCommand class >> defaultName [
	^ 'Step Over'
]

{ #category : 'hooks' }
SindarinStepOverCommand >> execute [
	self context model stepOver.
	self context refresh.
]
