"
Saves a given debugging script to a Sindarin script class.
"
Class {
	#name : 'SindarinSaveScriptCommand',
	#superclass : 'SindarinCommand',
	#category : 'NewTools-Sindarin-Commands',
	#package : 'NewTools-Sindarin-Commands'
}

{ #category : 'accessing - defaults' }
SindarinSaveScriptCommand class >> defaultDescription [
	^'Save the current debugging script'
]

{ #category : 'accessing - defaults' }
SindarinSaveScriptCommand class >> defaultIconName [
	^#smallSave
]

{ #category : 'accessing - defaults' }
SindarinSaveScriptCommand class >> defaultName [
	^'Save script'
]

{ #category : 'executing' }
SindarinSaveScriptCommand >> execute [
	self context saveScript
]
