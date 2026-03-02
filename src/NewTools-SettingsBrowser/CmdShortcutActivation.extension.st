Extension { #name : 'CmdShortcutActivation' }

{ #category : '*NewTools-SettingsBrowser' }
CmdShortcutActivation >> asSettingPresenter: aDeclaration owner: aPresenter [

	^ (aPresenter instantiate: StSettingTextPresenterItem on: aDeclaration) 
		value: self keyCombination asString;
		yourself
]
