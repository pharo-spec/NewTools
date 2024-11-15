Class {
	#name : 'StSettingsBrowserTest',
	#superclass : 'SpBasePresenterTest',
	#instVars : [
		'categoriesPresenter',
		'toolbarPresenter',
		'detailsPresenter'
	],
	#category : 'NewTools-SettingsBrowser-Tests',
	#package : 'NewTools-SettingsBrowser-Tests'
}

{ #category : 'running' }
StSettingsBrowserTest >> application [

	^  self classToTest currentApplication

]

{ #category : 'accessing' }
StSettingsBrowserTest >> classToTest [
	^ StSettingsMainPresenter
]

{ #category : 'running' }
StSettingsBrowserTest >> setUp [

	super setUp.	
	categoriesPresenter := presenter presenterAt: #mainCategoriesPresenter.
	toolbarPresenter := presenter presenterAt: #toolbarPresenter.
	detailsPresenter := presenter presenterAt: #detailsPresenter. 
]

{ #category : 'tests' }
StSettingsBrowserTest >> testCategoriesHasIcon [

	| categoryList |
	categoryList := categoriesPresenter categoryListPresenter.
	self
		assert: (categoryList presenters allSatisfy: [ : p | p iconPresenter isForm ])
		description: 'It tests that categories in the component list has an icon'.
		
	

]

{ #category : 'tests' }
StSettingsBrowserTest >> testCategoriesHasSystemSettingsPragma [

	self 
		assert: (categoriesPresenter settingsCategories allSatisfy: [ : node | node pragma key = #systemsettings ])
		description: 'It tests that there setting categories have a pragma named systemsettings'
	

]

{ #category : 'tests' }
StSettingsBrowserTest >> testCategoriesHasText [

	| categoryList |
	categoryList := categoriesPresenter categoryListPresenter.
	self
		assert: (categoryList presenters allSatisfy: [ : p | p labelPresenter label notEmpty ])
		description: 'It tests that categories in the component list has text'.

		
	

]

{ #category : 'tests' }
StSettingsBrowserTest >> testCategoriesRootParentsAreNotSet [

	self 
		assert: (categoriesPresenter settingsCategories allSatisfy: [ : node | node parentNode isNil ])
		description: 'It tests that all categories are root nodes'
	

]

{ #category : 'tests' }
StSettingsBrowserTest >> testDescriptionsAreString [

	self 
		assert: (categoriesPresenter settingsCategories allSatisfy: [ : node | node description isString ])
		description: 'It tests that categories are described by a String instance'
	

]

{ #category : 'tests' }
StSettingsBrowserTest >> testDetailsPresenterNotActivatedByDefault [

	self
		assert: (detailsPresenter presenterAt: #pageTitle) label isEmpty
		description: 'It tests that after the window is opened, there is no autoselection of a setting category by default'
]

{ #category : 'tests' }
StSettingsBrowserTest >> testHasCategories [

	self assert: categoriesPresenter isPresenter.
	
	self deny: categoriesPresenter settingsCategories isEmpty.

]

{ #category : 'tests' }
StSettingsBrowserTest >> testNonEmptyCategories [

	self assert: (categoriesPresenter settingsCategories allSatisfy: #hasChildren).

]

{ #category : 'tests' }
StSettingsBrowserTest >> testNonEmptyCategoryLabels [

	self 
		assert: (categoriesPresenter settingsCategories allSatisfy: [ : node | node label notEmpty ])
		description: 'It tests that there are no setting categories without an assigned name'
	

]

{ #category : 'tests' }
StSettingsBrowserTest >> testNonEmptyCategoryNames [

	self 
		assert: (categoriesPresenter settingsCategories allSatisfy: [ : node | node name notEmpty ])
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
StSettingsBrowserTest >> testSimulateCategorySelection [

	categoriesPresenter categoryListPresenter clickItem: 1.
	self 
		assert: categoriesPresenter categoryListPresenter selection selectedIndex
		equals: 1.
		
	self
		assert: (detailsPresenter presenterAt: #pageTitle) label notEmpty
		description: 'It tests that after a category selection has been made, the details presenter contains a title'
]

{ #category : 'tests' }
StSettingsBrowserTest >> testVisibleOpen [

	self assert: presenter isPresenter.
	self 
		assert: presenter isVisible
		description: 'It test that when the window is opened, it should be visible'

]
