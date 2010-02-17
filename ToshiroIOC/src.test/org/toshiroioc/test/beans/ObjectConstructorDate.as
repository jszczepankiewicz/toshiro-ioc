package org.toshiroioc.test.beans{
	
	public class ObjectConstructorDate{
		
		private var dateField:Date;
		
		public function ObjectConstructorDate(dateValue:Date){
			dateField = dateValue;
		}
		
		public function get date():Date{
			return dateField;
		}

	}
}