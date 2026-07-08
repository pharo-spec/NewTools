Class {
	#name : 'StSettingDetailPresenter',
	#superclass : 'StSettingsAbstractPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'settingPresenter'
	],
	#category : 'NewTools-SettingsBrowser-UI',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'UI'
}

{ #category : 'initialization' }
StSettingDetailPresenter >> asPath: aPath [
	
	aPath ifEmpty: [ ^ '' ].
	
	^ ('.' join: (aPath collect: #asString))
]

{ #category : 'layout' }
StSettingDetailPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: settingPresenter;
		yourself
]

{ #category : 'initialization' }
StSettingDetailPresenter >> initialize [

	super initialize.
	
	self announcer 
		when: StSettingModelChanged
		send: #updatePresenter
		to: self
]

{ #category : 'initialization' }
StSettingDetailPresenter >> initializePresenters [

	"this will be replaced when received a new setting"
	settingPresenter := self newLabel
]

{ #category : 'initialization' }
StSettingDetailPresenter >> newSettingPresenter: aNode [
	
	^ self newSettingPresenter: aNode path: #() children: aNode allChildren
]

{ #category : 'initialization' }
StSettingDetailPresenter >> newSettingPresenter: aNode path: aPath children: children [
	| general groups newSettingPresenter |

	general := children reject: #hasChildren.
	groups := general size ~= children size 
		ifTrue: [ children select: #hasChildren ]
		ifFalse: [ nil ].

	newSettingPresenter := (groups isNotNil and: [ aNode level > 1 ])
		ifTrue: [ 
			self newPresenter
				layout: (SpBoxLayout newVertical
					vAlignStart;
					in: [ :this | 
						this add: (self 
							newSettingSectionPresenter: aNode 
							path: aPath 
							children: general).
						groups withIndexDo: [ :each :index | 
							"recursive, because we don't know :P"
							this add: (self 
								newSettingPresenter: each 
								path: (aPath copyWith: index) 
								children: each allChildren) ] ];
					yourself);
				yourself ]
		ifFalse: [
			self newSettingSectionPresenter: aNode path: aPath children: general ].

	^ newSettingPresenter
]

{ #category : 'initialization' }
StSettingDetailPresenter >> newSettingSectionPresenter: aNode path: aPath children: aCollection [
	| newSettingPresenter headerPresenter |

	newSettingPresenter := self newPresenter 
		addStyle: 'settingPanel';
		addStyle: ('settingPanelLevel', aPath size asString);
		layout: (SpBoxLayout newTopToBottom
			vAlignStart;
			yourself);
		yourself.
		
	"Add a header"
	headerPresenter := aNode asPresenterOn: self.
	"(headerPresenter isKindOf: StSettingPresenterItem) 
		ifTrue: [ headerPresenter addStyle: headerPresenter headerStyle ]."
	newSettingPresenter layout add: (self newPresenter
		addStyle: 'settingHeader';
		addStyle: ('settingHeaderLevel', aPath size asString);
		layout: (SpBoxLayout newHorizontal 
			borderWidth: 3;
			spacing: 3;
			add: headerPresenter;
			"add: (self newLabel 
					addStyle: 'settingHeaderPath';
					label: (self asPath: aPath);
					yourself) 
				expand: false;"
			yourself);
		yourself).
	
	"now all settings"
	aCollection ifNotEmpty: [
		(aCollection sorted: #order ascending, #name ascending) withIndexDo: [ :eachNode :index |
			| presenter |
			presenter := eachNode asPresenterOn: self.
			presenter addStyle: ('level', aPath size asString).
			newSettingPresenter layout 
				add: (SpBoxLayout newLeftToRight
					borderWidth: 3;
					spacing: 3;
					add: presenter;
					yourself)
				expand: false ] ].
	
	^ aPath 
		ifNotEmpty: [
			self newPresenter
				layout: (SpBoxLayout newHorizontal
					"this is a hack, but it works :P"
					add: (self newLabel
						addStyle: 'settingsLevel', aPath size asString; 
						yourself)
						expand: false;
					add: (self newPresenter 
						addStyle: 'settingsCard', aPath size asString;
						layout: (SpBoxLayout newVertical
							add: newSettingPresenter;
							yourself);
						yourself);
					yourself)	 ] 
		ifEmpty: [ 
			newSettingPresenter ]
]

{ #category : 'initialization' }
StSettingDetailPresenter >> updatePresenter [
	| newSettingPresenter |

	self model ifNil: [ ^ self ].
	
	newSettingPresenter := self newPresenter 
		layout: (SpScrollableLayout with: (self newSettingPresenter: self model));
		yourself.

	self layout 
		replace: settingPresenter
		with: newSettingPresenter.
		
	settingPresenter := newSettingPresenter
]
