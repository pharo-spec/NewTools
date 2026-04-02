Extension { #name : 'SHStyleElement' }

{ #category : '*NewTools-SettingsBrowser' }
SHStyleElement >> asSettingPresenter: aSettingDeclaration owner: aPresenter [

	^ (aPresenter instantiate: StSettingMultipleDropListPresenterItem on: aSettingDeclaration)
		value: self;
		yourself
]
