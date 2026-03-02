Extension { #name : 'ThemeIcons' }

{ #category : '*NewTools-SettingsBrowser' }
ThemeIcons >> asSettingPresenter: aString  owner: aPresenter [

	^ SpDropListPresenter new
		items: { self };
		display: [ : e | e name ];		
		yourself
]
