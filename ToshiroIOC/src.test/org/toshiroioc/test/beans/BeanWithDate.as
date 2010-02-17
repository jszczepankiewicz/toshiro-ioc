package org.toshiroioc.test.beans
{
	public class BeanWithDate{
		private var dateField:Date;
		
		public function set date(dateValue:Date):void{
			dateField = dateValue;
		}
		
		public function get date():Date{
			return dateField;
		}

	}
}