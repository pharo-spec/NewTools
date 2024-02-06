Extension { #name : 'Boolean' }

{ #category : '*NewTools-SettingsBrowser' }
Boolean >> asSettingPresenter: aSettingDeclaration [

	^ (StSettingBooleanPresenterItem on: aSettingDeclaration)
		value: self;
		yourself
]
