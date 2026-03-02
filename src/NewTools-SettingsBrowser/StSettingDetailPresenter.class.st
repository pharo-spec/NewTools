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
	
	^ ('.' join: (aPath collect: #asString)), ':'
]

{ #category : 'layout' }
StSettingDetailPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: settingPresenter;
		yourself
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
	| newSettingPresenter |

	newSettingPresenter := self newPresenter 
		addStyle: 'settingPanel';
		addStyle: ('settingPanelLevel', aPath size asString);
		layout: (SpBoxLayout newTopToBottom
			vAlignStart;
			yourself);
		yourself.
		
	"Add a header"
	newSettingPresenter layout add: (self newPresenter
		addStyle: 'settingHeader';
		addStyle: ('settingHeaderLevel', aPath size asString);
		layout: (SpBoxLayout newHorizontal 
			borderWidth: 3;
			spacing: 3;
			add: (self asPath: aPath) expand: false;
			add: (aNode asPresenterOn: self);
			yourself);
		yourself).
	
	"now all settings"
	aCollection ifNotEmpty: [
		(aCollection sorted: #order ascending, #name ascending) withIndexDo: [ :eachNode :index |
			| presenter |
			presenter := eachNode asPresenterOn: self.
			newSettingPresenter layout 
				add: (SpBoxLayout newLeftToRight
					borderWidth: 3;
					spacing: 3;
					add:  presenter;
					yourself)
				expand: false ] ].
	
	^ newSettingPresenter
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
