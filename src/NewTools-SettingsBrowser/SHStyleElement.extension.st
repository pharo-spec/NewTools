Extension { #name : 'SHStyleElement' }

{ #category : '*NewTools-SettingsBrowser' }
SHStyleElement >> asSettingPresenter: aSettingDeclaration owner: aPresenter [

	^ (aPresenter instantiate: StSettingStyleElementPresenterItem on: aSettingDeclaration)
		value: self;
		yourself
]
