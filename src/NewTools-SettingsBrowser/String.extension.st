Extension { #name : 'String' }

{ #category : '*NewTools-SettingsBrowser' }
String >> asSettingPresenter: aSettingDeclaration [ 

	^ (StSettingTextPresenterItem on: aSettingDeclaration)
		value: self;
		yourself
]
