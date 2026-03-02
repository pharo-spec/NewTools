Extension { #name : 'String' }

{ #category : '*NewTools-SettingsBrowser' }
String >> asSettingPresenter: aSettingDeclaration owner: aPresenter [

	^ (StSettingTextPresenterItem on: aSettingDeclaration)
		value: self;
		yourself
]
