Class {
	#name : #OCBreakpointCommand,
	#superclass : #CmCommand,
	#category : #'NewTools-ObjectCentricBreakpoints'
}

{ #category : #deafult }
OCBreakpointCommand class >> defaultIconName [
	^#smallDebug	
]

{ #category : #'instance creation' }
OCBreakpointCommand class >> forSpec [ 
	^self forSpecWithIconNamed: self defaultIconName
]
