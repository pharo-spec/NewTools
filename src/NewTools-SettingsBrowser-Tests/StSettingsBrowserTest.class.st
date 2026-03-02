Class {
	#name : 'StSettingsBrowserTest',
	#superclass : 'SpBasePresenterTest',
	#instVars : [
		'categoriesPresenter',
		'toolbarPresenter',
		'detailsPresenter',
		'application'
	],
	#category : 'NewTools-SettingsBrowser-Tests',
	#package : 'NewTools-SettingsBrowser-Tests'
}

{ #category : 'running' }
StSettingsBrowserTest >> application [ 

	^ application ifNil: [ application := StPharoApplication new ]
]

{ #category : 'accessing' }
StSettingsBrowserTest >> classToTest [
	^ StSettingsBrowser
]

{ #category : 'running' }
StSettingsBrowserTest >> setUp [

	super setUp.	
	categoriesPresenter := presenter presenterAt: #categoriesPresenter.
	toolbarPresenter := presenter presenterAt: #toolbarPresenter.
	detailsPresenter := presenter presenterAt: #detailsPresenter. 
]

{ #category : 'running' }
StSettingsBrowserTest >> tearDown [ 

	application := nil.
	super tearDown
]

{ #category : 'tests' }
StSettingsBrowserTest >> testCategoriesRootParentsAreNotSet [

	self 
		assert: (categoriesPresenter roots allSatisfy: [ : node | node parentNode isNil ])
		description: 'It tests that all categories are root nodes'
]

{ #category : 'tests' }
StSettingsBrowserTest >> testDescriptionsAreString [

	self 
		assert: (presenter settingsTree nodeList allSatisfy: [ : node | node description isString ])
		description: 'It tests that categories are described by a String instance'
	

]

{ #category : 'tests' }
StSettingsBrowserTest >> testDetailsPresenterNotActivatedByDefault [

	self
		assert: detailsPresenter model isNil
		description: 'It tests that after the window is opened, there is no autoselection of a setting category by default'
]

{ #category : 'tests' }
StSettingsBrowserTest >> testHasCategories [

	self deny: categoriesPresenter roots isEmpty
]

{ #category : 'tests' }
StSettingsBrowserTest >> testNonEmptyCategories [

	self assert: (categoriesPresenter roots allSatisfy: #hasChildren).

]

{ #category : 'tests' }
StSettingsBrowserTest >> testNonEmptyCategoryLabels [

	self 
		assert: (categoriesPresenter roots allSatisfy: [ : node | node label notEmpty ])
		description: 'It tests that there are no setting categories without an assigned name'
	

]

{ #category : 'tests' }
StSettingsBrowserTest >> testNonEmptyCategoryNames [

	self 
		assert: (categoriesPresenter roots allSatisfy: [ : node | node name notEmpty ])
		description: 'It tests that there are no setting nodes without an assigned name'

]

{ #category : 'tests' }
StSettingsBrowserTest >> testSimulateCategoryPopulation [

	| childSettingsLayout |
	
	self skip.
	categoriesPresenter categoryListPresenter clickItem: 1.
	childSettingsLayout := detailsPresenter presenterAt: #settingsBox.
		
	"(Delay forSeconds: 5) wait." 
	self
		assert: childSettingsLayout children notEmpty
		description: 'It tests that after a category selection has been made, the details presenter contains a title'
]

{ #category : 'tests' }
StSettingsBrowserTest >> testVisibleOpen [

	self assert: presenter isPresenter.
	self 
		assert: presenter isVisible
		description: 'It test that when the window is opened, it should be visible'

]
