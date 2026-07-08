Extension { #name : 'Float' }

{ #category : '*NewTools-SettingsBrowser' }
Float >> asSettingPresenter: aSettingDeclaration owner: aPresenter [ 

	^ (aPresenter instantiate: StSettingNumberPresenterItem on: aSettingDeclaration)
		beFloat;
		value: self;
		yourself
]
