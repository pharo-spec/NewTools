Extension { #name : #ToolShortcutsCategory }

{ #category : #'*NewTools-Spotter' }
ToolShortcutsCategory >> openSpotter [

	<shortcut>

	^ KMKeymap
			shortcut: Character cr shift
			action: [ Smalltalk tools spotter open ]
]
