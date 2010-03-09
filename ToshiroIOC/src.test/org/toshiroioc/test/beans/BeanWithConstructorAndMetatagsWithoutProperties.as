package org.toshiroioc.test.beans
{
	public class BeanWithConstructorAndMetatagsWithoutProperties{
		
		private var someNumberField:Number;
		private var someIntField:int;
		private var someUIntField:uint;
		private var someBooleanField:Boolean;
		private var someStringField:String;
		
		public var secondBeforeMethod:Boolean;
		public var secondAfterMethod:Boolean;
		private var dependencyField:SimpleBean;
		private var numberField:Number;
		public var beforeConfigureMethodInvocation:Boolean;
		public var afterConfigureMethodInvocation:Boolean;
		
		[BeforeConfigure]
		public function methodBeforeConfigure():void{
				if(!afterConfigureMethodInvocation && !secondAfterMethod){
					beforeConfigureMethodInvocation = true;
				}
		}
		
		[AfterConfigure]
		public function methodAfterConfigure():void{
			if(beforeConfigureMethodInvocation && secondBeforeMethod){
				afterConfigureMethodInvocation = true;
			}
				
		}
		
		[BeforeConfigure]
		public function secondBefore():void{
			if(!afterConfigureMethodInvocation && !secondAfterMethod){
				secondBeforeMethod = true;
			}
		}
		
		[AfterConfigure]
		public function secondAfter():void{
			if(beforeConfigureMethodInvocation && secondBeforeMethod){
				secondAfterMethod = true;
			}
		}
		
		public function BeanWithConstructorAndMetatagsWithoutProperties(
			someNumber:Number,
			someInt:int,
			someString:String,
			someBoolean:Boolean
			){
				
				
				someNumberField = someNumber;
				someIntField = someInt;
				someStringField = someString;
				someBooleanField = someBoolean;
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

	}
}