Extension { #name : 'Integer' }

{ #category : '*NewTools-SettingsBrowser' }
Integer >> asSettingPresenter: aSettingDeclaration owner: aPresenter [

	^ (aPresenter instantiate: StSettingNumberPresenterItem on: aSettingDeclaration)
		beInteger;
		value: self;
		yourself
]
