Extension { #name : 'Color' }

{ #category : '*NewTools-SettingsBrowser' }
Color >> asSettingColorForm [
	| form extent |
	
	extent := 48@16.
	form := Form extent: extent depth: 32.
	form getCanvas fillRectangle: (0@0 extent: extent) color: self.
	
	^ form
]

{ #category : '*NewTools-SettingsBrowser' }
Color >> asSettingPresenter: aSettingDeclaration owner: aPresenter [
	| settingPresenter colorValue |
	
	colorValue := aSettingDeclaration targetSelector 
		ifNil: [ aSettingDeclaration realTarget perform: aSettingDeclaration name ]
		ifNotNil: [ 
			| settingsTarget |
			settingsTarget := aSettingDeclaration realTarget perform: aSettingDeclaration targetSelector.
			settingsTarget perform: aSettingDeclaration getSelector ].

	settingPresenter := (aPresenter instantiate: StSettingSHStyleButtonColorPresenterItem on: aSettingDeclaration).
	settingPresenter
		buttonAction: [ aSettingDeclaration getColorFor: settingPresenter ];
		buttonColor: colorValue;
		yourself.
		
	^ settingPresenter
]
