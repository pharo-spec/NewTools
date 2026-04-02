Extension { #name : 'LogicalFont' }

{ #category : '*NewTools-SettingsBrowser' }
LogicalFont >> asSettingPresenter: aSettingDeclaration owner: aPresenter [

	| info currentFont |

	currentFont := aSettingDeclaration target perform: aSettingDeclaration name.
	info := String streamContents: [ : stream |
		stream 
			<< currentFont textStyleName;
			<< ' (';
			<< currentFont pointSize asString;
			<< ')' ].
	
	^ (aPresenter instantiate: StSettingSHStyleButtonPresenterItem on: aSettingDeclaration)
		buttonLabel: info;
		buttonFont: currentFont realFont;
		buttonAction: [ aSettingDeclaration getFont ];
		yourself.
]
