Extension { #name : 'LogicalFont' }

{ #category : '*NewTools-SettingsBrowser' }
LogicalFont >> asSettingPresenter: aSettingDeclaration [ 

	| info |

	info := String streamContents: [ : stream |
		stream 
			<< self realFont textStyleName;
			<< ' (';
			<< self realFont pointSize asString;
			<< ')' ].
	
	^ (StSettingSHStyleButtonPresenterItem on: aSettingDeclaration)
		buttonLabel: info;
		buttonFont: self realFont;
		buttonAction: [ aSettingDeclaration getFont ];
		yourself.
]
