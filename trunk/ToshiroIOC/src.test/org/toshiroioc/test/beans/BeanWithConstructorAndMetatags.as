package org.toshiroioc.test.beans
{
	public class BeanWithConstructorAndMetatags{
		
		private var someNumberField:Number;
		private var someIntField:int;
		private var someUIntField:uint;
		private var someBooleanField:Boolean;
		private var someStringField:String;
		private var someStaticField:uint;
		private var someAdditionalStringField:String;
		private var someClassField:Class;
		
		public var secondBeforeMethod:Boolean;
		public var secondAfterMethod:Boolean;
		private var dependencyField:SimpleBean;
		private var numberField:Number;
		public var beforeConfigureMethodInvocation:Boolean;
		public var afterConfigureMethodInvocation:Boolean;
		
		[BeforeConfigure]
		public function methodBeforeConfigure():void{
			if (!numberField)
				beforeConfigureMethodInvocation = true;
		}
		
		[AfterConfigure]
		public function methodAfterConfigure():void{
			if (numberField)
				afterConfigureMethodInvocation = true;
		}
		
		[BeforeConfigure]
		public function secondBefore():void{
			if (!numberField)
				secondBeforeMethod = true;
		}
		
		[AfterConfigure]
		public function secondAfter():void{
			if (numberField)
				secondAfterMethod = secondBeforeMethod;
		}
		
		[Required]
		public function set dependencyItem(value:SimpleBean):void{
			dependencyField = value;	
		}
		
		public function get dependencyItem():SimpleBean{
			return dependencyField;
		} 
		
		public function set numberItem(value:Number):void{
			numberField = value;
		}
		
		public function get numberItem():Number{
			return numberField;
		}
		
		
		public function set someAdditionalString(field:String):void{
			this.someAdditionalStringField = field;
		}
		
		public function get someAdditionalString():String{
			return someAdditionalStringField;
		}
		
		public function BeanWithConstructorAndMetatags(
			someNumber:Number,
			someInt:int,
			someString:String,
			someBoolean:Boolean,
			someStatic:uint=0,
			someClass:Class=null
			){
				
				
				someNumberField = someNumber;
				someIntField = someInt;
				someStringField = someString;
				someBooleanField = someBoolean;
				someStaticField = someStatic;
				someClassField = someClass;
		}
		
		public function get someUInt():uint{
			return someUIntField;
		}
		
		public function get someBoolean():Boolean{
			return someBooleanField;
		}
		
		public function get someString():String{
			return someStringField;
		}
		
		public function get someNumber():Number{
			return someNumberField;
		}
		
		public function get someInt():int{
			return someIntField;
		}

		public function get someStatic():uint{
			return someStaticField;
		}
		
		public function get someClass():Class{
			return someClassField;
		}

	}
}