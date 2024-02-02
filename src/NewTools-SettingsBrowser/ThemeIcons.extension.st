Extension { #name : 'ThemeIcons' }

{ #category : '*NewTools-SettingsBrowser' }
ThemeIcons >> asSettingPresenter: aString [ 

	^ SpDropListPresenter new
		items: { self };
		display: [ : e | e name ];		
		yourself
]
