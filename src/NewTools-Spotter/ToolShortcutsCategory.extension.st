Extension { #name : 'ToolShortcutsCategory' }

{ #category : '*NewTools-Spotter' }
ToolShortcutsCategory >> openSpotter [

	<shortcut>
	^ KMKeymap shortcut: Character cr shift action: [ :target | 
		  | selection |
		  selection := target selection.
		  (self tools spotter insertsSelection and: [ selection isNotNil ])
			  ifTrue: [ self tools spotter openWithText: selection ]
			  ifFalse: [ self tools spotter open ] ]
]
