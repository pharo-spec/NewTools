Class {
	#name : #WarningDebugRequest,
	#superclass : #DebugRequest,
	#category : #'NewTools-DebuggerSelector-Core'
}

{ #category : #submit }
WarningDebugRequest >> submit [
	DebuggerSystem new handleWarningDebugRequest: self
]
