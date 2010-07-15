package org.toshiroioc.test.beans{
	

	
	public class BeanIdMetatag{


		private var stringField:String;
		private var numberField:Number;
		private var beanIdField:String;
		private var beanId2Field:String;
		
		[BeanId]
		public function set beanId2Item(value:String):void{
			beanId2Field = value;
		}
		
		public function get beanId2Item():String{
			return beanId2Field;
		}

		[BeanId]
		public function set beanIdItem(value:String):void{
			beanIdField = value;
		}
		
		public function get beanIdItem():String{
			return beanIdField;
		}

		public function set stringItem(value:String):void{
			stringField = value;
		}
		
		public function get stringItem():String{
			return stringField;
		}
		
		public function set numberItem(value:Number):void{
			numberField = value;
		}
		
		public function get numberItem():Number{
			return numberField;
		}
	}
}