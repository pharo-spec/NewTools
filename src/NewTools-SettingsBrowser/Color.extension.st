Extension { #name : 'Color' }

{ #category : '*NewTools-SettingsBrowser' }
Color >> asSettingPresenter: aSettingDeclaration [ 

	| settingPresenter colorValue |
	
	colorValue := aSettingDeclaration targetSelector 
		ifNil: [ aSettingDeclaration realTarget perform: aSettingDeclaration name ]
		ifNotNil: [ 
			| settingsTarget |
			settingsTarget := aSettingDeclaration realTarget perform: aSettingDeclaration targetSelector.
			settingsTarget perform: aSettingDeclaration getSelector ].

	settingPresenter := (SpPresenter new instantiate: StSettingSHStyleButtonColorPresenterItem on: aSettingDeclaration).
	settingPresenter
		buttonAction: [ aSettingDeclaration getColorFor: settingPresenter ];
		buttonColor: colorValue;
		yourself.
	^ settingPresenter
]
