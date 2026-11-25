Extension { #name : 'ToolShortcutsCategory' }

{ #category : '*NewTools-SettingsBrowser' }
ToolShortcutsCategory >> openSettings [
	<shortcut>
	
	^ KMKeymap 
		shortcut: PharoShortcuts current openSettingsShortcut 
		action: [ (StSettingsBrowser newApplication: StPharoApplication current) open ]
]
