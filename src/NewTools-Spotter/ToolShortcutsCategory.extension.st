Extension { #name : #ToolShortcutsCategory }

{ #category : #'*NewTools-Spotter' }
ToolShortcutsCategory >> openSpotter [

	<shortcut>
	^ KMKeymap shortcut: Character cr shift action: [ :target | 
		  | selection |
		  selection := target selection.
		  selection
			  ifNotNil: [ self tools spotter openWithText: selection ]
			  ifNil: [ self tools spotter open ] ]
]
