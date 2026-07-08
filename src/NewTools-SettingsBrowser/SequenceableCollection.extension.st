Extension { #name : 'SequenceableCollection' }

{ #category : '*NewTools-SettingsBrowser' }
SequenceableCollection >> asSettingPresenter: aSettingDeclaration owner: aPresenter [

	^ (aPresenter instantiate: StSettingDropListPresenterItem on: aSettingDeclaration)
		value: self;
		yourself
]
