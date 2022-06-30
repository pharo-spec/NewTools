Extension { #name : #ToolShortcutsCategory }

{ #category : #'*NewTools-Spotter' }
ToolShortcutsCategory >> openSpotter [

	<shortcut>

	^ KMKeymap
			shortcut: Character cr shift
			action: [ :target | | selection |
				selection := target selection.
				selection ifNotNil: [ Smalltalk tools spotter openWithText: selection ]
					ifNil: [ Smalltalk tools spotter open ]
				]
]
