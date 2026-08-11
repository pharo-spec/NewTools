"
I wrap a World menu entry, to modify its behavior if required for the spotter
"
Class {
	#name : 'StWorldMenuEntry',
	#superclass : 'StEntry',
	#category : 'NewTools-Pulse-Entries',
	#package : 'NewTools-Pulse',
	#tag : 'Entries'
}

{ #category : 'comparing' }
StWorldMenuEntry >> = anEntry [

	^ self species = anEntry species
		and: [ anEntry asString = self asString ]
]

{ #category : 'accessing' }
StWorldMenuEntry >> categoryLabel [

	^ 'menu'
]

{ #category : 'printing' }
StWorldMenuEntry >> displayStringOn: aStream [

	aStream << content contents
]

{ #category : 'evaluating' }
StWorldMenuEntry >> doEvaluate [ 

	content stActDefault
]

{ #category : 'accessing' }
StWorldMenuEntry >> iconName [
	"content is already a morph with an icon"
	^ nil
]

{ #category : 'accessing' }
StWorldMenuEntry >> iconOn: anApplication [

	"world menu intries are morphic elements that already contain an icon"

	^ content icon
]
