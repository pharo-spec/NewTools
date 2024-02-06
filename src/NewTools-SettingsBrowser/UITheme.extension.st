Extension { #name : 'UITheme' }

{ #category : '*NewTools-SettingsBrowser' }
UITheme class >> asSettingPresenter: aString [ 

	^ SpDropListPresenter new
		items: PolymorphSystemSettings uiThemeClassChoices;
		display: [ : e | e name ];
		yourself
]
