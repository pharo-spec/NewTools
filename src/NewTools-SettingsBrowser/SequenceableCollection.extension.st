Extension { #name : 'SequenceableCollection' }

{ #category : '*NewTools-SettingsBrowser' }
SequenceableCollection >> asSettingPresenter: aSettingDeclaration [ 

	^ (StSettingDropListPresenterItem on: aSettingDeclaration)
		value: self;
		yourself
]
