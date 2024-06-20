Extension { #name : 'CmdShortcutActivation' }

{ #category : '*NewTools-SettingsBrowser' }
CmdShortcutActivation >> asSettingPresenter: aDeclaration [ 

	^ (StSettingTextPresenterItem on: aDeclaration) 
		value: self keyCombination asString;
		yourself
]
