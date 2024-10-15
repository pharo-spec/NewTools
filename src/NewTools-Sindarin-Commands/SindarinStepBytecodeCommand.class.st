Class {
	#name : 'SindarinStepBytecodeCommand',
	#superclass : 'SindarinCommand',
	#category : 'NewTools-Sindarin-Commands',
	#package : 'NewTools-Sindarin-Commands'
}

{ #category : 'accessing - defaults' }
SindarinStepBytecodeCommand class >> defaultDescription [
	^ 'Step a single bytecode'
]

{ #category : 'accessing - defaults' }
SindarinStepBytecodeCommand class >> defaultIconName [
	^#into 
]

{ #category : 'accessing - defaults' }
SindarinStepBytecodeCommand class >> defaultName [
	^ 'Step Bytecode'
]

{ #category : 'hooks' }
SindarinStepBytecodeCommand >> execute [
	self context stepBytecode
]
