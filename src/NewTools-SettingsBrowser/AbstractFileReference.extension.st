Extension { #name : 'AbstractFileReference' }

{ #category : '*NewTools-SettingsBrowser' }
AbstractFileReference >> asSettingPresenter: aSettingDeclaration [ 

	^ (StSettingTextPresenterItem on: aSettingDeclaration)
		value: self;
		yourself
]
