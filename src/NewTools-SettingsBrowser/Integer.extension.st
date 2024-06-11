Extension { #name : 'Integer' }

{ #category : '*NewTools-SettingsBrowser' }
Integer >> asSettingPresenter: aSettingDeclaration [ 

	^ (StSettingNumberPresenterItem on: aSettingDeclaration)
		beInteger;
		value: self;
		yourself
]
