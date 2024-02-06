Extension { #name : 'Float' }

{ #category : '*NewTools-SettingsBrowser' }
Float >> asSettingPresenter: aSettingDeclaration [ 

	^ (StSettingNumberPresenterItem on: aSettingDeclaration)
		beFloat;
		value: self;
		yourself
]
