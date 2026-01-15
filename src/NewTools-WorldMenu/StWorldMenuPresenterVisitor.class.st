"
I am a visitor to generate SpMenuPresenters from the worldMenu configuration.
You don't use me directly, but through:

```
StWorldMenuBuilder new buildMenuBarPresenterFor: ownerPresenter
```

Where *ownerPresenter* is the presenter that will have the menu
"
Class {
	#name : 'StWorldMenuPresenterVisitor',
	#superclass : 'Object',
	#instVars : [
		'presenter',
		'owner'
	],
	#category : 'NewTools-WorldMenu-Visitors',
	#package : 'NewTools-WorldMenu',
	#tag : 'Visitors'
}

{ #category : 'accessing' }
StWorldMenuPresenterVisitor >> owner: aStWorldPresenter [ 
	
	owner := aStWorldPresenter 

]

{ #category : 'accessing' }
StWorldMenuPresenterVisitor >> presenter: aSpMenuBarPresenter [ 
	presenter := aSpMenuBarPresenter
]

{ #category : 'private' }
StWorldMenuPresenterVisitor >> resolveActionFor: anItem [

	anItem action ifNotNil: [ :action | ^ owner wrapMenuAction: action ].

	anItem selector ifNotNil: [ :selector |
		^ owner wrapMenuAction: (MessageSend receiver: anItem target selector: selector) ].

	^ nil
]

{ #category : 'private' }
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
