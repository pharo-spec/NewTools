Class {
	#name : 'StWorldMenuPresenterVisitor',
	#superclass : 'Object',
	#instVars : [
		'presenter',
		'owner'
	],
	#category : 'NewTools-Toplo-Backend',
	#package : 'NewTools-Toplo',
	#tag : 'Backend'
}

{ #category : 'accessing' }
StWorldMenuPresenterVisitor >> owner: aStWorldPresenter [ 
	
	owner := aStWorldPresenter 

]

{ #category : 'accessing' }
StWorldMenuPresenterVisitor >> presenter: aSpMenuBarPresenter [ 
	presenter := aSpMenuBarPresenter
]

{ #category : 'as yet unclassified' }
StWorldMenuPresenterVisitor >> resolveActionFor: anItem [

	anItem action ifNotNil: [ :action | ^ owner wrapMenuAction: action ].

	anItem selector ifNotNil: [ :selector |
		^ owner wrapMenuAction: (MessageSend receiver: anItem target selector: selector) ].

	^ nil
]

{ #category : 'as yet unclassified' }
StWorldMenuPresenterVisitor >> resolveIconFor: anItem [ 
	
	anItem icon ifNotNil: [ :anIcon | ^ anIcon ].
	^ owner iconNamed: anItem iconName 
]

{ #category : 'visiting' }
StWorldMenuPresenterVisitor >> visit: aBuilderItem [

	^ aBuilderItem acceptVisitor: self
]

{ #category : 'visiting' }
StWorldMenuPresenterVisitor >> visitGroup: aGroup [

	presenter addGroup: [ :aMenuGroup | 
		self 
			withPresenter: aMenuGroup 
			do: [ aGroup subelements do: [ :e | self visit: e ] ] ]
]

{ #category : 'visiting' }
StWorldMenuPresenterVisitor >> visitItem: anItem [

	presenter addItem: [ :aMenuItem |
			aMenuItem
				name: anItem name;
				description: anItem help;
				icon: (self resolveIconFor: anItem);
				action: (self resolveActionFor: anItem).

			anItem keyText ifNotNil: [ :keyText | aMenuItem shortcut: keyText ].
			
			anItem subelements ifNotEmpty: [ :subelements |
				
				aMenuItem subMenu: owner newMenu.
				
				self 
					withPresenter: aMenuItem subMenu
					do: [ subelements do: [ :e | self visit: e ]]]]
]

{ #category : 'visiting' }
StWorldMenuPresenterVisitor >> visitRoot: aRoot [ 
	
	aRoot subelements do: [ :e | self visit: e ]
]

{ #category : 'visiting' }
StWorldMenuPresenterVisitor >> withPresenter: newPresenter do: aBlockClosure [ 

	| oldPresenter |
	
	oldPresenter := presenter.

	presenter := newPresenter.
		
	aBlockClosure ensure: [ presenter:= oldPresenter  ]
]
