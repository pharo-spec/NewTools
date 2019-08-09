Class {
	#name : #SindarinCommand,
	#superclass : #CmCommand,
	#category : #'NewTools-Sindarin-Tools'
}

{ #category : #initialization }
SindarinCommand class >> defaultIconName [
	^self subclassResponsibility 
]

{ #category : #'instance creation' }
SindarinCommand class >> forSpecContext: anObject [
	^ (self forSpecWithIconNamed: self defaultIconName)
		context: anObject;
		yourself
]
