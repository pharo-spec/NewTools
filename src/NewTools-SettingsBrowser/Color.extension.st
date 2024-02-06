Extension { #name : 'Color' }

{ #category : '*NewTools-SettingsBrowser' }
Color >> asSettingPresenter: aSettingDeclaration [ 

	^ (StSettingSHStyleButtonColorPresenterItem on: aSettingDeclaration)
		buttonAction: [ aSettingDeclaration getColor ];
		whenColorChangedDo: [ self updateColor: aSettingDeclaration color ];
		yourself.
]
