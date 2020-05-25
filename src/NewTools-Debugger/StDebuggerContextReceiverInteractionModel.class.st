Class {
	#name : #StDebuggerContextReceiverInteractionModel,
	#superclass : #SpCodeObjectInteractionModel,
	#category : #'NewTools-Debugger-Model'
}

{ #category : #accessing }
StDebuggerContextReceiverInteractionModel >> behavior [

	^ self context receiver class
]

{ #category : #accessing }
StDebuggerContextReceiverInteractionModel >> context [

	^ self object
]

{ #category : #accessing }
StDebuggerContextReceiverInteractionModel >> doItContext [

	^ self context receiver
]

{ #category : #accessing }
StDebuggerContextReceiverInteractionModel >> doItReceiver [

	^ self context receiver
]
