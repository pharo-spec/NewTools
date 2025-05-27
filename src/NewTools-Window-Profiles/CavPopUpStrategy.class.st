"
I'm a strategy that don't open a new window, I check if the window associated with the placeholder is present, and put it on top of all the windows in the world.
"
Class {
	#name : 'CavPopUpStrategy',
	#superclass : 'CavWindowStrategy',
	#category : 'NewTools-Window-Profiles-Model',
	#package : 'NewTools-Window-Profiles',
	#tag : 'Model'
}

{ #category : 'accessing' }
CavPopUpStrategy class >> title [

	^ 'Pop Up on the Top Strategy'
]

{ #category : 'finding/searching' }
CavPopUpStrategy >> findSameKindWindowAs: aWidget [

	^ World submorphs
		  detect: [ :each |
				  each isSystemWindow and: [
						  each model notNil and: [
								  (each model presenter
									   ifNotNil: [ each model presenter class = aWidget class ]
									   ifNil: [ each model class = aWidget class ]) and: [
									  each ~= aWidget ] ] ] ]
		  ifNone: [ ^ nil ]
]

{ #category : 'positioning' }
CavPopUpStrategy >> placePresenter: aWindow [

	| sameKindWindow windowToDelete |
	aWindow position: placeHolder position.
	aWindow extent: placeHolder extent.

	sameKindWindow := self findSameKindWindowAs: aWindow.
	windowToDelete := (aWindow isKindOf: SystemWindow)
		                  ifTrue: [ aWindow ]
		                  ifFalse: [ aWindow owner ].

	sameKindWindow ifNotNil: [
			sameKindWindow activate.
			windowToDelete visible: false.
			windowToDelete delete ]
]
