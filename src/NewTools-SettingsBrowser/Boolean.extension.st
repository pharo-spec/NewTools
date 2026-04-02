Extension { #name : 'Boolean' }

{ #category : '*NewTools-SettingsBrowser' }
Boolean >> asSettingPresenter: aSettingDeclaration owner: aPresenter [

	^ (aPresenter instantiate: StSettingBooleanPresenterItem on: aSettingDeclaration)
		value: self;
		yourself
]
