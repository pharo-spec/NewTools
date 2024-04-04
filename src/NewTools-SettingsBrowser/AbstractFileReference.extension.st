Extension { #name : 'AbstractFileReference' }

{ #category : '*NewTools-SettingsBrowser' }
AbstractFileReference >> asSettingPresenter: aSettingDeclaration [ 

	| settingPresenterClass |
	
	settingPresenterClass := self isDirectory 
		ifTrue: [ StSettingDirectoryPresenterItem ]
		ifFalse: [ StSettingFilePresenterItem ].
	^ (settingPresenterClass on: aSettingDeclaration)
		value: self;
		yourself
]

{ #category : '*NewTools-SettingsBrowser' }
AbstractFileReference >> asText [

	^ self fullName
]
