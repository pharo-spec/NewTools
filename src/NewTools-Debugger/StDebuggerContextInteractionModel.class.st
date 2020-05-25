Class {
	#name : #StDebuggerContextInteractionModel,
	#superclass : #SpCodeObjectInteractionModel,
	#category : #'NewTools-Debugger-Model'
}

{ #category : #accessing }
StDebuggerContextInteractionModel >> behavior [

	^ self context home receiver class
]

{ #category : #accessing }
StDebuggerContextInteractionModel >> context [

	^ self object
]

{ #category : #accessing }
StDebuggerContextInteractionModel >> doItContext [

	^ self context
]

{ #category : #accessing }
StDebuggerContextInteractionModel >> doItReceiver [

	^ self context home receiver
]
