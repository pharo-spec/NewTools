Class {
	#name : 'StSettingsStyleContributor',
	#superclass : 'StPharoStyleContributor',
	#category : 'NewTools-SettingsBrowser-UI',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'UI'
}

{ #category : 'private - accessing' }
StSettingsStyleContributor >> headerColorForLevel: aNumber [

	^ self headerColors at: aNumber + 1
]

{ #category : 'private - accessing' }
StSettingsStyleContributor >> headerColors [

	^ self isDarkTheme 
		ifTrue: [ self headerColorsForDarkTheme ]
		ifFalse: [ self headerColorsForLightTheme ]
]

{ #category : 'private - accessing' }
StSettingsStyleContributor >> headerColorsForDarkTheme [
	| baseColor |

	baseColor := UITheme current borderColor.
	^  { 
		baseColor.
		baseColor darker.
		baseColor darker darker.
		baseColor darker darker darker.
		baseColor darker darker darker darker.
		baseColor darker darker darker darker darker.
	 }
]

{ #category : 'private - accessing' }
StSettingsStyleContributor >> headerColorsForLightTheme [
	| baseColor |

	baseColor := UITheme current borderColor.
	^  { 
		baseColor.
		baseColor lighter.
		baseColor lighter lighter.
		baseColor lighter lighter lighter.
		baseColor lighter lighter lighter lighter.
		baseColor lighter lighter lighter lighter lighter.
	 }
]

{ #category : 'testing' }
StSettingsStyleContributor >> isDarkTheme [
	
	"hacky, but works"
	^ UITheme current isKindOf: PharoDarkTheme
]

{ #category : 'styles' }
StSettingsStyleContributor >> styleSheetContribution [
	
	^ self variableColorStyleSheet, (SpStyleVariableSTONReader fromString: self styleSheetData)
]

{ #category : 'private' }
StSettingsStyleContributor >> styleSheetData [

	^ '.application [
.settingPanelLevel1 [ Container { #padding: 10 } ],
.settingHeader [ 
		Container { #borderWidth: 2 },
		Geometry { #minHeight: 30, #height: 30 },
		Draw { #backgroundColor: EnvironmentColor(#border) },
		.settingLabel [Font { #name : EnvironmentFont(#default), #size : 14 } ] ],
.labeledPresenter [ Container { #borderWidth: 2 } ],
.labeledPresenterLabel [ Geometry { #minWidth: 300, #width: 300 } ],
.labeledPresenterInput [ Geometry { #minWidth: 300, #width: 300 } ] 
]'.
]

{ #category : 'styles' }
StSettingsStyleContributor >> variableColorStyleSheet [

	^ SpStyle newApplication 
		addClass: 'settingHeaderLevel0' with: [ :aClass | aClass 
			addPropertyDrawWith: [ :draw | draw backgroundColor: (self headerColorForLevel: 0) ] ];
		addClass: 'settingHeaderLevel1' with: [ :aClass | aClass 
			addPropertyDrawWith: [ :draw | draw backgroundColor: (self headerColorForLevel: 1) ] ];
		addClass: 'settingHeaderLevel2' with: [ :aClass | aClass 
			addPropertyDrawWith: [ :draw | draw backgroundColor: (self headerColorForLevel: 2) ] ];
		addClass: 'settingHeaderLevel3' with: [ :aClass | aClass 
			addPropertyDrawWith: [ :draw | draw backgroundColor: (self headerColorForLevel: 3) ] ];
		addClass: 'settingHeaderLevel3' with: [ :aClass | aClass 
			addPropertyDrawWith: [ :draw | draw backgroundColor: (self headerColorForLevel: 4) ] ];
		yourself
]
