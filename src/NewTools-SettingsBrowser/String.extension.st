Extension { #name : 'String' }

{ #category : '*NewTools-SettingsBrowser' }
String >> asSettingPresenter: aSettingDeclaration owner: aPresenter [

	^ (aPresenter instantiate: StSettingTextPresenterItem on: aSettingDeclaration)
		  value: self;
		  yourself
]
