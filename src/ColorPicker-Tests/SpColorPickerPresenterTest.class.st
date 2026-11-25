Class {
	#name : 'SpColorPickerPresenterTest',
	#superclass : 'TestCase',
	#category : 'ColorPicker-Tests',
	#package : 'ColorPicker-Tests'
}

{ #category : 'tests' }
SpColorPickerPresenterTest >> testDefaultLayoutIncludesToolbar [
	"Regression for pharo-project/pharo#20278: Select/Cancel toolbar must be part of the
	layout so the chosen color can be validated."

	| presenter layout |
	presenter := SpColorPickerPresenter basicNew.
	presenter initialize.
	layout := presenter defaultLayout.
	self assert: layout children size equals: 2.
	self assert: layout children second equals: (presenter instVarNamed: #toolbar).
	self assert: (presenter instVarNamed: #toolbar) items size equals: 2
]
