Extension { #name : 'LogicalFont' }

{ #category : '*NewTools-SettingsBrowser' }
LogicalFont >> asSettingPresenter: aSettingDeclaration [ 

	| info currentFont |

	currentFont := StandardFonts perform: aSettingDeclaration name.
	info := String streamContents: [ : stream |
		stream 
			<< currentFont textStyleName;
			<< ' (';
			<< currentFont pointSize asString;
			<< ')' ].
	
	^ (StSettingSHStyleButtonPresenterItem on: aSettingDeclaration)
		buttonLabel: info;
		buttonFont: currentFont realFont;
		buttonAction: [ aSettingDeclaration getFont ];
		yourself.
]
