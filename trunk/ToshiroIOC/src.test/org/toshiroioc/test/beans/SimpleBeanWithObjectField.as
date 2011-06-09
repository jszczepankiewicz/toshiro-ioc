package org.toshiroioc.test.beans{
	

	
	public class SimpleBeanWithObjectField{
		
		private var _objectField:Object;
		private var _simpleBean:SimpleBean

		public function get objectField():Object
		{
			return _objectField;
		}

		public function set objectField(value:Object):void
		{
			_objectField = value;
		}

		public function get simpleBean():SimpleBean
		{
			return _simpleBean;
		}

		public function set simpleBean(value:SimpleBean):void
		{
			_simpleBean = value;
		}


	}
}