Extension { #name : 'SHStyleElement' }

{ #category : '*NewTools-SettingsBrowser' }
SHStyleElement >> asSettingPresenter: aSettingDeclaration [ 

	^ (StSettingMultipleDropListPresenterItem on: aSettingDeclaration)
		value: self;
		yourself
]
